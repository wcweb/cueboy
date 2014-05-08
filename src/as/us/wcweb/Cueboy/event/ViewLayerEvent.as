package us.wcweb.Cueboy.event {
	import flash.events.Event;

	/**
	 * @author macbookpro
	 */
	public class ViewLayerEvent extends Event {
		public static var SHOW_LAYER : String = "show_layer";
		public static var HIDE_LAYER : String = "hide_layer";
		public static var BACKTO_PLAYER: String = "backto_player";
		public static var SEEK_PLAYER : String = "seek_player";
		public static var REPLAY_PLAYER : String = "replay_player";
		public static var REPEAT_CHECKBOX : String = "repeat_checkbox";
		public static var UPDATE_LAYER : String = "update_layer";
		public static var LOADED_DATA: String = "loaded_data";
		public static var RESIZE_LAYER: String = "resize_layer";
		public static var FULLSCREEN_TOGGLE: String = "fullscreen_toggle";
		private var _data : Object;

		public function ViewLayerEvent(type : String, data : Object, bubbles : Boolean = false, cancelable : Boolean = false) {
			super(type, bubbles, cancelable);
			_data = data;
		}

		public function get data() : Object {
			return _data;
		}
	}
}
