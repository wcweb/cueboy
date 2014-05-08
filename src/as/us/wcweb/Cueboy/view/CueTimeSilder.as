package us.wcweb.Cueboy.view {
	import flash.events.MouseEvent;
	import flash.display.MovieClip;

	/**
	 * @author macbookpro
	 */
	public class CueTimeSilder extends MovieClip {
		private var dot : MovieClip;
		private var dots : Array;
		private var thumb : MovieClip;

		public function CueTimeSilder() {
			thumb = new MovieClip();
			thumb.alpha = 0 ;

			dot = new MovieClip();
			dot.addEventListener(MouseEvent.MOUSE_OVER, _showThumbHandler);
			dot.addEventListener(MouseEvent.MOUSE_OUT, _hideThumbHandler);
		}

		private function _showThumbHandler(e : MouseEvent) : void {
			thumb.x = e.target.x;
			thumb.alpha = 1;
		}

		private function _hideThumbHandler(e : MouseEvent) : void {
			thumb.alpha = 0;
		}
	}
}
