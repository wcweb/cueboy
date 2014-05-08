package us.wcweb.Cueboy.command {
	import flash.events.EventDispatcher;
	import us.wcweb.Cueboy.event.CueItemEvent;
	import us.wcweb.Cueboy.model.structElement.CuePointsItem;



	/**
	 * @author macbookpro
	 */
	public class CueCommands extends EventDispatcher {
		public function CueCommands() {
		}

		public function update_item(item : CuePointsItem) : void {
			dispatchEvent(new CueItemEvent(CueItemEvent.UPDATE_ITEM, item, "update item"));
		}

		public function delete_item(item : CuePointsItem) : void {
			dispatchEvent(new CueItemEvent(CueItemEvent.DELETE_ITEM, item, "delete item"));
		}

		public function create_item(item : CuePointsItem) : void {
			dispatchEvent(new CueItemEvent(CueItemEvent.CREATE_ITEM, item, "create item"));
		}

		public function retrieve_item(item : CuePointsItem) : void {
			dispatchEvent(new CueItemEvent(CueItemEvent.RETRIEVE_ITEM, item, "retrieve item"));
		}
	}
}
