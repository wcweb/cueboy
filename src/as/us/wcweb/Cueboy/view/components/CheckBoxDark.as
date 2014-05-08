package us.wcweb.Cueboy.view.components {
	import flash.text.TextFormat;

	import com.bit101.components.Style;
	import com.bit101.components.CheckBox;

	import flash.display.DisplayObjectContainer;

	/**
	 * @author macbookpro
	 */
	public class CheckBoxDark extends CheckBox {
		private var button_color : Number = 0xFFC003;

		public function CheckBoxDark(parent : DisplayObjectContainer = null, xpos : Number = 0, ypos : Number = 0, label : String = "", defaultHandler : Function = null, button_color : Number = 0xFFC003) {
			super(parent, xpos, ypos, label, defaultHandler);
			this.button_color = button_color;
		}

		override public function draw() : void {
			super.draw();
			_back.graphics.clear();
			_back.graphics.beginFill(Style.BACKGROUND);
			_back.graphics.drawRect(0, 0, 16, 16);
			_back.graphics.endFill();

			_button.graphics.clear();
			_button.graphics.beginFill(button_color);
			_button.graphics.drawRect(4, 4, 8, 8);

			_label.textField.defaultTextFormat = new TextFormat('Arial', 13, 0xcfcfcf);
			_label.text = _labelText;

			
			_label.x = 20;
			_label.y = (_height - _label.height) / 2 + 3;
			_label.draw();
			
			_width = _back.width+ _label.width+ 12;;
		}
	}
}
