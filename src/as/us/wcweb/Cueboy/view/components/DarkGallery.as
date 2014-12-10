package us.wcweb.Cueboy.view.components {
	import com.adobe.protocols.dict.events.MatchEvent;
	import com.bit101.components.ListItem;

	import flash.display.Sprite;

	import com.bit101.components.Style;
	import com.bit101.components.HScrollBar;
	import com.bit101.components.Panel;

	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.display.DisplayObjectContainer;

	import com.bit101.components.Component;

	/**
	 * @author wcweb
	 */
	[Event(name="select", type="flash.events.Event")]
	public class DarkGallery extends Component {
		protected var _items : Array;
		protected var _itemHolder : Sprite;
		protected var _listItemWidth : Number = 200;
		protected var _listItemClass : Class = ListItem;
		protected var _panel : Panel;
		protected var _scrollbar : HScrollBar;
		protected var _selectedIndex : int = -1;
		protected var _defaultColor : uint = Style.LIST_DEFAULT;
		protected var _alternateColor : uint = Style.LIST_ALTERNATE;
		protected var _selectedColor : uint = Style.LIST_SELECTED;
		protected var _rolloverColor : uint = Style.LIST_ROLLOVER;
		protected var _alternateRows : Boolean = false;

		public function DarkGallery(parent : DisplayObjectContainer = null, xpos : Number = 0, ypos : Number = 0, items : Array = null) {
			if (items != null) {
				_items = items;
			} else {
				_items = new Array();
			}
			super(parent, xpos, ypos);
		}

		protected override function init() : void {
			super.init();
			setSize(100, 100);
			addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
			addEventListener(Event.RESIZE, onResize);
			makeGalleryItems();
			fillItems();
		}

		protected override function addChildren() : void {
			super.addChildren();
			_panel = new Panel(this, 0, 0);
			_panel.color = _defaultColor;
			_itemHolder = new Sprite();
			_panel.content.addChild(_itemHolder);
			_scrollbar = new HScrollBar(this, 0, 0, onScroll);
			_scrollbar.repe
			_scrollbar.setSliderParams(0, 0, 0);
		}

		protected function makeGalleryItems() : void {
			var item : ListItem;
			while (_itemHolder.numChildren > 0) {
				item = ListItem(_itemHolder.getChildAt(0));
				item.removeEventListener(MouseEvent.CLICK, onSelect);
				_itemHolder.removeChildAt(0);
			}
			var numItems : int = Math.ceil(_width / _listItemWidth);
			numItems = Math.min(numItems, _items.length);
			numItems = Math.max(numItems, 1);
			// var numItems : int = _items.length;
			for (var i : int = 0; i < numItems; i++) {
				if (i == 0) {
					item = new _listItemClass(_itemHolder, 0, i * _listItemWidth);
				} else {
					var preItem : Sprite = Sprite(_itemHolder.getChildAt(_itemHolder.numChildren - 1));
					var xpos : Number = preItem.x + preItem.width;
					item = new _listItemClass(_itemHolder, xpos, 0);
					
				}
				item.setSize(_listItemWidth, height);
				item.defaultColor = _defaultColor;

				item.selectedColor = _selectedColor;
				item.rolloverColor = _rolloverColor;
				item.addEventListener(MouseEvent.CLICK, onSelect);
			}
		}

		protected function fillItems() : void {
			var offset : int = _scrollbar.value;

			var numItems : int = Math.ceil(_width / _listItemWidth);
			numItems = Math.min(numItems, _items.length);
			// var numItems : int = _items.length;

			for (var i : int = 0; i < numItems; i++) {
				var item : ListItem = _itemHolder.getChildAt(i) as ListItem;
				if (offset + i < _items.length) {
					item.data = _items[offset + i];
				} else {
					item.data = "";
				}
				if (_alternateRows) {
					item.defaultColor = ((offset + i) % 2 == 0) ? _defaultColor : _alternateColor;
				} else {
					item.defaultColor = _defaultColor;
				}

				if (offset + i == _selectedIndex) {
					item.selected = true;
				} else {
					item.selected = false;
				}
			}
		}

		protected function scrollToSelection() : void {
			var numItems : int = Math.ceil(_width / _listItemWidth);
			if (_selectedIndex != -1) {
				if (_scrollbar.value > _selectedIndex) {
				} else if (_scrollbar.value + numItems < _selectedIndex) {
					_scrollbar.value = _selectedIndex - numItems + 1;
				}
			} else {
				_scrollbar.value = 0;
			}
			fillItems();
		}

		// // // // ///////////////////////////
		// public methods
		// // // // ///////////////////////////
		public override function draw() : void {
			super.draw();
			_selectedIndex = Math.min(_selectedIndex, _items.length - 1);

			_panel.setSize(_width, _height);
			_panel.color = _defaultColor;
			_panel.alphaFill = 0.1;
			_panel.draw();

			_scrollbar.y = _height - 10;
			var contentWidth : Number = _items.length * _listItemWidth;
			// var contentWidth: Number = _itemHolder.width;
			_scrollbar.setThumbPercent(_width / contentWidth);
			var pageSize : Number = Math.floor(_width / _listItemWidth);
			_scrollbar.maximum = Math.max(0, _items.length - pageSize);
			_scrollbar.pageSize = pageSize;
			_scrollbar.width = _width;
			_scrollbar.draw();

			scrollToSelection();
		}

		public function addItem(item : Object) : void {
			_items.push(item);
			invalidate();
			makeGalleryItems();
			fillItems();
		}

		public function addItemAt(item : Object, index : int) : void {
			index = Math.max(0, index);
			index = Math.min(index, _items.length);
			_items.splice(index, 0, item);
			invalidate();
			makeGalleryItems();
			fillItems();
		}
		/**
		 * Removes the referenced item from the list.
		 * @param item The item to remove. If a string, must match the item containing that string. If an object, must be a reference to the exact same object.
		 */
		public function removeItem(item : Object) : void {
			var index : int = _items.indexOf(item);
			removeItemAt(index);
		}

		/**
		 * Removes the item from the list at the specified index
		 * @param index The index of the item to remove.
		 */
		public function removeItemAt(index : int) : void {
			if (index < 0 || index >= _items.length) return;
			_items.splice(index, 1);
			invalidate();
			makeGalleryItems();
			fillItems();
		}
				/**
		 * Removes all items from the list.
		 */
		public function removeAll() : void {
			_items.length = 0;
			invalidate();
			makeGalleryItems();
			fillItems();
		}
		
		public function updateFrame():void{
			invalidate();
			makeGalleryItems();
			fillItems();
		}
		// // // // // // // /////////////////////
		// event handlers
		// // // // // // // /////////////////////
		protected function onSelect(event : MouseEvent) : void {
			if(!(event.target is ListItem)) return;
			var offset: int = _scrollbar.value;
			for(var i: int= 0; i< _itemHolder.numChildren; i++){
				if(_itemHolder.getChildAt(i) == event.target) _selectedIndex = i + offset;
				ListItem(_itemHolder.getChildAt(i)).selected = false;
			}
			ListItem(event.target).selected = true;
			dispatchEvent(new Event(Event.SELECT));
		}

		protected function onScroll(event : Event) : void {
			fillItems();
		}

		protected function onMouseWheel(event : MouseEvent) : void {
			_scrollbar.value -= event.delta;
			fillItems();
		}

		protected function onResize(event : Event) : void {
			makeGalleryItems();
			fillItems();
		}
	// /////////////////////////////////
		// getter/setters
		// /////////////////////////////////
		/**
		 * Sets / gets the index of the selected list item.
		 */
		public function set selectedIndex(value : int) : void {
			if (value >= 0 && value < _items.length) {
				_selectedIndex = value;
				// _scrollbar.value = _selectedIndex;
			} else {
				_selectedIndex = -1;
			}
			invalidate();
			dispatchEvent(new Event(Event.SELECT));
		}

		public function get selectedIndex() : int {
			return _selectedIndex;
		}

		/**
		 * Sets / gets the item in the list, if it exists.
		 */
		public function set selectedItem(item : Object) : void {
			var index : int = _items.indexOf(item);
			// if(index != -1)
			// {
			selectedIndex = index;
			invalidate();
			dispatchEvent(new Event(Event.SELECT));
			// }
		}

		public function get selectedItem() : Object {
			if (_selectedIndex >= 0 && _selectedIndex < _items.length) {
				return _items[_selectedIndex];
			}
			return null;
		}

		/**
		 * Sets/gets the default background color of list items.
		 */
		public function set defaultColor(value : uint) : void {
			_defaultColor = value;
			invalidate();
		}

		public function get defaultColor() : uint {
			return _defaultColor;
		}

		/**
		 * Sets/gets the selected background color of list items.
		 */
		public function set selectedColor(value : uint) : void {
			_selectedColor = value;
			invalidate();
		}

		public function get selectedColor() : uint {
			return _selectedColor;
		}

		/**
		 * Sets/gets the rollover background color of list items.
		 */
		public function set rolloverColor(value : uint) : void {
			_rolloverColor = value;
			invalidate();
		}

		public function get rolloverColor() : uint {
			return _rolloverColor;
		}
		public function set listItemWidth(value : Number) : void {
			_listItemWidth = value;
			makeGalleryItems();
			invalidate();
		}

		public function get listItemWidth() : Number {
			return _listItemWidth;
		}
			/**
		 * Sets / gets the list of items to be shown.
		 */
		public function set items(value : Array) : void {
			_items = value;
			invalidate();
		}

		public function get items() : Array {
			return _items;
		}

		/**
		 * Sets / gets the class used to render list items. Must extend ListItem.
		 */
		public function set listItemClass(value : Class) : void {
			_listItemClass = value;
			makeGalleryItems();
			invalidate();
		}

		public function get listItemClass() : Class {
			return _listItemClass;
		}

		/**
		 * Sets / gets the color for alternate rows if alternateRows is set to true.
		 */
		public function set alternateColor(value : uint) : void {
			_alternateColor = value;
			invalidate();
		}

		public function get alternateColor() : uint {
			return _alternateColor;
		}

		/**
		 * Sets / gets whether or not every other row will be colored with the alternate color.
		 */
		public function set alternateRows(value : Boolean) : void {
			_alternateRows = value;
			invalidate();
		}

		public function get alternateRows() : Boolean {
			return _alternateRows;
		}

		/**
		 * Sets / gets whether the scrollbar will auto hide when there is nothing to scroll.
		 */
		public function set autoHideScrollBar(value : Boolean) : void {
			_scrollbar.autoHide = value;
		}

		public function get autoHideScrollBar() : Boolean {
			return _scrollbar.autoHide;
		}
	}
}
