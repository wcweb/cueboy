package us.wcweb.Cueboy.model {
	import com.longtailvideo.jwplayer.utils.Logger;
	import com.longtailvideo.jwplayer.utils.Strings;

	/**
	 * Parse CuePoints specific RSS feed content into playlists.
	 **/
	public class CuePointParser {
		/** Prefix for the iTunes namespace. **/
		private static const PREFIX : String = 'CuePoint';

		/**
		 * Parse a feedentry for iTunes content.
		 *
		 * @param obj	The XML object to parse.
		 * @param itm	The playlistentry to amend the object to.
		 * @return		The playlistentry, amended with the iTunes info.
		 * @see			RSSParser
		 **/
		public static function parseEntry(obj : XML, itm : Object) : Object {
			for each (var i:XML in obj.children()) {
				// if (i.namespace().prefix == CuePointParser.PREFIX) {
				switch (i.localName().toLowerCase()) {
					case 'title':
						itm['name'] = i.text().toString();
						break;
					case 'author':
						itm['author'] = i.text().toString();
						break;
					case 'seektime':
						itm['time'] = Math.floor(Number(i.text().toString()) / 1000);
						break;
					case 'duration':
						itm['duration'] = Strings.seconds(i.text().toString());
						break;
					case 'summary':
						itm['description'] = i.text().toString();
						break;
					case 'keywords':
						itm['tags'] = i.text().toString();
						break;
				}
				// }
			}
			return itm;
		}
	}
}