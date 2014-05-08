package us.wcweb.Cueboy.command {
	import flash.events.StatusEvent;
	import flash.net.LocalConnection;

	/**
	 * @author macbookpro
	 */
	public class CueConnectLocalSwf {
		private var _con : LocalConnection;
		private var lc_name : String;

		public function set name(str : String) : void {
			lc_name = str;
		}

		public function CueConnectLocalSwf() {
			_con = new LocalConnection();
			_con.allowDomain('*');

			_con.addEventListener(StatusEvent.STATUS, onStatus);
		}

		// when it is cient
		public function connect() : void {
			if (lc_name !== '') {
				_con.connect(lc_name);
			}
			// @TODO add error handler
		}

		/**
		 * 
		 * conn.client = this;
		 * try {
		 *     conn.connect("myConnection");
		 *  } catch (error:ArgumentError) {
		 *     trace("Can't connect...the connection name is already being used by another SWF");
		 *  }
		 * 
		 */
		private function onStatus(event : StatusEvent) : void {
			switch (event.level) {
				case "status":
					trace("LocalConnection.send() succeeded");
					break;
				case "error":
					trace("LocalConnection.send() failed");
					break;
			}
		}

		public function connectBool() : void {
		}

		public function	sendCurrentPosition(func : String, data : Object) : void {
			if (_con.isPerUser) {
				_con.send(lc_name, func, data);
			}
		}
	}
}
