package us.wcweb.Cueboy.view {
	import us.wcweb.Cueboy.model.pagination.PaginationGenerator;
	import us.wcweb.Cueboy.model.pagination.Pagination;
	import us.wcweb.Cueboy.model.config.ViewLayerConfig;
	import us.wcweb.Cueboy.event.ViewLayerEvent;

	import flash.display.Sprite;

	import us.wcweb.Cueboy.view.IViewer;

	/**
	 * @author Administrator
	 */
	public class GirdLayer extends Sprite implements IViewer {
		private static var _instance:GirdLayer;
		
		private var _pagination:Pagination;
		public function GirdLayer(config:ViewLayerConfig) {
			
			_pagination = new Pagination();

			
			addEventListener(ViewLayerEvent.SHOW_LAYER, _showLayerHandler);
			addEventListener(ViewLayerEvent.HIDE_LAYER, _hide_layer);
			addEventListener(ViewLayerEvent.LOADED_DATA, _paresDataHandler);
			addEventListener(ViewLayerEvent.RESIZE_LAYER, _resizeLayerHandler);
			addEventListener(ViewLayerEvent.FULLSCREEN_TOGGLE, _fullScreenHandler);
		}
		
		
		public static function getInstance(config:ViewLayerConfig):GirdLayer{
			if(GirdLayer._instance == null){
				GirdLayer._instance = new GirdLayer(config);
			}
			return GirdLayer._instance;
		}

		private function _showLayerHandler(e : ViewLayerEvent) : void {
		}

		private function _hide_layer(e : ViewLayerEvent) : void {
		}

		private function _paresDataHandler(e : ViewLayerEvent) : void {
			if((e.data as Array).length > 0){
				var data:Array = e.data as Array;
				_pagination.total = data.length;
				_pagination.page = 1;
				_pagination.pagesize = 8;
				_pagination.offset =0;
				_pagination.length =5;
				
				_pagination = PaginationGenerator.getInstance().build(_pagination);
			}
		}

		private function _resizeLayerHandler(e : ViewLayerEvent) : void {
		}

		private function _fullScreenHandler(e : ViewLayerEvent) : void {
		}
	}
}
