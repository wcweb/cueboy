package us.wcweb.Cueboy.view {
	import com.bit101.components.Style;
	import com.bit101.components.Component;
	import com.bit101.components.List;
	import com.bit101.components.Panel;
	import com.carlcalderon.arthropod.Debug;
	import com.demonsters.debugger.MonsterDebugger;
	import com.longtailvideo.jwplayer.utils.Logger;

	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;

	import org.osflash.signals.events.GenericEvent;

	import us.wcweb.Cueboy.command.CueCommands;
	import us.wcweb.Cueboy.event.CueItemEvent;
	import us.wcweb.Cueboy.event.ViewLayerEvent;
	import us.wcweb.Cueboy.model.structElement.CuePointsItem;
	import us.wcweb.Cueboy.view.components.CueListItem;

	/**
	 * @author macbookpro
	 */
	public class CueGrid extends Sprite {
		private var _currentItem : CueItem;
		private var _col : Number;
		private var _row : Number;
		private var _items : Array;
		private var _tooBig : Boolean;
		private var _dimensions : Array;
		private var _command : CueCommands;
		public var count : Number;
		public var nextBtn : Sprite;
		public var prewBtn : Sprite;
		private var list : List;
		// private var _panel:Panel;
		private var _container : Sprite;
		public var panel : Panel;

		public function CueGrid(parentPanel : Panel) {
			_items = new Array();
			_command = new CueCommands();
			_container = new Sprite();
			addChild(_container);
			// Component.initStage(this.stage);

			// _panel = new Panel(this.parent);
			panel = parentPanel;
			Style.setStyle("dark");
			list = new List(panel, 10, 10);
			
			list.listItemClass = CueListItem;
			list.listItemHeight =35;
			list.defaultColor = 0x242424;
			
			list.addEventListener(Event.SELECT, onSelect);
			MonsterDebugger.initialize(this);
			MonsterDebugger.log(this, "init cueGrid");
			MonsterDebugger.trace(this, list);
		}

		protected function onSelect(e : Event) : void {
			dispatchEvent(new CueItemEvent(CueItemEvent.CLICK_ITEM, list.selectedItem.cuepoint, ""));
		}

		private function drawPagination() : void {
			var arraw : Shape = new Shape();
			var triangle : Shape;
			drawTriangle(0, 0, 10, 10, 0xFFFFFF);

			function drawTriangle(x : Number, y : Number, width : Number, height : Number, color : uint) : void {
				triangle = new Shape;
				triangle.graphics.beginFill(color);
				triangle.graphics.moveTo(width / 2, 0);
				triangle.graphics.lineTo(width, height);
				triangle.graphics.lineTo(0, height);
				triangle.graphics.lineTo(width / 2, 0);
				addChild(triangle);
			}

			nextBtn.addChild(triangle);

			prewBtn.addChild(triangle);
		}

		// Base Property
		public function get grid() : Array {
			return _items;
		}

		public function set dimensions(dim : Array) : void {
			_dimensions = dim;
		}

		// Command Event
		public function deleteItem(item : CuePointsItem) : void {
			_command.delete_item(item);
			count--;
		}

		public function updateItem(item : CuePointsItem) : void {
			_command.update_item(item);
		}

		public function createItem(item : CuePointsItem) : void {
			_command.create_item(item);
			count++;
		}

		public function cleanGrid() : void {
			while (this.numChildren > 0) {
				removeChildAt(0);
			}
		}

		// old event
		private function _clickHandler(event : CueItemEvent) : void {
			dispatchEvent(event.clone());
		}

		// Init Grids items
		public function parse(cuePointsItems : Array) : void {
			_col = 0;
			_row = 0;

			MonsterDebugger.log(this, "init cueGrid parse");
			MonsterDebugger.log(this, _items,cuePointsItems);
			
			Logger.log(_items,"logg _items");
			Logger.log(cuePointsItems,"logg cuePointsItems");
			for (var j : Number = 0; j < cuePointsItems.length; j++) {
//				var thumb : CueItem = new CueItem(_dimensions[0], _dimensions[1], cuePointsItems[j], j);
				var dup:Boolean = false;
				for(var y:Number=0; y< _items.length; y++){
					if(_items[y].time == cuePointsItems[j].time){
						dup = true;
						break;
					}
				}
				if(dup) continue;
				
				_items.push(cuePointsItems[j]);
				list.addItem({checked:false, cuepoint:cuePointsItems[j]});
				// createItem(cuePointsItems[j]);
				// _container.addChild(thumb);
				// _items.push(thumb);
				// thumb.addEventListener(CueItemEvent.CLICK_ITEM, _clickHandler);
				// thumb.clickSignal.add(_clickHandler);
			}

			// TODO dispath resize event
			dispatchEvent(new ViewLayerEvent(ViewLayerEvent.UPDATE_LAYER, this));
			// Logger.log('grid have parse finish with ' + cuePointsItems);
				MonsterDebugger.log(this, list.items);
		}

		// place right position
		public function fullScreenResize() : void {
			placeGrid(true, true);
		}

		public function resize() : void {
			// Logger.log('placeGrid h');
			placeGrid(false);
		}

		public function placeGrid(vertical : Boolean = true, scale : Boolean = false) : void {
			if (_dimensions.length > 2) {
				list.setSize(panel.width * (1-0.6180339887), panel.height);
				list.x = 0;
				list.y = 0;
			}

			// _col = 0;
			// _row = 0;
			//
			// _tooBig = false;
			//			//  Logger.log('placeGrid V with ' + _items);
			// if (_items.length > 0) {
			// for (var i : Number = 0;i < _items.length;i++) {
			// var thumb : CueItem = _items[i];
			//					//  Logger.log('placeGrid V' + _dimensions);
			// thumb.x = (_dimensions[0] + 10) * _col;
			// thumb.y = (_dimensions[1] + 10) * _row;
			//					//  MonsterDebugger.log(_dimensions,"fuck update before resize");
			// if (scale ) {
			// thumb.scaleX = 2;
			// thumb.scaleY = 2;
			// thumb.x = (thumb.width + 20) * _col;
			// thumb.y = (thumb.height + 20) * _row;
			// thumb.scaleFont();
			// }
			//
			// if (vertical) {
			// if ((_dimensions[1] + 10) * (_row + 2) > _dimensions[3] - 50 ) {
			// if ((_dimensions[0] + 10) * (_col + 2) > _dimensions[2] - 50) {
			// _tooBig = true;
			// }
			// _col++;
			// _row = 0;
			// } else {
			// _row++;
			// }
			// } else {
			// if ((_dimensions[0] + 10) * (_col + 2) > _dimensions[2] - 50) {
			// if ((_dimensions[1] + 10) * (_row + 2) > _dimensions[3] - 50 ) {
			// _tooBig = true;
			// }
			// _row++;
			// _col = 0;
			// } else {
			// _col++;
			// }
			// }
			// }
			// }
		}
	}
}
