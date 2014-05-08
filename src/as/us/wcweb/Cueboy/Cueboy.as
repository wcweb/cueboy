package us.wcweb.Cueboy {
	import us.wcweb.Cueboy.view.GirdLayer;
	import us.wcweb.Cueboy.view.IViewer;
	import com.adobe.utils.NumberFormatter;
	import com.demonsters.debugger.MonsterDebugger;
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
	import us.wcweb.Cueboy.view.CueLineMaker;
	import us.wcweb.Cueboy.view.ViewLayer;
	import us.wcweb.Cueboy.view.components.VideoInfoLayer;

	/**
	 * @author macbookpro
	 */
	/** This plugin displays an overlay with cue points in thi video. **/
	public class Cueboy extends Sprite implements IPlugin {
		// /** Embedding the image assets. **/
		[Embed(source = "../../../../../assets/zhi.png")]
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
		// private var _rectangle : MovieClip;
		//
		private var _viewLayer : IViewer;
		private var _currentPosition : Number;
		private var _repeatCueBool : Boolean = true;
		private var _cih : CueItemHandler;
		private var _pluginStatus : Boolean;
		private var _initsize : Boolean;
		private var _showBeforePlay : Boolean;
		private var _myColor : Number;
		private var _con : CueConnectLocalSwf;
		public var lc_name : String;
		private var needRedraw : Number = -1;
		private var _currentCuePoitionStart : TimelineMarker = new TimelineMarker(-1);
		private var _currentCuePoitionEnd : TimelineMarker = new TimelineMarker(-1);
		private var _cuelinemaker : CueLineMaker;
		protected var _name : String = "cueboy";

		public function initPlugin(player : IPlayer, config : PluginConfig) : void {
			/**
			 * 
			 * _config{usedock:true;   dockname :true ; heading: 'heading'; eidtable:false;url:'';oncomplete:function;dimensions:'140x58'}
			 * 
			 */
			_player = player;
			_config = config;
			_myColor = Colors.RandomColor();

			_con = new CueConnectLocalSwf();

			_con.name = _config.lc_name == undefined ? "lc_arrow" : _config.lc_name;
			// @TODO when it need be client
			// _con.connect();
			_dimensions = new Array();
			// if (_config.dimensions !== null) {
			// var dim : Array = _config.dimensions.split('x');
			// for (var i : Number = 0; i < 2; i++) {
			// _dimensions[i] = Number(dim[i]);
			// }
			// }
			_dimensions = [100, 100, 0, 0];
			// Start the MonsterDebugger
			MonsterDebugger.initialize(this);
			MonsterDebugger.enabled=false;
			MonsterDebugger.trace(this, _dimensions);

			// before componentshow
			_cuelinemaker = new CueLineMaker();
			_cuelinemaker.component = _player.controls.controlbar as ControlbarComponentV4;
			_cuelinemaker.color = _myColor;
			_cuelinemaker.duration = -1;
			addChild(_cuelinemaker);

			_pluginStatus = false;

			_initsize = true;

			

			// xml parse
			_parser = new XmlParser();

			setDockName();

			_currentPosition = -1;

			// view
			var viewlayer_config : ViewLayerConfig = new ViewLayerConfig();
			// viewlayer_config.replay = _replayHandler;
			viewlayer_config.color = _myColor;

			// viewlayer_config.click = clickHandler;

			// repeat play a duration
			if (_config.repeatable !== undefined) {
				_repeatCueBool = _config.repeatable;
				viewlayer_config.repeat = _config.repeatable;
			} else {
				_repeatCueBool = true;
			}

			_showBeforePlay = _config.showBeforePlay !== null ? _config.showBeforePlay : false;

			// heading
			if (_config.title !== undefined) {
				viewlayer_config.title = _config.title;
			}
			if (_config.introduction !== undefined) {
				viewlayer_config.introduction = _config.introduction;
			}
			
						// editable
			if (_config.editable !== undefined) {
				if (_config.editable !== false && _config.url !== undefined) {
					// init editable statue

					// @TODO make it single
					_cih = new CueItemHandler(_viewLayer, _config.url);
				}
			}

			// @TODO: fix duplicat case name problem.
			if (_config.filename !== undefined) {
				_name = String(_config.filename).toLowerCase();
			}
			Logger.log("inint config"+_config);

			MonsterDebugger.trace(this, _config);

			_viewLayer = new ViewLayer(viewlayer_config);
			//_viewLayer = GirdLayer.getInstance(viewlayer_config);
			_viewLayer.addEventListener(ViewLayerEvent.REPLAY_PLAYER, _replayHandler);
			_viewLayer.addEventListener(ViewLayerEvent.BACKTO_PLAYER, _backToPlayerHandler);
			_viewLayer.addEventListener(CueItemEvent.CLICK_ITEM, _itemClickedHandler);
			_viewLayer.addEventListener(ViewLayerEvent.REPEAT_CHECKBOX,_repeat_checkboxHandler);

			addChild(_viewLayer as DisplayObject);


			
			// player event
			_player.addEventListener(MediaEvent.JWPLAYER_MEDIA_COMPLETE, _completeHandler);

			_player.addEventListener(PlaylistEvent.JWPLAYER_PLAYLIST_LOADED, _mediaReadyHandler);

			_player.addEventListener(PlaylistEvent.JWPLAYER_PLAYLIST_ITEM, _playlistItemReady);

			_player.addEventListener(PlayerStateEvent.JWPLAYER_PLAYER_STATE, _stateHandler);

			_player.addEventListener(MediaEvent.JWPLAYER_MEDIA_TIME, _timeHandler);

			_player.controls.controlbar.addEventListener(ComponentEvent.JWPLAYER_COMPONENT_HIDE, _componentHideHandler);
			_player.controls.controlbar.addEventListener(ComponentEvent.JWPLAYER_COMPONENT_SHOW, _componentShowHandler);

			_player.addEventListener(ViewEvent.JWPLAYER_VIEW_FULLSCREEN, _fullScreenHandler);

			// loader xml file
			_loader = new URLLoader();
			_loader.addEventListener(Event.COMPLETE, _loaderHandler);
			_loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, _errorHandler);
			_loader.addEventListener(IOErrorEvent.IO_ERROR, _errorHandler);
		}

		protected function setDockName() : void {
			// dock  button
			if (_config.usedock !== false) {
				if (_config.dockname !== null) {
					_button = _player.controls.dock.addButton(new DockIcon(), _config.dockname, _dockHandler);
				} else {
					_button = _player.controls.dock.addButton(new DockIcon(), "Cueboy", _dockHandler);
				}
			}
		}

		private function _repeat_checkboxHandler(e : ViewLayerEvent) : void {
			_repeatCueBool = e.data as Boolean;
		}

		private function _itemClickedHandler(e : CueItemEvent) : void {
			var item : CuePointsItem = e.item;
			_currentCuePoitionStart = new TimelineMarker(item.time);

			if (!isNaN(item.duration)) {
				_currentCuePoitionEnd = new TimelineMarker(_currentCuePoitionStart.time + item.duration);
				if (_player.playlist.currentItem.duration != -1 && (_currentCuePoitionStart.time + item.duration) > _player.playlist.currentItem.duration) {
					_currentCuePoitionEnd = new TimelineMarker(_player.playlist.currentItem.duration - 3);
				}
				// still not corect , as begin plaer can not know currentItem.duration.   so   handler it in _redrawshade
			} else {
				if (!isNaN(_player.playlist.currentItem.duration)) {
					_currentCuePoitionEnd = new TimelineMarker(_player.playlist.currentItem.duration);
				} else {
					_currentCuePoitionEnd = new TimelineMarker(-1);
					;
				}
			}

			if (_repeatCueBool) {
				// .log('play start ' + _currentCuePoitionStart.time + " play end " + _currentCuePoitionEnd.time);
				needRedraw = 3;
				_cuelinemaker.duration = _player.playlist.currentItem.duration;
				_cuelinemaker.redrawShade(_currentCuePoitionStart.time, _currentCuePoitionEnd.time);
			}

			hide();

			// setInterval(_replayCuePointHandler, item.duration*1000);
			// var randomColorID : Number = Math.floor(Math.random() * _colorArray.length);
			// _myColor = _colorArray[randomColorID];

			_player.seek(_currentCuePoitionStart.time);
		};

		/**
		 * MouseEvent dock,back,replay,
		 * 
		 */
		private function _dockHandler(evt : MouseEvent) : void {
			//_con.sendCurrentPosition("isHere", new TimelineMarker(_currentPosition))
			show();
		};

		private  function _replayHandler(e : ViewLayerEvent) : void {
			hide();
			_player.seek(0);
		};

		private function _backToPlayerHandler(e : ViewLayerEvent) : void {
			hide();
			// _player.play();
		}

		/**
		 * PlayerEvent time
		 * 
		 */
		private function _replayCuePointHandler() : void {
			_player.seek(_currentCuePoitionStart.time);
		}

		private function _timeHandler(e : MediaEvent) : void {
			if (_repeatCueBool) {
				_currentPosition = e.position;
				// Logger.log('current position' + Math.floor(_currentPosition) + "re option" + _repeatCueBool);
				if (_currentPosition < _currentCuePoitionStart.time - 5 ) {
					_player.seek(_currentCuePoitionStart.time - 1);
				}

				if (_currentCuePoitionEnd.time !== -1) {
					if (Math.floor(_currentPosition) == _currentCuePoitionEnd.time) {
						// if (_repeatCueBool  _viewLayer.repeatCheckBox.selected) {
						if (_repeatCueBool) {
							// Logger.log('time to replay');
							_player.seek(_currentCuePoitionStart.time);
						}
					}
				} else {
					_currentCuePoitionEnd = new TimelineMarker(_player.playlist.currentItem.duration);
				}
				if (needRedraw > 0) {
					// _cuelinemaker.duration = _player.playlist.currentItem.duration;
					_cuelinemaker.redrawShade(_currentCuePoitionStart.time, _currentCuePoitionEnd.time);
					needRedraw -= 1;
				}
			} else {
				_cuelinemaker.clear();
			}

			//_con.sendCurrentPosition("timeingHandle", Strings.digits(e.position))
		}

		private  function _fullScreenHandler(e : ViewEvent) : void {
			_viewLayer.dispatchEvent(new ViewLayerEvent(ViewLayerEvent.FULLSCREEN_TOGGLE, e.data))
		}

		private  function _playlistItemReady(e : PlaylistEvent) : void {
			// Reset old data
			_file = undefined;

			if (_showBeforePlay) {
				show();
			} else {
				hide();
			}
			// Logger.log(video_info_layer);
			if (_config['file']) {
				_file = _config['file'];
			}
			// Load the mRSS feed and set the dock icon
			if (_file && _file !== '') {
				_loader.load(new URLRequest(_file));
				if (_button) {
					_button.visible = true;
				}
			} else {
				if (_button) {
					_button.visible = true;
				}
			}
		}

		private  function _completeHandler(evt : MediaEvent) : void {
			if (_config.oncomplete !== false) {
				setTimeout(_completeWrapper, 150);
			}
		};

		private  function _mediaReadyHandler(e : PlaylistEvent) : void {
			hide();
			_cuelinemaker.duration = _player.playlist.currentItem.duration;
			MonsterDebugger.log(this, _player.playlist.currentItem.duration, "in media ready Handler can't get duration?");
			Logger.log("media Ready Event JWPLAYER_PLAYLIST_LOADED");
		}

		private  function _completeWrapper() : void {
			if (_playerState == 'IDLE') {
				show();
			}
		};

		private function _stateHandler(event : PlayerStateEvent) : void {
			_playerState = event.newstate;
		}

		private function _loaderHandler(evt : Event) : void {
			try {
				var xml : XML = XML(evt.target.data);
				var cuePointsItems : Array = _parser.parse(xml);
			} catch (error : Error) {
				_errorHandler(new ErrorEvent(ErrorEvent.ERROR, false, false, "This feed is not valid XML and/or RSS."));
				return;
			}

			_viewLayer.dispatchEvent(new ViewLayerEvent(ViewLayerEvent.LOADED_DATA, cuePointsItems));
		};

		/** handle error message **/
		private  function _errorHandler(evt : ErrorEvent) : void {
			_file = undefined;
			if (_button) {
				_button.visible = false;
			}
		};

		/**
		 * Implement IPlayer resize id initPlugin
		 * 
		 */
		public  function resize(width : Number, height : Number) : void {
			// _dimensions = [120, 40, width, height];
			if (_dimensions) {
				_dimensions[2] = width;
				_dimensions[3] = height;
			}
			MonsterDebugger.trace(this, _dimensions, "resize then .");

			if (_initsize == false) {
				if (_repeatCueBool) {
					_cuelinemaker.redrawShade(_currentCuePoitionStart.time, _currentCuePoitionEnd.time);
				}
			}

			_viewLayer.dispatchEvent(new ViewLayerEvent(ViewLayerEvent.RESIZE_LAYER, _dimensions))
		}

		private  function _componentHideHandler(e : ComponentEvent) : void {
			_cuelinemaker.hide();
		}

		private   function _componentShowHandler(e : ComponentEvent) : void {
			if (_repeatCueBool) {
				_cuelinemaker.redrawShade(_currentCuePoitionStart.time, _currentCuePoitionEnd.time);
			}
			_cuelinemaker.show();
		}

		public function get id() : String {
			
			return _name;
		};

		/**
		 * Utils function
		 * 
		 */
		private function _hide_layer(e : ViewLayerEvent) : void {
			hide();
		}

		public function hide() : void {
			_viewLayer.dispatchEvent(new ViewLayerEvent(ViewLayerEvent.HIDE_LAYER, null));

			try {
				(_player.controls.display as Object).show();
				(_player.controls.dock as Object).show();
			} catch (error : Error) {
				Logger.log("error controls display ");
			}
			_pluginStatus = false;
		};

		public  function show() : void {
			_viewLayer.dispatchEvent(new ViewLayerEvent(ViewLayerEvent.SHOW_LAYER, {position:_currentPosition}));
			MonsterDebugger.log(_viewLayer,'show viewlayer');
			if (_initsize == true) {
				_initsize = false;
			}
			if (_playerState == 'PLAYING') {
				_player.pause();
			}
			try {
				(_player.controls.display as Object).hide();
				(_player.controls.dock as Object).hide();
			} catch (error : Error) {
			}
			_pluginStatus = true;
		};
	}
}
