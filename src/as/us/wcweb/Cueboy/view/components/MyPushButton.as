package us.wcweb.Cueboy.view.components {
	import flash.text.TextFormat;
	import com.bit101.components.PushButton;

	import flash.display.DisplayObjectContainer;

	/**
	 * @author wcweb
	 */
	public class MyPushButton extends PushButton {
		public function MyPushButton(parent : DisplayObjectContainer = null, xpos : Number = 0, ypos : Number = 0, label : String = "", defaultHandler : Function = null) {
			super(parent, xpos, ypos, label, defaultHandler);
		}

		override public function draw() : void {
			super.draw();
			_label.text = _labelText;
			_label.textField.defaultTextFormat = new TextFormat('Arial', 13, 0xcfcfcf);
			_label.draw();

		}
	}
}
