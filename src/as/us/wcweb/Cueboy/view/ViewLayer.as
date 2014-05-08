package us.wcweb.Cueboy.view {
	import com.bit101.components.Style;

	import us.wcweb.Cueboy.view.components.MyPushButton;

	import com.demonsters.debugger.MonsterDebugger;
	import com.bit101.components.Text;
	import com.bit101.components.PushButton;
	import com.bit101.charts.BarChart;

	import caurina.transitions.Tweener;

	import com.bit101.components.CheckBox;
	import com.bit101.components.Panel;
	import com.bit101.components.RadioButton;
	import com.bit101.components.Window;
	import com.carlcalderon.arthropod.Debug;
	import com.longtailvideo.jwplayer.events.MediaEvent;
	import com.longtailvideo.jwplayer.events.PlayerStateEvent;
	import com.longtailvideo.jwplayer.events.PlaylistEvent;
	import com.longtailvideo.jwplayer.player.IPlayer;
	import com.longtailvideo.jwplayer.player.Player;
	import com.longtailvideo.jwplayer.plugins.IPlugin;
	import com.longtailvideo.jwplayer.plugins.PluginConfig;
	import com.longtailvideo.jwplayer.utils.Animations;
	import com.longtailvideo.jwplayer.utils.Logger;
	import com.longtailvideo.jwplayer.utils.Strings;

	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.GradientType;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.SecurityErrorEvent;
	import flash.filters.DropShadowFilter;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.utils.setTimeout;

	import us.wcweb.Cueboy.Cueboy;
	import us.wcweb.Cueboy.command.CueItemHandler;
	import us.wcweb.Cueboy.event.CueItemEvent;
	import us.wcweb.Cueboy.event.ViewLayerEvent;
	import us.wcweb.Cueboy.model.CueWithServer;
	import us.wcweb.Cueboy.model.XmlParser;
	import us.wcweb.Cueboy.model.config.ViewLayerConfig;
	import us.wcweb.Cueboy.model.structElement.CuePointsItem;
	import us.wcweb.Cueboy.view.components.CheckBoxDark;

	/**
	 * @author Administrator
	 */
	public class ViewLayer extends Sprite implements IViewer {
		/** Embedding the image assets. **/
		[Embed(source="../../../../../../assets/sheet.png")]
		private const BackSheet : Class;
		[Embed(source="../../../../../../assets/replay.png")]
		private const ReplayButton : Class;
		[Embed(source="../../../../../../assets/close.png")]
		private const CloseButton : Class;
		/** Reference to the background sheet. **/
		private var _back : Sprite;
		/** Reference to the dock button. **/
		/** Clip with all graphics. **/
		private var _container : MovieClip;
		/** Default dimensions for the grid. **/
		private var _dimensions : Array = [120, 40, 500, 700];
		/** The CTA text heading. **/
		private var _heading : TextField;
		/** Reference to the replay button. **/
		private var _replay : Sprite;
		/** Reference to the close button. **/
		private var _close : Sprite;
		/** edit cue boy **/
		private var _editLayer : Sprite;
		private var _editable : Boolean;
		private var _input : TextField;
		private var _editButton : Sprite;
		private var _replayFun : Function;
		private var _clickFun : Function;
		[Embed(source="../../../../../../assets/left.png")]
		private const LeftArrow : Class;
		[Embed(source="../../../../../../assets/right.png")]
		private const RightArrow : Class;
		private var _next_btn : Sprite;
		private var _prew_btn : Sprite;
		private var _mask : Sprite;
		private var _pageNum : int;
		private var _pageTotal : int;
		private var _data : Object;
		private var _col : Number;
		private var _row : Number;
		private var _editFun : Function;
		private var _items : Array;
		private var _itemsNum : int;
		private var _watch : MovieClip;
		private var _watch_input : TextField;
		private var _editlabels : TextField;
		private var _navBar : Sprite;
		private var _bar : Sprite;
		private var _drag : Boolean;
		private var	_navBarObj : Object;
		private var _flashMsg : Sprite;
		private var _flashText : TextField;
		private var _tooBig : Boolean;
		private var _fullScreenStatue : Boolean = false;
		public var repeatCheckBox : CheckBoxDark;
		/** The grid with all thumbs. **/
		public var grid : CueGrid;
		private var _win : Window;
		public var closeBtn : PushButton;
		public var replayBtn : PushButton;
		public var title : TextField;
		public var introduction : TextField;
		public var mycolor : Number;
		public var panel : Panel;

		public function	ViewLayer(config : ViewLayerConfig) {
			// event function outside this class
			// _clickFun = config.click;
			// _replayFun = config.replay;

			// init vars
			_editable = false;

			_items = new Array();

			// Add the background.
			_container = new MovieClip();
			_container.alpha = 0;

			var img : * = new BackSheet();
			var mtx : Matrix = new Matrix();
			var bmp : BitmapData = new BitmapData(img.width, img.height, false, 0xececec);
			bmp.draw(img, mtx);
			_back = new Sprite();
			_back.addChild(new BackSheet());
			_back.graphics.beginBitmapFill(bmp, mtx, true, true);
			_back.addEventListener(MouseEvent.CLICK, _backHandler);
			_container.addChild(_back);
			Style.setStyle("dark");
			panel = new Panel(_container);
			panel.color = 0x242424;

			closeBtn = new MyPushButton(panel, 0, 0, "关闭");

			closeBtn.addEventListener(MouseEvent.CLICK, _backHandler);

			new Animations(_container).fade(0, 0.2);
			// _container.visible = false;

			grid = new CueGrid(panel);

			grid.x = 20;
			grid.y = 40;
			grid.dimensions = _dimensions;

			// grid.addEventListener(CueItemEvent.CLICK_ITEM_IN_VIEW, _clickHandler);
			grid.addEventListener(CueItemEvent.CLICK_ITEM, _clickHandler);
			grid.addEventListener(ViewLayerEvent.UPDATE_LAYER, _updateLayerHandler);
			// _container.addChild(grid);
			// addChild(grid);

			// _mask = new Sprite();
			// grid.mask = _mask;
			// _container.addChild(_mask);

			// Add the replay and close buttons.
			// _replay = new Sprite();
			// _replay.buttonMode = true;
			// _replay.addChild(new ReplayButton());
			// _replay.addEventListener(MouseEvent.CLICK, _replayHandler);
			// _container.addChild(_replay);
			//
			// _close = new Sprite();
			// _close.buttonMode = true;
			// _close.addChild(new CloseButton());
			// _close.addEventListener(MouseEvent.CLICK, _backHandler);
			// _container.addChild(_close);

			// Add the text heading.
			title = new TextField();
			title.height = 20;
			title.wordWrap = true;
			title.defaultTextFormat = new TextFormat('Arial', 16, 0x777b10);
			title.autoSize = 'center';
			title.multiline = false;
			title.selectable = true;
			// _heading.filters = new Array(new DropShadowFilter(1, 45, 0, 1, 1, 1, 1));
			title.htmlText = config.title;
			_container.addChild(title);

			introduction = new TextField();
			introduction.height = 200;
			introduction.wordWrap = true;
			introduction.defaultTextFormat = new TextFormat('Arial', 12, 0xcfcfcf);
			introduction.autoSize = 'center';
			introduction.multiline = true;
			introduction.selectable = true;
			// _heading.filters = new Array(new DropShadowFilter(1, 45, 0, 1, 1, 1, 1));
			introduction.htmlText = config.introduction;
			_container.addChild(introduction);

			// introduction = new Text(panel, 100, 0);
			// introduction.textField.defaultTextFormat = new TextFormat('Arial', 16, 0x000000);
			// introduction.html = true;

			// introduction.text= config.introduction;

			repeatCheckBox = new CheckBoxDark(panel, 10, 5, null, null, config.color);

			repeatCheckBox.selected = config.repeat;

			if (repeatCheckBox.selected) {
				repeatCheckBox.label = '点击关闭循环时间段';
			} else {
				repeatCheckBox.label = '点击开启循环时间段';
			}
			repeatCheckBox.addEventListener(MouseEvent.CLICK, _repeatCheckHandler);
			// _container.addChild(repeatCheckBox);
			// _win.addChild(repeatCheckBox);
			// Logger.log("_repeatCueBox"+repeatCheckBox);
			// Logger.log("_repeatCueBox.selected = "+repeatCheckBox.selected);

			// Add the grid for thumbs
			buttonMode = true;
			mouseEnabled = true;
			mouseChildren = true;
			addChild(_container);

			addEventListener(ViewLayerEvent.SHOW_LAYER, _showLayerHandler);
			addEventListener(ViewLayerEvent.HIDE_LAYER, _hide_layer);
			addEventListener(ViewLayerEvent.LOADED_DATA, _paresDataHandler);
			addEventListener(ViewLayerEvent.RESIZE_LAYER, _resizeLayerHandler);
			addEventListener(ViewLayerEvent.FULLSCREEN_TOGGLE, _fullScreenHandler);
		}

		/**
		 * MouseEvent dock,back,replay, outside
		 * 
		 */
		private function _backHandler(evt : MouseEvent) : void {
			// _backFun();
			// Logger.log("i get it is going to hide!! ");
			dispatchEvent(new ViewLayerEvent(ViewLayerEvent.BACKTO_PLAYER, null));
		};

		private function _replayHandler(evt : MouseEvent) : void {
			dispatchEvent(new ViewLayerEvent(ViewLayerEvent.REPLAY_PLAYER, null));
		};

		public function _hide_layer(e : ViewLayerEvent) : void {
			_back.alpha = 0;
			new Animations(_container).fade(0, 0.2);
		}

		private function _repeatCheckHandler(e : MouseEvent) : void {
			if (repeatCheckBox.selected) {
				repeatCheckBox.label = '点击关闭循环时间段';
			} else {
				repeatCheckBox.label = '点击开启循环时间段';
			}

			dispatchEvent(new ViewLayerEvent(ViewLayerEvent.REPEAT_CHECKBOX, repeatCheckBox.selected));
		}

		private function _clickHandler(e : CueItemEvent) : void {
			// _clickFun(e.item);
			dispatchEvent(new CueItemEvent(CueItemEvent.CLICK_ITEM, e.item, "fuck click"));
		}

		private function _showLayerHandler(e : ViewLayerEvent) : void {
			if (!isNaN(e.data['position'])) {
				setPosition(e.data['position']);
			}

			_back.alpha = 1;
			new Animations(_container).fade(1, 0.2);
		}

		public function setPosition(pos : Number) : void {
			// display current time title.
			// _input.text = '';
			// if (_items.length) {
			// for (var k : int = 0;k < _items.length;k++) {
			// if (pos == Number(_items[k].position)) {
			// var sam : CueItem = _items[k];
			// _input.text = _items[k].title;
			// }
			// }
			// }
			//
			// _watch_input.text = "当前时间是 : " + Strings.digits(pos);
		}

		// private function _addNewCuePoint(e : MouseEvent) : void {
		//			//  info layer
		// if (_input.text == '') {
		// _showFlash('还没填写当前时间点名称。');
		// } else {
		// _editFun(_input.text);
		// }
		// }
		public function _paresDataHandler(e : ViewLayerEvent) : void {
			MonsterDebugger.trace(this, e.data);
			grid.parse(e.data as Array);
			// dispatchEvent(new ViewLayerEvent(ViewLayerEvent.UPDATE_LAYER, null));
		}

		// public function addNewItem(d : Object, msg : String) : void {
		//			//  /  Boolean(d['success']); awlays be ture;
		// if (d.success == "true") {
		// var exist : Boolean = false;
		// for (var k : int = 0;k < _items.length;k++) {
		// if (Strings.digits(d['position']) == Strings.digits(_items[k].position)) {
		//						//  TODO  if mutiply edit
		// var sam : CueItem = _items[k];
		// exist = true;
		// }
		// }
		//
		// if (!exist) {
		//					//  there are no necessarly a object here?
		// var data : CuePointsItem = new CuePointsItem(d['descript'], d['position'], d['duration']);
		//
		// var thumb : CueItem = new CueItem(_dimensions[0], _dimensions[1], data, _items.length + 1);
		// _items.push(thumb);
		// dispatchEvent(new ViewLayerEvent(ViewLayerEvent.RESIZE_LAYER, _dimensions));
		// grid.addChild(thumb);
		// } else {
		// sam.changeTitle(d['descript']);
		// _showFlash('更新成功');
		// }
		// }
		// _showFlash(msg);
		// }
		private function _updateLayerHandler(e : ViewLayerEvent) : void {
			_resizeLayerHandler(new ViewLayerEvent(ViewLayerEvent.RESIZE_LAYER, _dimensions));
			Logger.log("update viewlayerHandler" + e.target);
		}

		private function _resizeLayerHandler(e : ViewLayerEvent) : void {
			_dimensions = e.data as Array;
			Logger.log("resize in viewlayer _dimensions"+_dimensions);
			MonsterDebugger.log("resize in viewlayer _dimensions",_dimensions);
			var	width : Number = _dimensions[2],
			height : Number = _dimensions[3];

			_back.width = width;
			_back.height = height;

			grid.x = 20;
			grid.y = 40;
			grid.dimensions = _dimensions;

			// _mask.graphics.clear();
			// _mask.graphics.beginFill(0, 1);
			// _mask.graphics.drawRect(10, 10, width - 10, height - 20);

			// _win.width = width*0.8;
			// _win.height = height*0.8;
			// panel.x = _heading.x + _heading.width + 20;
			// panel.y = _heading.y + 5;
			// repeatCheckBox.x = _heading.x + _heading.width + 20;
			// repeatCheckBox.y = _heading.y+10;
			panel.setSize(width * .8, height * .8);
			panel.x = (width - panel.width) / 2;
			panel.y = (height - panel.height) / 2;

			if (_fullScreenStatue) {
				grid.fullScreenResize();
				// panel.scaleX = 1.5;
				// panel.scaleY = 1.5;

				title.setTextFormat(new TextFormat('Arial', 26, 0x777b10));
				// scale(title, 1.5);
				// introduction.y = title.y + title.height + 30;
				// scale(introduction, 1.5);
				introduction.setTextFormat(new TextFormat('Arial', 22, 0xcfcfcf));
			} else {
				grid.resize();
				// scale(title);
				// introduction.y = title.y + title.height + 30;
				title.setTextFormat(new TextFormat('Arial', 16, 0x777b10));
				introduction.setTextFormat(new TextFormat('Arial', 12, 0xcfcfcf));
				// scale(introduction);
				// panel.scaleX = 1;
				// panel.scaleX = 1;
			}

			title.x = panel.x + panel.width * (1 - .618) + 20;
			title.y = panel.y + 10;
			title.width = panel.width * .618 - 25;

			introduction.x = panel.x + panel.width * (1 - .618) + 20;
			introduction.y = panel.y + 50;
			introduction.width = panel.width * .618 - 25;
			introduction.height = 150;
			introduction.scrollH = int(panel.height * (1 - .618));

			var posX : Number = panel.width * .95,
			posY : Number = panel.height * .9;

			closeBtn.x = posX - closeBtn.width - 10;
			closeBtn.y = posY;
			repeatCheckBox.x =  panel.x + panel.width * (1 - .618) + 20;
			repeatCheckBox.y = posY - repeatCheckBox.height - 10;

			// grid.mask = _mask;s
			// if (_fullScreenStatue) {
			// grid.fullScreenResize();
			//				//  panel.scaleX = 1.5;
			//				//  panel.scaleY = 1.5;
			//
			//				//  title.defaultTextFormat = new TextFormat('Arial', 26, 0x777b10);
			// scale(title,1.5);
			// introduction.y = title.y + title.height + 30;
			// scale(introduction,1.5);
			//				//  introduction.defaultTextFormat = new TextFormat('Arial', 22, 0x777b10);
			// } else {
			// grid.resize();
			//				//  panel.scaleX = 1;
			//				//  panel.scaleX = 1;
			// }

			// if (_editable) {
			// _editLayer.x = Math.round(width / 2 - _editLayer.width / 2);
			// _editLayer.y = Math.round(height - _editLayer.height / 2 - 30);
			//
			// if (_flashMsg !== null) {
			// _flashMsg.x = Math.round(width / 2 - _flashMsg.width / 2);
			// _flashMsg.y = Math.round(height - _flashMsg.height / 2) - 130;
			// }
			// }

			// if (_navBar !== null) {
			// var scal : Number = width * 600 / grid.width;
			//				//  _container.removeChild(_navBar);
			// _navBar.graphics.clear();
			// _navBar.graphics.beginFill(0xffffff, 0.3);
			// _navBar.graphics.drawRect(0, 0, scal, 5);
			//
			//				//  _container.addChild(_navBar);
			//				//  trace('Math.round(width / 2 - _navBar.width / 2) === ' + Math.round(width / 2 - _navBar.width / 2));
			// _navBar.x = Math.round(width / 2 - _navBar.width / 2);
			// _navBar.y = height - 60;
			//
			//				//  _navBar.addChild();
			// }
		};

		private function scale(obj : *, time : Number = 1) : void {
			DisplayObject(obj).scaleX = time;
			DisplayObject(obj).scaleY = time;
		}

		private function _fullScreenHandler(e : ViewLayerEvent) : void {
			fullScreenHandler(Boolean(e.data));
		}

		public function fullScreenHandler(bool : Boolean) : void {
			_fullScreenStatue = bool;
		}
		/**
		 * Utils function
		 * 
		 */
		// private function _showFlash(str : String) : void {
		// _flashText.text = str;
		// _flashMsg.graphics.clear();
		// _flashMsg.graphics.beginFill(0xFFFFFF, 1);
		// _flashMsg.graphics.drawRoundRect(0, 0, _flashText.width, _flashText.textHeight + 10, 5);
		//
		// Tweener.addTween(_flashMsg, {alpha:1, y:_flashMsg.y + 10, visible:true, time:5});
		//			//  TODO tween callback not setTimeout
		// setTimeout(_hideFlash, 6000);
		// }
		//
		// private function _hideFlash() : void {
		// Tweener.addTween(_flashMsg, {alpha:0, y:_flashMsg.y - 10, visible:false, time:5});
		// }
		//
		// public function editable(bool : Boolean, edit : Function) : void {
		// _editable = bool;
		// _editFun = edit;
		// if (_editable) {
		// var _format2 : TextFormat = new TextFormat('Arial', 12, 0x000000);
		// _format2.align = 'left';
		// _format2.leftMargin = 2;
		// _format2.rightMargin = 5;
		//
		// var _format3 : TextFormat = new TextFormat('Arial', 12, 0x000000);
		// _format3.align = 'center';
		// _format3.leftMargin = 5;
		// _format3.rightMargin = 5;
		//
		// _flashMsg = new Sprite();
		//
		// _flashText = new TextField();
		// _flashText.wordWrap = true;
		// _flashText.autoSize = "center";
		// _flashText.defaultTextFormat = _format3;
		// _flashText.text = 'display messge here!';
		// _flashMsg.addChild(_flashText);
		//
		// _flashMsg.graphics.beginFill(0xFFFFFF, 1);
		// _flashMsg.graphics.drawRoundRect(0, 0, _flashText.width, _flashText.textHeight + 28, 5);
		// _flashMsg.visible = false;
		// _container.addChild(_flashMsg);
		//
		// _flashMsg.x = Math.round(width / 2 - _flashMsg.width / 2);
		// _flashMsg.y = Math.round(height - _flashMsg.height / 2) - 130;
		//
		// _watch_input = new TextField();
		// _watch_input.text = '';
		// _watch_input.height = 20;
		// _watch_input.width = 120;
		// _watch_input.defaultTextFormat = _format2;
		//
		// _watch = new MovieClip();
		// _watch.x = 0;
		// _watch.y = 0;
		// _watch.graphics.clear();
		// _watch.graphics.beginFill(0xccFFFFFF, 0.3);
		// _watch.graphics.lineStyle(1, 0x000000, 1);
		// _watch.graphics.drawRect(0, 0, 120, 20);
		// _watch.filters = new Array(new DropShadowFilter(0, 45, 0xFFFFCC));
		// _watch.addChild(_watch_input);
		//
		// var lbl : TextField = new TextField();
		// lbl.width = 40;
		// lbl.height = 20;
		// lbl.x = 0;
		// lbl.y = 0;
		// lbl.defaultTextFormat = _format2;
		// lbl.text = "名称：";
		//
		// _input = new TextField();
		// _input.type = TextFieldType.INPUT;
		// _input.x = lbl.width;
		// _input.y = 0;
		// _input.width = 120;
		// _input.height = 20;
		// _input.defaultTextFormat = _format2;
		// _input.multiline = true;
		//
		// var _inputwrap : Sprite = new Sprite();
		// _inputwrap.graphics.clear();
		// _inputwrap.graphics.beginFill(0xccFFFFFF, 0.3);
		// _inputwrap.graphics.lineStyle(1, 0x000000, 1);
		// _inputwrap.graphics.drawRect(0, 0, 200, 20);
		// _inputwrap.filters = new Array(new DropShadowFilter(0, 45, 0xFFFFFF));
		//
		// _inputwrap.addChild(lbl);
		// _inputwrap.addChild(_input);
		//
		// _inputwrap.x = _watch.width + 10;
		// _inputwrap.y = 0;
		//
		// _editButton = new Sprite();
		// _editlabels = new TextField();
		// _editlabels.type = TextFieldType.DYNAMIC;
		// _editlabels.defaultTextFormat = _format2;
		// _editlabels.text = "  提交 ";
		//
		// _editlabels.x = 0;
		// _editlabels.width = 40;
		// _editlabels.height = 20;
		// _editlabels.y = 0;
		// _editButton.addChild(_editlabels);
		//
		// _editButton.buttonMode = true;
		// _editButton.mouseChildren = false;
		// _editButton.x = _inputwrap.x + _inputwrap.width + 10;
		// _editButton.y = 0;
		// _editButton.graphics.clear();
		// _editButton.graphics.beginFill(0xFFFFFF, 0.3);
		// _editButton.graphics.lineStyle(1, 0x000000, 1);
		// _editButton.graphics.drawRect(0, 0, 40, 20);
		// _editButton.filters = new Array(new DropShadowFilter(0, 45, 0xFFFFFF));
		//
		// _editButton.addEventListener(MouseEvent.CLICK, _addNewCuePoint);
		//
		// _editLayer = new Sprite();
		// _editLayer.addChild(_watch);
		// _editLayer.addChild(_editButton);
		// _editLayer.addChild(_inputwrap);
		//
		// _container.addChild(_editLayer);
		//
		// _editLayer.x = Math.round(width / 2);
		// _editLayer.y = Math.round(height / 2 - _editLayer.height) - 80;
		// }
		// }
	}
}
