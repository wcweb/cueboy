package us.wcweb.Cueboy.command {
	/**
	 * @author macbookpro
	 */
	public class CueMemento {
		private var _gridMemento : Array;
		private var _undoStack : Array;
		private var _redoStack : Array;

		public function init(method : String, item : Object) : void {
			// undostack push item event data   :   cue change name  new   possucc
			_gridMemento = [];
			_undoStack = [];
			_redoStack = [];
			_undoStack.push({'method':method, 'object':item});
		}

		public function redo() : Object {
			// redostack  pop old ->new
			if (_redoStack.length > 0) {
				var out : Object = _redoStack.pop();
				_undoStack.push(out);
				return out;
			}
			return null;
		}

		public function undo() : Object {
			// undostack  pop- push-> redostack  cue newstatue ->   old      delete
			if (_undoStack.length > 0) {
				var out : Object = _undoStack.pop();
				_redoStack.push(out);
				return ;
			}
			return null;
		}
	}
}
