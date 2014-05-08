package us.wcweb.Cueboy.event {
	import flash.events.Event;
	import us.wcweb.Cueboy.model.structElement.CuePointsItem;


	/**
	 * @author macbookpro
	 */
	public class CueItemEvent extends Event {
		public static var CLICK_ITEM : String = "item_click";
		public static var CLICK_ITEM_IN_VIEW : String = "item_click_in_view";
		public static var CREATE_ITEM : String = "create_item";
		public static var UPDATE_ITEM : String = "update_item";
		public static var DELETE_ITEM : String = "delete_item";
		public static var RETRIEVE_ITEM : String = "retrieve_item";
		public var messager : String;
		public var item : CuePointsItem;

		public function CueItemEvent(type : String, _item : CuePointsItem, msg : String, bubbles : Boolean = false, cancelable : Boolean = false) {
			super(type, bubbles, cancelable);
			this.item = _item;
			this.messager = msg;
		}

		override public function toString() : String {
			return "us.wcweb.Cueboy.event.CueItemEvent";
		}

		override public function clone() : Event {
			return new CueItemEvent(this.type, this.item, messager);
		}
	}
}
