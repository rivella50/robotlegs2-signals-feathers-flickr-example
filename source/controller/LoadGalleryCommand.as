package controller
{

	import robotlegs.bender.framework.api.ILogger;

	import service.IPhotoGalleryService;

	public class LoadGalleryCommand
	{
		[Inject]
		public var galleryService:IPhotoGalleryService;

		[Inject]
		public var logger:ILogger;

		public function execute() {

			logger.info( "triggering gallery service" );

			galleryService.loadData();

		}
	}
}
