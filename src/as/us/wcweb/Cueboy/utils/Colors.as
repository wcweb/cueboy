package us.wcweb.Cueboy.utils {
	/**
	 * @author macbookpro
	 */
	public class Colors {
		public static function	RandomColor() : int {
			var _colorArray : Array = new Array(0xc10c91, 0x172e64, 0x21879b, 0xFF0033, 0xFFC003, 0x99CC33);
			var randomColorID : Number = Math.floor(Math.random() * _colorArray.length);
			return _colorArray[randomColorID];
		}
	}
}
