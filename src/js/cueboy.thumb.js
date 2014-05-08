(function(jwplayer) {


    /**
    * Renders a single related thumb.
    **/
    if(jwplayer.cueboy) { return; }
    jwplayer.cueboy = {};
    jwplayer.cueboy.thumb = function(_width,_height,_item,_handler) {


        /** Reference to the background div. **/
        var _back;
        /** styling for thumbnail. **/
        var _backStyle = {
            border: '1px solid #000',
            webkitBoxShadow: '0 0 4px #000',
            MozBoxShadow: '0 0 4px #000',
            msBoxShadow: '0 0 4px #000',
            boxShadow: '0 0 4px #000',
            backgroundColor: '#000',
            backgroundSize: 'cover',
            position: 'absolute',
            textDecoration: 'none',
            display: 'block',
            margin: '0 0 0 0',
            padding: '0 0 0 0',
            overflow: 'hidden'
        };
        /** Reference to the glow div. **/
        var _glow;
        /** Style settings for the glow div. **/
        var _glowStyle = {
            psition: 'absolute',
            left: '0px',
            top: '0px',
            border: 'none',
            margin: '0 0 0 0',
            padding: '0 0 0 0'
        };
        /** Reference to the title overlay. **/
        var _text;
        /** Styling for the title overlay. **/
        var _textStyle = {
            backgroundColor: 'rgba(0,0,0,0.8)',
            left: '0px',
            position: 'absolute',
            border: 'none',
            color: '#FFF',
            display: 'block',
            font: '12px/16px Arial,sans-serif',
            margin: '0 0 0 0',
            textAlign: 'center',
            textDecoration: 'none',
            textTransform: 'none',
            padding: '5px'
        };


        /** Set white shadow when rolling over thumb. **/
        function _over(event) {
            _style(_back,{
                border: '1px solid #FFF',
                webkitBoxShadow: '0 0 4px #FFF',
                MozBoxShadow: '0 0 4px #FFF',
                msBoxShadow: '0 0 4px #FFF',
                boxShadow: '0 0 4px #FFF'
            });
        };


        /** Set black shadow when rolling out thumb. **/
        function _out(event) {
            _style(_back,{
                border: '1px solid #000',
                webkitBoxShadow: '0 0 4px #000',
                MozBoxShadow: '0 0 4px #000',
                msBoxShadow: '0 0 4px #000',
                boxShadow: '0 0 4px #000'
            });
        };


        /** Call the click handler when thumb is clicked. **/
        function _click(event) {
            _handler(_item);
        };


        /** Create all elements. **/
        function _setup() { 
            _back = document.createElement("div");
            _back.onclick = _click;
            _back.onmouseout = _out;
            _back.onmouseover = _over;
            _style(_back,_backStyle);
            _style(_back,{
                backgroundImage: 'url('+_item.image+')',
                width: (_width-2)+'px',
                height: (_height-2)+'px'
            });
            _glow = document.createElement("img");
            _glow.setAttribute('src','../assets/glow.png');
            _style(_glow,_glowStyle);
            _style(_glow,{
                width: _width-2+'px',
                height: _height-20+'px'
            });
            _back.appendChild(_glow);
            _text = document.createElement('div');
            _text.innerHTML = _item.title;
            _style(_text,_textStyle);
            var lines = Math.ceil(_item.title.length * 6 / _width);
            _style(_text,{
                width: (_width - 10) + 'px',
                top: (_height - 10 - lines * 16) + 'px'
            });
            _back.appendChild(_text);
            return _back;
        };


        /** Apply CSS styles to elements. **/
        function _style(element,styles) {
            for(var property in styles) {
              element.style[property] = styles[property];
            }
         };


        /** Setup the thumb and return element. **/
        return _setup();


    };


})(jwplayer);