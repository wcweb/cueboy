(function(jwplayer) {


    /**
    * Displays a grid with cue points in this video on screen.
    **/
    var cueboys = function(_player, _options, _div) {


        /** Reference to the container with elements. **/
        var _container;
        /** Reference to the close button. **/
        var _close;
        /** Array with thumb dimensions. **/
        var _dimensions;
        /** mRSS feed that contains the cueboys videos. **/
        var _file;
        /** Reference to the heading text. **/
        var _heading;
        /** Reference to the grid with thumbs. **/
        var _grid;
        /** Reference to the replay button. **/
        var _replay;


        /** Styling for close and replay buttons. **/
        var _buttonStyle = {
            cursor: 'pointer',
            position: 'absolute',
            left: '0px',
            top: '0px',
            margin: '0px',
            padding: '0px',
            display: 'block',
            width: '50px',
            height: '50px'
        };
        /** Styling for enclosing DIV. **/
        var _divStyle = {
            backgroundImage: 'url(../assets/sheet.png)',
            backgroundRepeat: 'no-repeat',
            backgroundSize: '100% 100%',
            opacity: 0,
            webkitTransition: 'opacity 150ms linear',
            MozTransition: 'opacity 150ms linear',
            msTransition: 'opacity 150ms linear',
            transition: 'opacity 150ms linear',
            cursor: 'pointer',
            visibility: 'hidden'
        };
        /** styling for heading. **/
        var _headingStyle = {
            position: 'absolute',
            border: 'none',
            color: '#FFF',
            display: 'block',
            font: '16px/24px Arial,sans-serif',
            overflow: 'hidden',
            width: '240px',
            margin: '0 0 0 0',
            textAlign: 'center',
            textTransform: 'none',
            textShadow: '#000 1px 1px 0',
            padding: '0 0 0 0'
        };


        /** Dock icon for cueboy items found. **/
        var ICON_RELATED = '../assets/cueboy.png';



        /** Display the cueboy videos menu. **/
        var show = function() {
            if(_file) {
                _player.pause(true);
                _div.style.visibility = 'visible';
                _div.style.opacity = 1;
                try { 
                    _player.getPlugin("display").hide();
                    _player.getPlugin("dock").hide();
                } catch (e) { /* Only 5.7+ */ }
            }
        };


        /** Link or play when a thumb is clicked. **/
        function _click(item) {
            if(_options.onclick == 'play') { 
                _player.load(item);
                _player.play();
            } else {
                window.top.location = item.link;
            }
        };


        /** Display the cueboy items on complete. **/
        function _complete(event) {
            if(_options.oncomplete !== false) {
                setTimeout(_completeWrap,50);
            }
        };

        /** Display the cueboy items on complete. **/
        function _completeWrap(event) {
            if(_player.getState() == 'IDLE') {
                show();
            }
        };


        /** Clean up dock when loading error occured. **/
        function _error(message) {
            if(message == _file) {
                console.log("Cueboy say: Failed to load "+message);
            } else { 
                console.log("Cueboy say: "+message);
            }
            _file = undefined;
            _grid.innerHTML = '';
            _hide();
            if(_options.usedock !== false) {
                _player.getPlugin("dock").setButton('cueboy');
            }
        };


        /** Hide the related videos menu. **/
        function _hide(event) {
            setTimeout(_hideWrap,200);
            _div.style.opacity = 0;
            try { 
                _player.getPlugin("display").show();
                _player.getPlugin("dock").show();
            } catch (e) { /* Only 5.7+ */ }
        };


        /** Set invisibility after transition is done. **/
        function _hideWrap() {
            _div.style.visibility = 'hidden';
        };


        /** Grab cue boys from xml item **/
        function _item(event) {
            // Reset old data
            _file = undefined;
            _grid.innerHTML = '';
            _hide();
            // Check for new feed
            var item = _player.getPlaylist()[event.index];
            if(item['related.file']) {
                _file = item['related.file'];
            } else if (_options['file']) {
                _file = _options['file'];
            }
            // Load the feed and set the dock icon
            if(_file) {
                if(_options.usedock !== false) {
                    _player.getPlugin("dock").setButton('related',show,ICON_RELATED);
                }
                jwplayer.utils.ajax(_file, _loaded, _error);
            } else {
                _error("No related videos file found");
            }
        };


        /** Create thumbs when RSS feed is loaded. **/
        function _loaded(event) {
            var rss = [];
            var related = [];
            try {
                rss = jwplayer.utils.parsers.rssparser.parse(event.responseXML.firstChild);
            } catch (e) {
                _error("This feed is not valid XML and/or RSS.");
                return;
            }
            for (var i=0; i < rss.length; i++) {
                if(rss[i].image && rss[i].title && (
                    (_options.onclick == 'play' && rss[i].file) || 
                    (_options.onclick != 'play' && rss[i].link))) {
                    related.push(rss[i]);
                }
            }
            // Render the thumbnails.
            if(related.length) {
                var col = 0;
                var row = 0;
                _dimensions[4] = 0;
                _dimensions[5] = 0;
                for(var j = 0; j < related.length; j++) {
                    // Append new thumb to grid.
                    var thumb = jwplayer.cueboy.thumb(
                        _dimensions[0],
                        _dimensions[1],
                        related[j],
                        _click
                    );
                    _grid.appendChild(thumb);
                    _style(thumb,{
                        left: ((_dimensions[0]+10) * col)+'px',
                        top: ((_dimensions[1]+10) * row)+'px'
                    });
                    // Store the new grid width and height
                    _dimensions[4] = Math.max(_dimensions[4],_dimensions[0]*(col+1)+10*col)
                    _dimensions[5] = Math.max(_dimensions[5],_dimensions[1]*(row+1)+10*row)
                    // Calculate column/row wrapping.
                    if((_dimensions[0]+10)*(col+2) > _dimensions[2]) {
                        if((_dimensions[1]+10)*(row+2) > _dimensions[3]-80) {
                            break;
                        } else {
                            row++;
                            col = 0;
                        }
                    } else {
                        col++;
                    }
                }
                _reposition(_dimensions[2],_dimensions[3]);
            } else {
                _error("RSS feed has 0 entries that contain title,link and image.");
            }
        };


        /** Set dock buttons when player is ready. **/
        function _setup() {
            if(_player.getRenderingMode() == 'flash') { return; }
            _player.onPlaylistItem(_item);
            _player.onComplete(_complete);
            _style(_div,_divStyle);
            _div.onclick = _hide;
            _replay = document.createElement("div");
            _style(_replay,_buttonStyle);
            _style(_replay,{background:'transparent url(../assets/replay.png)'});
            _replay.onclick = _seek;
            _div.appendChild(_replay);
            _close = document.createElement("div");
            _style(_close,_buttonStyle);
            _style(_close,{background:'transparent url(../assets/close.png)'});
            _close.onclick = _hide;
            _div.appendChild(_close);
            _heading = document.createElement("div");
            if(_options.heading) { 
                _heading.innerHTML = _options.heading;
            } else {
                _heading.innerHTML = "Watch related videos";
            }
            _style(_heading,_headingStyle);
            _div.appendChild(_heading);
            _grid = document.createElement("div");
            _div.appendChild(_grid);
            _style(_grid,{position:'absolute'});
        };
        _player.onReady(_setup);


        /** Store thumb dimensions on first resize. **/
        this.resize = function(width,height) {
            if(_player.getRenderingMode() == 'flash') { return; }
            if(!_dimensions) {
                _dimensions = [140,80,width,height,0,0];
                if(_options.dimensions) {
                    var dim = _options.dimensions.split('x');
                    for(var i=0; i<2; i++) {
                        _dimensions[i] = Number(dim[i]);
                    }
                }
            }
            _reposition(width,height);
        };


        /** Reposition elements upon a resize. **/
        function _reposition(width,height) {
            _style(_div,{
                height: height+'px',
                width: width+'px'
            });
            _style(_close,{left: (width-50)+'px'});
            _style(_grid,{
                left: Math.round(width/2 - _dimensions[4]/2)+'px',
                top: Math.round(height/2 - _dimensions[5]/2)+'px'
            });
            _style(_heading,{
                left: Math.round(width/2 - _dimensions[4]/2)+'px',
                width: _dimensions[4]+'px',
                top: Math.round(height/2 - _dimensions[5]/2 - 30)+'px'
            });
        };


        /** Replay the current video. **/
        function _seek(event) {
            _player.seek(0);
        };


        /** Apply CSS styles to elements. **/
        function _style(element,styles) {
            for(var property in styles) {
              element.style[property] = styles[property];
            }
         };


    };


    /** Register the plugin with JW Player. **/
    jwplayer().registerPlugin('cueboy', related,'./cueboy.swf');


})(jwplayer);