package view.thumbsview
{

	import feathers.controls.List;
	import feathers.controls.Scroller;
	import feathers.data.ListCollection;
	import feathers.layout.HorizontalLayout;

	import model.vo.GalleryItem;

	import org.osflash.signals.Signal;

	import starling.display.Quad;
	import starling.events.Event;

	import view.base.StarlingViewBase;

	public class ThumbsView extends StarlingViewBase
	{
		private var _list:List;

		public var imageSelectedSignal:Signal;

		public function ThumbsView() {

			super();

			imageSelectedSignal = new Signal( GalleryItem );

		}

		override protected function onSetup():void {

			initializeList();
			
		}

		private function initializeList():void {

			var listLayout:HorizontalLayout = new HorizontalLayout();
			listLayout.verticalAlign = HorizontalLayout.VERTICAL_ALIGN_JUSTIFY;
			listLayout.gap = 5;
			listLayout.hasVariableItemDimensions = true;

			_list = new List();
			_list.layout = listLayout;
			_list.backgroundSkin = new Quad( 100, AppSettings.THUMBS_PANEL_HEIGHT, 0x222222 );
			_list.scrollerProperties.horizontalScrollPolicy = Scroller.SCROLL_POLICY_ON;
			_list.scrollerProperties.snapScrollPositionsToPixels = true;
			_list.itemRendererType = GalleryItemRenderer;
			_list.itemRendererProperties.labelField = "title";
			_list.addEventListener( Event.CHANGE, onListChange );
			addChild( _list );

			onLayout();

		}

		override protected function onLayout():void {

			_list.width = stage.width;
			_list.height = AppSettings.THUMBS_PANEL_HEIGHT;
			_list.y = stage.stageHeight - _list.height;

		}

		private function onListChange( event:Event ):void {

			var item:GalleryItem = _list.selectedItem as GalleryItem;
			imageSelectedSignal.dispatch( item );

		}

		public function updateThumbs( gallery:Vector.<GalleryItem> ):void {
			_list.dataProvider = new ListCollection( gallery );
			_list.selectedIndex = 0;
		}
	}
}
