package controller
{

	import model.GalleryModel;
	import model.vo.GalleryItem;

	import robotlegs.bender.framework.api.ILogger;

	public class UpdateGalleryCommand
	{
		[Inject]
		public var gallery:Vector.<GalleryItem>;

		[Inject]
		public var logger:ILogger;

		[Inject]
		public var galleryModel:GalleryModel;

		public function execute() {

			logger.info( "updating gallery data" );

			galleryModel.gallery = gallery;

		}
	}
}
