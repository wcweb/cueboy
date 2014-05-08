package us.wcweb.Cueboy.model {
	import com.longtailvideo.jwplayer.parsers.IPlaylistParser;
	import com.longtailvideo.jwplayer.utils.Logger;
	import com.longtailvideo.jwplayer.utils.Strings;
	import us.wcweb.Cueboy.model.structElement.CuePointsItem;



	/**
	 * @author macbookpro
	 */
	public class XmlParser implements IPlaylistParser {
		/** Translate RSS item to playlist item. **/
		public function parseItem(obj : XML) : CuePointsItem {
			var itm : Object = new Object();
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
						itm['time'] = Math.floor(Number(i.text().toString()) / 1000).toString();
						break;
					case 'duration':
						itm['duration'] = Strings.seconds(Math.floor(Number(i.text().toString()) / 1000).toString());
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

			// itm = CuePointParser.parseEntry(obj, itm);

			return new CuePointsItem(itm['name'], itm['time'], itm['duration']);
		}

		public function parse(dat : XML) : Array {
			var arr : Array = new Array();
			for each (var i:XML in dat.children()) {
				if (i.localName().toLowerCase() == 'channel') {
					for each (var j:XML in i.children()) {
						if (j.localName().toLowerCase() == 'item') {
							arr.push(parseItem(j));
						}
					}
				}
			}
			// for each(var itm:CuePointsItem in arr) {
			// Logger.log('cuePoint parse'+ itm.time);
			// }
			return arr;
		}
	}
}
