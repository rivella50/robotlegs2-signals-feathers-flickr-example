package {

	import controller.LoadGalleryCommand;
	import controller.SelectImageCommand;
	import controller.UpdateGalleryCommand;

	import flash.events.IEventDispatcher;

	import model.GalleryModel;

	import org.swiftsuspenders.Injector;

	import robotlegs.bender.extensions.contextView.ContextView;
	import robotlegs.bender.extensions.mediatorMap.api.IMediatorMap;
	import robotlegs.bender.extensions.signalCommandMap.api.ISignalCommandMap;
	import robotlegs.bender.framework.api.IConfig;
	import robotlegs.bender.framework.api.IContext;
	import robotlegs.bender.framework.api.ILogger;
	import robotlegs.bender.framework.api.LogLevel;

	import service.FlickrImageService;
	import service.IPhotoGalleryService;

	import signals.notifications.RequestGalleryUpdateSignal;
	import signals.notifications.NotifyImageSelectedSignal;
	import signals.requests.RequestGalleryLoadSignal;
	import signals.requests.RequestImageSelectSignal;

	import view.imageview.ImageView;
	import view.imageview.ImageViewMediator;
	import view.thumbsview.ThumbsView;
	import view.thumbsview.ThumbsViewMediator;

	public class AppConfig implements IConfig
	{
		[Inject]
		public var context:IContext;

		[Inject]
		public var commandMap:ISignalCommandMap;

		[Inject]
		public var mediatorMap:IMediatorMap;

		[Inject]
		public var injector:Injector;

		[Inject]
		public var logger:ILogger;

		[Inject]
		public var contextView:ContextView;

		[Inject]
		public var dispatcher:IEventDispatcher;

		public function configure():void {

			// Configure logger.
			context.logLevel = LogLevel.DEBUG;
			logger.info( "configuring application" );

			// Map commands.
			commandMap.map( RequestGalleryLoadSignal ).toCommand( LoadGalleryCommand );
			commandMap.map( RequestImageSelectSignal ).toCommand( SelectImageCommand );
			commandMap.map( RequestGalleryUpdateSignal ).toCommand( UpdateGalleryCommand );

			// Map independent notification signals.
			injector.map( NotifyImageSelectedSignal ).asSingleton();

			// Map views.
			mediatorMap.map( ThumbsView ).toMediator( ThumbsViewMediator );
			mediatorMap.map( ImageView ).toMediator( ImageViewMediator );

			// Map models.
			injector.map( GalleryModel ).asSingleton();

			// Map services.
			injector.map( IPhotoGalleryService ).toSingleton( FlickrImageService );

			// Start.
			context.lifecycle.afterInitializing( init );

		}

		private function init():void {

			logger.info( "application ready" );

		}
	}
}
