package us.wcweb.Cueboy.model.structElement {
	import flash.display.Sprite;
	import org.osmf.metadata.TimelineMarker;
	import us.wcweb.Cueboy.model.config.CueMakerConfig;



	/**
	 * @author macbookpro
	 */
	public class CueMarker extends Sprite {
		public var repeat : Boolean;
		private var _currentCuePoitionStart : TimelineMarker;
		private var _currentCuePoitionEnd : TimelineMarker;
		private var _currentPosition : Number;

		public function CueMarker(config : CueMakerConfig) {
			_currentPosition = -1;
			_currentCuePoitionStart = new TimelineMarker(-1);
			_currentCuePoitionEnd = new TimelineMarker(-1);
		}
	}
}
