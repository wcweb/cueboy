package us.wcweb.Cueboy {
	import com.adobe.utils.NumberFormatter;
	import com.longtailvideo.jwplayer.events.ComponentEvent;
	import com.longtailvideo.jwplayer.events.MediaEvent;
	import com.longtailvideo.jwplayer.events.PlayerEvent;
	import com.longtailvideo.jwplayer.events.PlayerStateEvent;
	import com.longtailvideo.jwplayer.events.PlaylistEvent;
	import com.longtailvideo.jwplayer.events.ViewEvent;
	import com.longtailvideo.jwplayer.player.IPlayer;
	import com.longtailvideo.jwplayer.plugins.IPlugin;
	import com.longtailvideo.jwplayer.plugins.PluginConfig;
	import com.longtailvideo.jwplayer.utils.Animations;
	import com.longtailvideo.jwplayer.utils.Logger;
	import com.longtailvideo.jwplayer.utils.Strings;
	import com.longtailvideo.jwplayer.view.components.ControlbarComponentV4;
	import com.longtailvideo.jwplayer.view.components.Slider;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.SecurityErrorEvent;
	import flash.filters.DropShadowFilter;
	import flash.geom.Rectangle;
	import flash.net.LocalConnection;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.utils.setInterval;
	import flash.utils.setTimeout;
	import org.osmf.metadata.TimelineMarker;
	import us.wcweb.Cueboy.command.CueConnectLocalSwf;
	import us.wcweb.Cueboy.command.CueItemHandler;
	import us.wcweb.Cueboy.event.CueItemEvent;
	import us.wcweb.Cueboy.event.CueWithServerEvent;
	import us.wcweb.Cueboy.event.ViewLayerEvent;
	import us.wcweb.Cueboy.model.CueWithServer;
	import us.wcweb.Cueboy.model.XmlParser;
	import us.wcweb.Cueboy.model.config.ViewLayerConfig;
	import us.wcweb.Cueboy.model.structElement.CuePointsItem;
	import us.wcweb.Cueboy.utils.Colors;
	import us.wcweb.Cueboy.view.ViewLayer;

















	/**
	 * @author macbookpro
	 */
	/** This plugin displays an overlay with cue points in thi video. **/
	public class Cueboysw extends Cueboy implements IPlugin {
		// /** Embedding the image assets. **/
		[Embed(source="../../../../../assets/ke.png")]
		private const DockIcon : Class;
		// /** Reference to the dock button. **/
		private var _button : MovieClip;
		// /** Default dimensions for the grid. **/
		private var _dimensions : Array;
		// /** Link to the mRSS file with related videos. **/
		private var _file : String;
		// /** Component that loads the related videos. **/
		private var _loader : URLLoader;
		// /** Component that parses the related videos. **/
		private var _parser : XmlParser;
		// /** Reference to the player. **/
		private var _player : IPlayer;
		// /** The latest player playback state. **/
		private var _playerState : String;
		// /** Configuration list of the plugin. **/
		private var _config : PluginConfig;
		/**
		 * @private nam 
		 */
		private var nam : String = "cueboysw";

		override public function initPlugin(player : IPlayer, config : PluginConfig) : void {
			/**
			 * 
			 * _config{usedock:true;   dockname :true ; heading: 'heading'; eidtable:false;url:'';oncomplete:function;dimensions:'140x58'}
			 * 
			 */
			_player = player;
			_config = config;

			// @TODO: fix duplicat name problem.
			// if (_config.filename !== undefined) {
			// nam = _config.filename;
			// }else{
			// nam : String = "CueEx";
			// }
			super._name = nam;
			super.initPlugin(_player, _config);
		}

		override protected function setDockName() : void {
			// dock  button
			if (_config.usedock !== false) {
				if (_config.dockname !== null) {
					_button = _player.controls.dock.addButton(new DockIcon(), _config.dockname, _dockHandler);
				} else {
					_button = _player.controls.dock.addButton(new DockIcon(), "教学环节", _dockHandler);
				}
			}
		}

		/**
		 * MouseEvent dock,back,replay,
		 * 
		 */
		private function _dockHandler(evt : MouseEvent) : void {
			super.show();
		};

		// override public function get id() : String {
		// return nam;
		// };
		override public function resize(width : Number, height : Number) : void {
			super.resize(width, height);
		}
	}
}