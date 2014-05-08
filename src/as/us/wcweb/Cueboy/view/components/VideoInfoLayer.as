package us.wcweb.Cueboy.view.components {
	import flash.display.Sprite;
	import org.aswing.AsWingManager;
	import org.aswing.FlowLayout;
	import org.aswing.GeneralListCellFactory;
	import org.aswing.JFrame;
	import org.aswing.JList;
	import org.aswing.JScrollPane;
	import org.aswing.VectorListModel;
	import us.wcweb.Cueboy.model.structElement.CuePointsItem;




	/**
	 * @author macbookpro
	 */
	public class VideoInfoLayer extends Sprite {
		private var model : VectorListModel;
		private var list : JList;

		public function VideoInfoLayer() {
			super();
			AsWingManager.initAsStandard(this);

			model = new VectorListModel();
			for (var i : int = 0; i < 100; i++) {
				var index : int = int(Math.random() * 7 + 1);
				model.append(new CuePointsItem("name" + index, index, index));
			}
			list = new JList(model, new GeneralListCellFactory(LoadImageListCell, false, true, 64));

			list.setVisibleCellWidth(400);
			list.setVisibleRowCount(4);

			var frame : JFrame = new JFrame(this, "JListExample2");
			frame.getContentPane().setLayout(new FlowLayout());
			frame.getContentPane().append(new JScrollPane(list));
			frame.setSizeWH(400, 300);
			//frame.getContentPane().append(list);
			frame.setState(JFrame.MAXIMIZED);
			frame.show();
			addChild(frame);
		}
	}
}
