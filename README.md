CueBoy
======

Jwplayer plugin for cue points just like playlist. A video should be have some events divide by cue points.
<p> this plugin is only use for determine events in a progress.</p>



	<script type="text/javascript">
		jwplayer("player").setup({
		    file: 'assets/video.mp4',
		    flashplayer: 'rc/Avaplayer.swf',
		    height: 270,
		    image:'http://content.bitsontherun.com/thumbs/nPripu9l-480.jpg',
		    plugins: {
		        'rc/cueboy.swf': {
	      			dockname:'哇哈哈',
				    heading: '我的小宇宙，我的兄弟们',
				    dimensions:'100x50',
				    // file: 'assets/empty.xml',//static file
					file:'/list' // dynamate output
		        }
		    },
		    width: 480
		});
	</script>	