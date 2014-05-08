package us.wcweb.Cueboy.view {
	//import com.demonsters.debugger.MonsterDebugger;
	import flash.display.DisplayObject;
	import flash.display.Sprite;

	/**
	 * @author wcweb
	 */
	public class CueLineMaker extends Sprite {
		private var _slider_overlayer : Sprite;
		public var component : *;
		public var timeSlider : DisplayObject;
		public var color : Number;
		public var duration : Number;

		public function CueLineMaker() {
			// cueMaker
			_slider_overlayer = new Sprite();
			addChild(_slider_overlayer);
		}

		public function clear() :void{
			_slider_overlayer.graphics.clear();
		}

		public function redrawShade(startTime : Number, endTime : Number) : void {
			// var sl : Object = _player.controls.controlbar as ControlbarComponentV4;
			// Logger.log("count slider" + sl);
			// var ts : DisplayObject = component.getSkinComponent('timeSlider');
			var sl : DisplayObject = component,
			ts : DisplayObject = component.getSkinComponent('timeSlider'),
			s:Number = startTime,
			d:Number = endTime;

			_slider_overlayer.graphics.clear();

			_slider_overlayer.graphics.beginFill(color);
			var overlayer_height : Number = 5;
			//MonsterDebugger.log(duration, "fuck redraw shade ....");
			if (duration !== -1 && duration != 0 ) {
				var _swidth : Number = s * ts.width / (duration);

				var _smargin : Number = d * ts.width / (duration);
				// Logger.log("_swidth: " + _swidth + "  ;  " + "_smargin: " + _smargin + "::::" + "ts.width" + ts.width);
				var ret_x : Number = sl.x + ts.x + _swidth;
				var ret_y : Number = sl.y + ts.y;
				var ret_w : Number = _smargin - _swidth;
				_slider_overlayer.graphics.drawRect(ret_x, ret_y, ret_w, overlayer_height);
			} else {
				var ret_2_x : Number = sl.x + ts.x;
				var ret_2_y : Number = sl.y + ts.y;
				_slider_overlayer.graphics.drawRect(ret_2_x, ret_2_y, ts.width, overlayer_height);
			}

			// Logger.log("_player.playlist.currentItem.duration: " + s + " : " + _player.playlist.currentItem.duration);

			_slider_overlayer.alpha = 0.5;
		}

		public function hide():void {
			if (_slider_overlayer.visible) {
				_slider_overlayer.visible = false;
			}
		}

		public function show():void {
			_slider_overlayer.visible = true;
		}
	}
}
