package us.wcweb.Cueboy.command {
	import us.wcweb.Cueboy.view.IViewer;
	import org.osmf.metadata.TimelineMarker;

	import us.wcweb.Cueboy.model.CueWithServer;

	import flash.events.EventDispatcher;
	import flash.display.MovieClip;

	import us.wcweb.Cueboy.event.CueWithServerEvent;
	import us.wcweb.Cueboy.event.CueItemEvent;
	import us.wcweb.Cueboy.view.ViewLayer;

	/**
	 * @author macbookpro
	 */
	public class CueItemHandler {
		private var _handler : IViewer;
		private var _cws : CueWithServer;

		public function CueItemHandler(handler : IViewer, url : String = '') {
			_handler = handler;

			_handler.addEventListener(CueItemEvent.DELETE_ITEM, _cueItemEventHandler);
			_handler.addEventListener(CueItemEvent.CREATE_ITEM, _cueItemEventHandler);
			_handler.addEventListener(CueItemEvent.UPDATE_ITEM, _cueItemEventHandler);

			// init event bridge between controller and model  view
			_cws = new CueWithServer(url);
			// _cws.addEventListener(CueWithServerEvent.POSTING, _postingHandler);
			_cws.addEventListener(CueWithServerEvent.COMPLETE, _postCompleteHandler);
			// TODO event bubbles??
//			_handler.editable(true, _editHandler);
		}

		/**
		 * CWSEvent 
		 * 
		 */
		// handle item
		private function _postCompleteHandler(e : CueWithServerEvent) : void {
//			_handler.addNewItem(e.data, e.messager.statue.toString());
		};

		/**
		 * CueItemEvent 
		 * 
		 */
		private function _editHandler(txt : String, mark : TimelineMarker) : void {
			var d : Object = new Object();
			d['descript'] = txt;
			d['position'] = mark.time;
			d['duration'] = mark.duration
			_cws.postData(d);
		}

		private function _cueItemEventHandler(e : CueItemEvent) : void {
			try {
				_cws.deleteItem(e.target);
				_cws.addEventListener(CueWithServerEvent.MODIFIED, _modifiedHandler);
			} catch(e : Error) {
			}
		}

		private function _modifiedHandler(e : CueItemEvent) : void {
			// _viewLayer.grid.deleteItem();
		}
	}
}
