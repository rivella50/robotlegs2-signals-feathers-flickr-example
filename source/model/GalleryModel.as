package model
{

	import model.vo.GalleryItemVO;

	import robotlegs.bender.framework.api.ILogger;

	import signals.notifications.NotifyImageSelectedSignal;

	public class GalleryModel
	{
		[Inject]
		public var logger:ILogger;

		[Inject]
		public var notifyImageSelectedSignal:NotifyImageSelectedSignal;

		private var _galleryItems:Vector.<GalleryItemVO>;
		private var _selectedItem:GalleryItemVO;

		public function set galleryItems( value:Vector.<GalleryItemVO> ):void {
			_galleryItems = value;
			logger.info( "gallery set: " + value );
		}

		public function get galleryItems():Vector.<GalleryItemVO> {
			return _galleryItems;
		}

		public function set selectedItem( value:GalleryItemVO ):void {
			if( _selectedItem && _selectedItem == value ) return;
			_selectedItem = value;
			logger.info( "selected item set: " + value );
			notifyImageSelectedSignal.dispatch( _selectedItem );
		}

		public function get selectedItem():GalleryItemVO {
			return _selectedItem;
		}
	}
}
