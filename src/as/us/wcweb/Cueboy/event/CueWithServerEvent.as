package us.wcweb.Cueboy.event {
	import flash.events.Event;
	import flash.events.EventDispatcher;

	/**
	 * @author macbookpro
	 */
	public class CueWithServerEvent extends Event {
		public static var COMPLETE : String = "complete";
		public static var IO_ERROR : String = "io_error";
		public static var SECURITY_ERROR : String = "security_error";
		public static var HTTP_STATUS : String = "http_status";
		public static var POSTING : String = "posting";
		public static var MODIFIED : String = "modified";
		public static const dispatcher : EventDispatcher = new EventDispatcher();
		public var data : Object;
		public var messager : Object;

		public function CueWithServerEvent(type : String, msg : Object, d : Object, bubbles : Boolean = false, cancelable : Boolean = false) {
			super(type, bubbles, cancelable);
			data = d;
			messager = msg;
		}

		override public function toString() : String {
			return "us.wcweb.Cueboy.event.CueWithServerEvent";
		}

		override public function clone() : Event {
			return new CueWithServerEvent(this.type, messager, data);
		}
	}
}
