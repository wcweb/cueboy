package us.wcweb.Cueboy {
	import us.wcweb.Cueboy.view.components.DarkCueListItem;
	import us.wcweb.Cueboy.model.structElement.CuePointsItem;
	import us.wcweb.Cueboy.view.components.CueListItem;
	import us.wcweb.Cueboy.view.CueItem;
	import us.wcweb.Cueboy.view.components.DarkGallery;

	import com.bit101.components.HBox;
	import com.bit101.components.VUISlider;

	import flash.display.MovieClip;

	import com.bit101.components.Panel;

	import flash.display.Sprite;

	/**
	 * @author wcweb
	 */
	public class Uitester extends Sprite {
		public var panel : Panel;
		public var silder : VUISlider;
		public var hbox : HBox;
		private var _container : MovieClip;
		public var items : Array;

		public function Uitester() {
			_container = new MovieClip();
			_container.x = 0;
			_container.y = 0;
			_container.width = this.width;
			_container.height = this.height;
			trace(this, this.width);
			items = new Array();
			for (var i : int = 0 ;i < 20;i++) {
				var item : Object = new Object();

				var cuepoint : CuePointsItem = new CuePointsItem(i + "这里是简介，这里是简介，这里是简介，这里是简介" + "，这里是简介，这里是简介，这里是简介，这里是简介，这里是简介，这里是简介，这里是简介，", 2000 * i, 2000 * 20);

				item['cuepoint'] = cuepoint;
				items.push(item);
			}

			var dg : DarkGallery = new DarkGallery(this, 0, 0, items);
			dg.listItemClass = DarkCueListItem;
			dg.setSize(800, 200);

			for (var i : int = 0; i < 10;i++) {
				var item : Object = new Object();
				var cuepoint : CuePointsItem = new CuePointsItem("new"+i + "这里是简介，这里是简介，这里是简介，这里是简介" + "，这里是简介，这里是简介，这里是简介，这里是简介，这里是简介，这里是简介，这里是简介，", 2000 * i, 2000 * 20);

				item['cuepoint'] = cuepoint;

				dg.addItem(item);
			}

			//
			// panel = new Panel(_container, 0, 0);
			// panel.width = this.width * .8;
			// panel.height = this.height * .8;
			// panel.color = 0x242424;
			//
			// hbox = new HBox(panel);

			// silder = new VUISlider(panel,10,10);

			addChild(_container);
		}
	}
}
