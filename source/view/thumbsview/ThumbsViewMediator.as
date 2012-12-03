package view.thumbsview
{

	import flash.events.IEventDispatcher;

	import model.vo.GalleryItem;

	import robotlegs.bender.framework.api.ILogger;
	import robotlegs.extensions.starlingViewMap.impl.StarlingMediator;

	import signals.notifications.NotifyGalleryLoadedSignal;
	import signals.requests.RequestImageSelectSignal;
	import signals.requests.RequestGalleryLoadSignal;

	public class ThumbsViewMediator extends StarlingMediator
	{
		[Inject]
		public var logger:ILogger;

		[Inject]
		public var dispatcher:IEventDispatcher;

		[Inject]
		public var view:ThumbsView;

		[Inject]
		public var notifyGalleryLoadedSignal:NotifyGalleryLoadedSignal;

		[Inject]
		public var requestGalleryLoadSignal:RequestGalleryLoadSignal;

		[Inject]
		public var requestImageSelectSignal:RequestImageSelectSignal;

		override public function initialize():void {

			logger.info( "initialized" );

			// Trigger image service.
			requestGalleryLoadSignal.dispatch();

			// From app.
			notifyGalleryLoadedSignal.add( onGalleryLoaded );

			// From view.
			view.imageSelectedSignal.add( onImageSelected );

		}

		private function onImageSelected( item:GalleryItem ):void {

			requestImageSelectSignal.dispatch( item );

		}

		private function onGalleryLoaded( gallery:Vector.<GalleryItem> ):void {

			view.updateThumbs( gallery );

		}
	}
}
