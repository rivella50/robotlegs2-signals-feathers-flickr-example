package view.thumbsview
{

	import feathers.controls.List;
	import feathers.controls.Scroller;
	import feathers.data.ListCollection;
	import feathers.layout.HorizontalLayout;

	import model.vo.GalleryItemVO;

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

			imageSelectedSignal = new Signal( GalleryItemVO );

		}

		private function initializeList():void {

			var listLayout:HorizontalLayout = new HorizontalLayout();
			listLayout.verticalAlign = HorizontalLayout.VERTICAL_ALIGN_JUSTIFY;
			listLayout.hasVariableItemDimensions = true;
			listLayout.gap = 5;

			_list = new List();
			_list.layout = listLayout;
			_list.backgroundSkin = new Quad( 100, AppSettings.THUMBS_PANEL_HEIGHT, 0x222222 );
			_list.horizontalScrollPolicy = Scroller.SCROLL_POLICY_ON;
			_list.snapScrollPositionsToPixels = true;
			_list.itemRendererType = GalleryItemRenderer;
			_list.itemRendererProperties.labelField = "title";
			_list.addEventListener( Event.CHANGE, onListChange );
			addChild( _list );

		}

		override protected function onLayout():void {

			if( _list ) {
				_list.width = stage.width;
				_list.height = AppSettings.THUMBS_PANEL_HEIGHT;
				_list.y = stage.stageHeight - _list.height;
				_list.validate();
			}

		}

		private function onListChange( event:Event ):void {

			var item:GalleryItemVO = _list.selectedItem as GalleryItemVO;
			imageSelectedSignal.dispatch( item );

		}

		public function setData( galleryItems:Vector.<GalleryItemVO> ):void {

			if( !_list ) {
				initializeList();
			}

			_list.dataProvider = new ListCollection( galleryItems );
			_list.selectedIndex = 0;

			onLayout();
		}
	}
}
