package us.wcweb.Cueboy.view.components {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import us.wcweb.Cueboy.view.CueGrid;

	/**
	 * @author macbookpro
	 */
	public class CueCollection extends Sprite {
		private var _navBar : Sprite;
		private var _bar : Sprite;
		private var _config : Object;
		private var _drag : Boolean;
		private var _dimensions : Array;
		private var _grid : CueGrid;

		public function CueCollection(_dimensions : Array, _grid : CueGrid) {
			// var scal:Number = Math.round(_dimensions[2]*_dimensions[2]/_grid.width);

			trace("_dimensions[2] :" + _dimensions[2] + " _grid.width :" + _grid.width);
			var scal : Number = _dimensions[2] * 600 / _grid.width;

			if (_navBar == null) {
				_navBar = new Sprite();
				_bar = new Sprite();

				_config = new Object();

				_bar.graphics.clear();
				_bar.graphics.beginFill(0x000000, 1);
				_bar.graphics.lineStyle(1, 0xFFFFFF, 1);

				_bar.graphics.drawRoundRect(0, -3, 30, 10, 5);
				_bar.addEventListener(MouseEvent.MOUSE_UP, _stopDragNavBar);
				_bar.addEventListener(MouseEvent.MOUSE_DOWN, _dragNavBar);

				_navBar.stage.addEventListener(MouseEvent.MOUSE_UP, _stopDragNavBar);

				_navBar.addChild(_bar);
				addChild(_navBar);
			}
			_config.minScroll = 0;
			trace("_config.minScroll" + _config.minScroll);
			_config.maxScroll = _config.minScroll + (scal - _bar.width);
			trace("_config.maxScroll" + _config.maxScroll);
			_config.scrollInterval = _config.maxScroll - _config.minScroll;
			trace("_config.scrollInterval " + _config.scrollInterval);
			_config.bound = new Rectangle(0, _bar.y, scal - _bar.width, 0);

			// _bar.x = _dimensions[2] / 2;
			// _navBar.scaleX = Math.round(_dimensions[2]*_dimensions[2]/_grid.width);

			var moved : Number = _bar.x - _config.minScroll;
			var precent : Number = moved / _config.scrollInterval;
			_grid.x = -precent * (_grid.width - _dimensions[2]);
			trace("_grid.x" + _grid.x);
		}

		private function _stopDragNavBar(e : MouseEvent) : void {
			_bar.stopDrag();
			_drag = false;
		}

		private function _dragNavBar(e : MouseEvent) : void {
			_bar.startDrag(false, _config.bound);
			_drag = true;
			_navBar.addEventListener(Event.ENTER_FRAME, checkingProgress);
		}

		private function checkingProgress(e : Event) : void {
			/*			var moved:Number = _bar.y - _config.minScroll;*/
			trace("bar x" + _bar.x + "_bar.x - _config.minScroll " + _config.minScroll);

			var moved : Number = _bar.x - _config.minScroll;
			var precent : Number = moved / _config.scrollInterval;
			if (_drag) {
				/*				_grid.y = precent * _grid.height;*/

				_grid.x = -precent * (_grid.width - _dimensions[2]);

				// trace("_grid.x"+_grid.x+" precent :"+precent+" ppp"+(_grid.width - _dimensions[2]));
			}
			// trace("_grid x"+_grid.x);
		}
	}
}
