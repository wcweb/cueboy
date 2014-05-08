package us.wcweb.Cueboy.view.components {
	//import com.demonsters.debugger.MonsterDebugger;

	import flash.text.TextFormat;
	import flash.text.TextField;

	import com.bit101.components.Label;
	import com.bit101.components.ListItem;
	import com.longtailvideo.jwplayer.utils.Strings;

	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;

	import us.wcweb.Cueboy.event.CueItemEvent;
	import us.wcweb.Cueboy.model.structElement.CuePointsItem;

	/**
	 * @author wcweb
	 */
	public class CueListItem extends ListItem {
		public var cuepoint : CuePointsItem;
		protected var _titleLabel : Label;
		protected var _timeLabel : Label;

		// override protected var _defaultColor : uint = 0x242424;
		// protected var _selectedColor : uint = 0xdddddd;
		// protected var _rolloverColor : uint = 0xeeeeee;
		public function CueListItem(parent : DisplayObjectContainer = null, xpos : Number = 0, ypos : Number = 0, data : Object = null) {
			super(parent, xpos, ypos, data);
		}

		protected override function addChildren() : void {
			super.addChildren();

			_timeLabel = new Label(this, 8, 8, "00:00");

			_timeLabel.textField.defaultTextFormat = new TextFormat('Arial', 16, 0xcfcfcf);

			_titleLabel = new Label(this, _timeLabel.width + _timeLabel.x + 18, 8, "title");

			_titleLabel.textField.defaultTextFormat = new TextFormat('Arial', 14, 0xcfcfcf);
			addEventListener(MouseEvent.CLICK, onClick);
			_label.visible = false;
		}

		public override function draw() : void {
			super.draw();

			graphics.clear();

			if (_selected) {
				graphics.beginFill(_selectedColor,0.5);
			} else if (_mouseOver) {
				graphics.beginFill(_rolloverColor,0.5);
			} else {
				graphics.beginFill(_defaultColor,0.5);
			}
			graphics.drawRect(0, 0, width, height);
			graphics.endFill();
			
			
			// MonsterDebugger.trace(this,data);
			if (!(data is String) && data != null) {
				if (data.hasOwnProperty("cuepoint")) {
					cuepoint = data.cuepoint;
					_titleLabel.textField.text = cuepoint.name;
					_timeLabel.textField.text = Strings.digits(cuepoint.time);
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
