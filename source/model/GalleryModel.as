package model
{

	import model.vo.GalleryItem;

	import robotlegs.bender.framework.api.ILogger;

	import signals.notifications.NotifyImageSelectedSignal;

	public class GalleryModel
	{
		[Inject]
		public var logger:ILogger;

		[Inject]
		public var notifyImageSelectedSignal:NotifyImageSelectedSignal;

		private var _gallery:Vector.<GalleryItem>;
		private var _selectedItem:GalleryItem;

		public function set gallery( value:Vector.<GalleryItem> ):void {
			_gallery = value;
			logger.info( "gallery set: " + value );
		}

		public function get gallery():Vector.<GalleryItem> {
			return _gallery;
		}

		public function set selectedItem( value:GalleryItem ):void {
			if( _selectedItem && _selectedItem == value ) return;
			_selectedItem = value;
			logger.info( "selected item set: " + value );
			notifyImageSelectedSignal.dispatch( _selectedItem );
		}

		public function get selectedItem():GalleryItem {
			return _selectedItem;
		}
	}
}
