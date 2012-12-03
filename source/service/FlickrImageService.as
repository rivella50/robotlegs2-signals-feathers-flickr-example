package service
{

	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	import model.vo.GalleryItem;

	import robotlegs.bender.framework.api.ILogger;

	import signals.notifications.NotifyGalleryLoadedSignal;

	public class FlickrImageService implements IPhotoGalleryService
	{
		[Inject]
		public var eventDispatcher:IEventDispatcher;

		[Inject]
		public var logger:ILogger;

		[Inject]
		public var notifyGalleryLoadedSignal:NotifyGalleryLoadedSignal;

		private static const FLICKR_API_KEY:String = "abbb50ead4f289ee0ef1baf1e3491cb9";
		private static const FLICKR_URL:String = "http://api.flickr.com/services/rest/?method=flickr.interestingness.getList&api_key=" + FLICKR_API_KEY + "&format=rest";
		private static const FLICKR_PHOTO_URL:String = "http://farm{farm-id}.staticflickr.com/{server-id}/{id}_{secret}_{size}.jpg";

		private var _urlLoader:URLLoader;

		public function FlickrImageService() {

			_urlLoader = new URLLoader();

		}

		public function loadData():void {

			logger.info( "loading gallery" );

			_urlLoader.addEventListener( Event.COMPLETE, onUrlLoaderComplete );
			_urlLoader.load( new URLRequest( FLICKR_URL ) );

		}

		private function onUrlLoaderComplete( event:Event ):void {

			logger.info( "gallery loaded" );

			_urlLoader.removeEventListener( Event.COMPLETE, onUrlLoaderComplete );

			const result:XML = XML( _urlLoader.data );

			if( result.attribute( "stat" ) == "fail" ) {

				throw new Error( "Unable to load Flickr data." );

			}

			const gallery:Vector.<GalleryItem> = new <GalleryItem>[];
			const photosList:XMLList = result.photos.photo;
			const photoCount:int = photosList.length();
			for( var i:int = 0; i < photoCount; i++ ) {
				var photoXML:XML = photosList[i];
				var url:String = FLICKR_PHOTO_URL.replace( "{farm-id}", photoXML.@farm.toString() );
				url = url.replace( "{server-id}", photoXML.@server.toString() );
				url = url.replace( "{id}", photoXML.@id.toString() );
				url = url.replace( "{secret}", photoXML.@secret.toString() );
				var thumbURL:String = url.replace( "{size}", "t" );
				url = url.replace( "{size}", "b" );
				var title:String = photoXML.@title.toString();
				var item:GalleryItem = new GalleryItem( title, url, thumbURL );
				logger.info( item.toString() );
				gallery.push( item );
			}

			notifyGalleryLoadedSignal.dispatch( gallery );

		}
	}
}
