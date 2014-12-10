package us.wcweb.Cueboy.view {
	import com.longtailvideo.jwplayer.utils.Logger;
	import com.longtailvideo.jwplayer.utils.Stretcher;
	import com.longtailvideo.jwplayer.utils.Strings;
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import mx.utils.NameUtil;
	import org.osflash.signals.DeluxeSignal;
	import org.osflash.signals.Signal;
	import org.osflash.signals.events.GenericEvent;
	import us.wcweb.Cueboy.event.CueItemEvent;
	import us.wcweb.Cueboy.model.structElement.CuePointsItem;





	/**
	 * @author wcweb.ian
	 */
	public class CueItem extends Sprite {
		/** Embedding the image assets. **/
		[Embed(source="../../../../../../assets/glow.png")]
		private const GlowSheet : Class;
		[Embed(source="../../../../../../assets/blank.png")]
		private const Blank : Class;
		[Embed(source="../../../../../../assets/cancel.png")]
		private const Cancel : Class;
		private var _deleteBtn : Sprite;
		private var _blank : DisplayObject;
		/** Background for the entire thumb. **/
		private var _back : Sprite;
		/** The handler to report clicks to. **/
		private var _click : Function;
		/** The related item that was loaded. **/
		private var _item : CuePointsItem;
		/** Container that imports the preview thumbnail **/
		private var _loader : Loader;
		private var _img : Sprite;
		/** Mask for the loader. **/
		private var _mask : Sprite;
		/** Graphic over the image. **/
		private var _glow : DisplayObject;
		/** Height of the thumb. **/
		private var _height : Number;
		/** Overlay between the image and text. **/
		private var _overlay : Sprite;
		/** Textfield that displays the title. **/
		private var _titleField : TextField;
		private var _positionField : TextField;
		private var _durationField : TextField;
		/** TextField formatting. **/
		private var _format : TextFormat;
		/** Width of the thumb. **/
		private var _width : Number;
		public var position : Number;
		public var title : String;
		public var itemId : Number;

		// public var clickSignal : Signal;
		// public var deleteSignal : DeluxeSignal;
		/**
		 * item should be cuepointsitem
		 */
		public function CueItem(width : Number, height : Number, item : CuePointsItem, id : Number) : void {
			_width = width;
			_height = height;
			_item = item;

			itemId = id;

			_back = new Sprite();
			_back.graphics.beginFill(0, 1);
			_back.graphics.drawRect(0, 0, width, height);
			_back.filters = new Array(new DropShadowFilter(0));
			addChild(_back);

			// TODO clip image
			/*			if (item['image'] !==  undefined ) {
			_img = new Sprite();
			_loader = new Loader();
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, _loaderHandler);
			_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, _errorLoadHandler);
			_loader.load(new URLRequest(item['image']));
			_img.addChild(_loader);

			addChild(_img);
			_mask = new Sprite();
			_mask.graphics.beginFill(0, 1);
			_mask.graphics.drawRect(1, 1, width - 2, height - 2);
			addChild(_mask);
			_loader.mask = _mask;
			}*/

			_glow = new GlowSheet();
			_glow.x = 1;
			_glow.y = 1;
			_glow.width = width - 2;
			_glow.scaleY = _glow.scaleX;
			addChild(_glow);

			

			// / seektime
			_positionField = new TextField();
			_positionField.width = width - 2;
			_positionField.height = 20;
			_positionField.x = 1;
			_positionField.y = 3;
			_positionField.wordWrap = true;
			_positionField.autoSize = "center";

			_format = new TextFormat('Arial', 12, 0xFFFFFF);
			_format.align = 'center';
			_format.leftMargin = 5;
			_format.rightMargin = 5;

			_positionField.defaultTextFormat = _format;

			_positionField.text = Strings.digits(_item.time);

			var _format2 : TextFormat = new TextFormat('Arial', 10, 0xFFFFFF);
			_format2.align = 'center';
			_format2.leftMargin = 2;
			_format2.rightMargin = 2;

			// //  title
			_titleField = new TextField();
			_titleField.width = width - 2;
			_titleField.height = 20;
			_titleField.y = 25;
			_titleField.multiline = true;
			_titleField.wordWrap = true;
			_titleField.autoSize = "center";
			_titleField.defaultTextFormat = _format2;
			_titleField.selectable = true;

			if (!isNaN(_item.duration)) {
				_durationField = new TextField();
				_durationField.width = width - 2;
				_durationField.height = 20;
				_durationField.x = 1;
				_durationField.y = 23;
				_durationField.wordWrap = true;
				_durationField.autoSize = "center";
				_durationField.defaultTextFormat = _format;

				_durationField.text = Strings.digits(_item.duration);
				_positionField.appendText("/" + _item.duration + "s") ;
				// _titleField.y = 45;

				// addChild(_durationField);
			}

			_titleField.text = _item.name ;

			addChild(_titleField);

			addChild(_positionField);

			if (_positionField.height > height * 2 / 3) {
				_positionField.autoSize = "none";
				_positionField.height = height - 8;
			}

			_overlay = new Sprite();
			_overlay.graphics.beginFill(0, 0.5);
			_overlay.graphics.drawRect(1, _positionField.y, width - 2, _positionField.height + 2);
			addChild(_overlay);

			// Logger.log('inside cueitem pass overlay');
			_deleteBtn = new Sprite();
			var can : DisplayObject = new Cancel();
			can.x = -8;
			can.y = -8;

			_deleteBtn.addChild(can);
			// addChild(_deleteBtn);
			// _deleteBtn.addEventListener(MouseEvent.CLICK, _deleteHandler);

			buttonMode = true;
			mouseEnabled = true;
			mouseChildren = false;

			addEventListener(MouseEvent.CLICK, _clickHandler);
			addEventListener(MouseEvent.MOUSE_OUT, _outHandler);
			addEventListener(MouseEvent.MOUSE_OVER, _overHandler);

			// clickSignal = new Signal(this);
			// deleteSignal = new DeluxeSignal(this);
		};
		
		public function scaleFont():void{
			var _format2 : TextFormat = new TextFormat('Arial', 18, 0xFFFFFF);
			_format2.align = 'center';
			_format2.leftMargin = 2;
			_format2.rightMargin = 2;
			_positionField.defaultTextFormat =_format2;
			_titleField.defaultTextFormat = _format2;
		}

		public function set Id(id : Number) : void {
			itemId = id;
		}

		public function get Id() : Number {
			return itemId;
		}

		public function get cuepointsItem() : CuePointsItem {
			return _item;
		}

		public function changeTitle(str : String) : void {
			_titleField.text = str;
		};

		private function _deleteHandler(e : MouseEvent) : void {
			// TODO should it be this ?
			// dispatchEvent(new CueCRUDEvent(CueCRUDEvent.DELETE_ITEM, this, 'delete'));
			// deleteSignal.dispatch(new GenericEvent());
		}

		/** Redirect on thumb click. **/
		private function _clickHandler(event : MouseEvent) : void {
			// TODO  dispatchEvent(new CueItemEvent(CueItemEvent.CLICK_ITEM, _item, 'click')); can't work.
			dispatchEvent(new CueItemEvent(CueItemEvent.CLICK_ITEM, _item, 'click'));
			// clickSignal.dispatch();
			
			// _click(_item);
		};

		/** Fade the image when loaded. **/
		/*		private function _loaderHandler(event : Event) : void {
		try {
		Bitmap(_loader.content).smoothing = true;
		} catch(e : Error) {
		}
		Stretcher.stretch(_loader, _width, _height, Stretcher.FILL);
		};*/
		/** Redirect on thumb click. **/
		private function _outHandler(event : MouseEvent) : void {
			_back.graphics.clear();
			_back.graphics.beginFill(0, 1);
			_back.graphics.drawRect(0, 0, _width, _height);
			_back.filters = new Array(new DropShadowFilter(0));
		};

		/** Redirect on thumb click. **/
		private function _overHandler(event : MouseEvent) : void {
			_back.graphics.clear();
			_back.graphics.beginFill(0x000000, 0.3);
			_back.graphics.drawRect(0, 0, _width, _height);
			_back.filters = new Array(new DropShadowFilter(0, 45, 0xFFFFFF));
		};

		private function _errorLoadHandler(event : Event) : void {
			// _blank = new Blank();
			// _blank.x = 1;
			// _blank.y = 1;
			// _blank.width = _width / 2;
			// _blank.scaleY = _blank.scaleX;
			// _img.addChild(_blank);
		}
	}
}
