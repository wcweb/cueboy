package us.wcweb.Cueboy.view.components {
	import com.longtailvideo.jwplayer.utils.Logger;

	import flash.events.MouseEvent;
	import flash.display.DisplayObject;
	import flash.display.Sprite;

	import caurina.transitions.Tweener;

	/**
	 * @author macbookpro
	 */
	public class SlideGrid extends Sprite {
		[Embed(source="../../../../../../../assets/left.png")]
		private const LeftArrow : Class;
		// [Embed(source="../../../../../../assets/right.png")]
		// private const RightArrow : Class;
		private var _next_btn : Sprite;
		private var _prew_btn : Sprite;
		private var _mask : Sprite;
		private var _pageNum : int;
		private var _pageTotal : int;
		private var _width : Number;
		private var _grid : Sprite;
		private var _data : Object;

		public function SlideGrid() {
			initView();
			// place_elements();
		}

		private function initView() : void {
			_width = this.width;
			_pageNum = 0;
			_pageTotal = 0;
			// var _next_pic : DisplayObject = new RightArrow();
			var _next_pic : DisplayObject = new Sprite();
			var _prew_pic : DisplayObject = new LeftArrow();
			_next_btn = new Sprite();
			_next_btn.addChild(_next_pic);

			_prew_btn = new Sprite();
			_prew_btn.addChild(_prew_pic);
			_prew_btn.x = 40;
			_prew_btn.y = 0;
			_prew_btn.buttonMode = true;

			_next_btn.y = _prew_btn.height;
			_next_btn.x = 40;
			_next_btn.buttonMode = true;

			addChild(_next_btn);
			addChild(_prew_btn);
			// updateView();
			_next_btn.addEventListener(MouseEvent.CLICK, turnNext);
			_prew_btn.addEventListener(MouseEvent.CLICK, turnPrew);
			buttonMode = true;
			mouseEnabled = true;
			mouseChildren = true;
			var d : Object = new Object();
			d['pageNum'] = 1;
			d['pageTotal'] = 10;
			createPage(d);
		}

		private function updateView() : void {
			Tweener.addTween(_next_btn, {x:-_next_btn.width, alpha:1});
			Tweener.addTween(_prew_btn, {x:_width - _prew_btn.width, alpha:1});
		}

		public function createPage(data : Object) : void {
			_data = data;
			_pageNum = data['pageNum'];
			_pageTotal = data['pageTotal'];
		}

		public function updateGrid(obj : DisplayObject, dimensions : Array) : void {
			_grid = obj as Sprite;
			_grid.x = dimensions[0];
			_grid.y = dimensions[1];

			_mask = new Sprite();
			_mask.graphics.beginFill(0, 1);
			_mask.graphics.drawRect(1, 1, dimensions[2] - 2, dimensions[3] - 2);
			addChild(_mask);
			_grid.mask = _mask;
			// updateView();
		}

		private function turnNext(e : MouseEvent) : void {
			Logger.log("turn next");
			// x = width/totalnum*pagenum
			// var nextNum : int = _pageNum + 1;
			// if (nextNum <= _pageTotal) {
			// Tweener.addTween(_grid, {x:(_width / _pageTotal) * nextNum});
			// _pageNum = nextNum;
			// }
		}

		private function turnPrew(e : MouseEvent) : void {
			Logger.log("turn right");
			// var nextNum : int = _pageNum - 1;
			// if (nextNum >= 0) {
			// Tweener.addTween(_grid, {x:(_width / _pageTotal) * nextNum});
			// _pageNum = nextNum;
			// }
		}
	}
}
