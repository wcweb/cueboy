package us.wcweb.Cueboy.model.structElement {
	import org.osmf.metadata.CuePoint;
	import org.osmf.metadata.CuePointType;

	/**
	 * @author macbookpro
	 */
	public class CuePointsItem extends CuePoint {
		/**
		 * protected var dura:DurationElement;
		 * use this type deal with duration.
		 * TODO DurationElement
		 */
		public function CuePointsItem(name : String, time : Number, duration : Number) {
			// type:String, time:Number, name:String, parameters:Object, duration:Number=NaN
			super(CuePointType.NAVIGATION, time, name, null, duration);
		}

		public function toString() : String {
			return new String('us.wcweb.Cueboy.model.CuePointsItem : ' + name + ":" + "time:" + time + " ;" + "duration:" + duration);
		}
	}
}
