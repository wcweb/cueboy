package us.wcweb.Cueboy.view.components {
	import flash.text.TextFieldAutoSize;
	import us.wcweb.Cueboy.event.CueItemEvent;

	import com.longtailvideo.jwplayer.utils.Strings;

	import flash.events.MouseEvent;
	import flash.text.TextFormat;

	import us.wcweb.Cueboy.model.structElement.CuePointsItem;

	import com.bit101.components.Label;
	import com.bit101.components.ListItem;

	import flash.display.DisplayObjectContainer;

	/**
	 * @author wcweb
	 */
	public class DarkCueListItem extends ListItem {
		public var cuepoint : CuePointsItem;
		protected var _titleLabel : Label;
		protected var _timeLabel : Label;

		public function DarkCueListItem(parent : DisplayObjectContainer = null, xpos : Number = 0, ypos : Number = 0, data : Object = null) {
			super(parent, xpos, ypos, data);
		}

		protected override function addChildren() : void {
			super.addChildren();
			
			_label.visible = false;
			
			
			_timeLabel = new Label(this, 80, 8, "00:00");
			_timeLabel.autoSize = true;
			
			_timeLabel.textField.autoSize = TextFieldAutoSize.LEFT;
			_timeLabel.textField.defaultTextFormat = new TextFormat('Arial', 16, 0xcfcfcf);

			_titleLabel = new Label(this, 0, _timeLabel.height + _timeLabel.y + 10, "title");

			_titleLabel.textField.defaultTextFormat = new TextFormat('Arial', 14, 0xcfcfcf);
			_titleLabel.autoSize = false;
			_titleLabel.textField.autoSize = TextFieldAutoSize.CENTER;
			_titleLabel.textField.multiline = true;
			_titleLabel.textField.wordWrap= true;
			_titleLabel.textField.scrollH = height- _timeLabel.height -10;
			
			
			
			addEventListener(MouseEvent.CLICK, onClick);
			
		}

		public override function draw() : void {
			super.draw();

			graphics.clear();
			
			
//			_timeLabel.textField.width = width;
//			_timeLabel.textField.autoSize = TextFieldAutoSize.CENTER;
////			
			_titleLabel.textField.width = width;
			_titleLabel.textField.autoSize = TextFieldAutoSize.CENTER;
			_titleLabel.textField.scrollH = height- _timeLabel.height -10;
//			
//			
			
			if (_selected) {
				graphics.beginFill(_selectedColor, 0.5);
			} else if (_mouseOver) {
				graphics.beginFill(_rolloverColor, 0.5);
			} else {
				graphics.beginFill(_defaultColor, 0.5);
			}
			graphics.drawRect(0, 0, width, height);
			graphics.endFill();

			// MonsterDebugger.trace(this,data);
			if (!(data is String) && data != null) {
				if (data.hasOwnProperty("cuepoint")) {
					cuepoint = data.cuepoint;
//					if(_timeLabel.textField.text != Strings.digits(cuepoint.time) ){
						_timeLabel.textField.text = Strings.digits(cuepoint.time);
						_titleLabel.textField.text = cuepoint.name;
//					}
					
					
				}
			}
		}

		override public function get defaultColor() : uint {
			return 0x242424;
		}

		override public function get selectedColor() : uint {
			return 0xdddddd;
		}

		override public function get rolloverColor() : uint {
			return 0xffffff;
		}

		protected function onClick(event : MouseEvent) : void {
			dispatchEvent(new CueItemEvent(CueItemEvent.CLICK_ITEM, cuepoint, "fuck click"));
		}
	}
}
