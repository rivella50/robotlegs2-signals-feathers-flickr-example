package view.imageview
{

	import model.vo.GalleryItem;

	import robotlegs.bender.framework.api.ILogger;
	import robotlegs.extensions.starlingViewMap.impl.StarlingMediator;

	import signals.notifications.NotifyImageSelectedSignal;

	public class ImageViewMediator extends StarlingMediator
	{
		[Inject]
		public var logger:ILogger;

		[Inject]
		public var view:ImageView;

		[Inject]
		public var notifyImageSelectedSignal:NotifyImageSelectedSignal;

		override public function initialize():void {

			logger.info( "initialized" );

			// From app.
			notifyImageSelectedSignal.add( onImageSelected );

		}

		private function onImageSelected( item:GalleryItem ):void {

			view.showImage( item );

		}
	}
}
