package us.wcweb.Cueboy.model {
	import us.wcweb.Cueboy.event.CueWithServerEvent;
	import us.wcweb.Cueboy.event.CueItemEvent;

	import com.longtailvideo.jwplayer.utils.Logger;

	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.SecurityErrorEvent;
	import flash.filters.DropShadowFilter;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.setTimeout;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequestMethod;
	import flash.events.HTTPStatusEvent;
	import flash.net.URLVariables;

	/**
	 * @author Administrator
	 */
	public class CueWithServer extends EventDispatcher {
		private var _config : Object;

		public function CueWithServer(url : String) {
			_config.url = url;
		};

		public function deleteItem(obj : Object) : void {
		}

		public function postData(data : Object) : void {
			// url = "http://localhost/url/url.php";

			var _request : URLRequest = new URLRequest(_config.url);

			var requestVars : URLVariables = new URLVariables();

			// TODO data vars
			requestVars.descript = data['descript'];
			requestVars.position = data['position'];
			requestVars.duration = data['duration'];
			requestVars.sessionTime = new Date().getTime();

			_request.data = requestVars;
			_request.method = URLRequestMethod.POST;

			var urlLoader : URLLoader = new URLLoader();
			urlLoader.dataFormat = URLLoaderDataFormat.VARIABLES;

			urlLoader.addEventListener(Event.COMPLETE, loaderCompleteHandler, false, 0, true);
			urlLoader.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler, false, 0, true);
			urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler, false, 0, true);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler, false, 0, true);

			// init messager
			var messager : Object = new Object();

			try {
				urlLoader.load(_request);
				dispatchEvent(new CueWithServerEvent(CueWithServerEvent.POSTING, messager, null));
			} catch (e : Error) {
				trace(e);
			}
		}

		private function ioErrorHandler(e : IOErrorEvent) : void {
			var messager : Object = {error:e};
			dispatchEvent(new CueWithServerEvent(CueWithServerEvent.COMPLETE, messager, null));
		}

		private function securityErrorHandler(e : SecurityErrorEvent) : void {
			var messager : Object = {error:e};
			dispatchEvent(new CueWithServerEvent(CueWithServerEvent.SECURITY_ERROR, messager, null));
		}

		private function httpStatusHandler(e : HTTPStatusEvent) : void {
			var messager : Object = {statue:e};
			dispatchEvent(new CueWithServerEvent(CueWithServerEvent.HTTP_STATUS, messager, null));
		}

		private	function loaderCompleteHandler(e : Event) : void {
			var responseVars : URLVariables = URLVariables(e.target.data);

			var data : Object = new Object();
			var messager : Object = new Object();

			for (var key:String in responseVars) {
				data[key] = responseVars[key];
			}

			// logic
			if (responseVars.success == 'true') {
				messager = {statue:'成功提交'};
			} else {
				// messager from serer
				messager = {statue:data.message};
			}

			dispatchEvent(new CueWithServerEvent(CueWithServerEvent.COMPLETE, messager, data));
		}
	}
}
