package controller
{

	import model.GalleryModel;
	import model.vo.GalleryItemVO;

	import robotlegs.bender.framework.api.ILogger;

	public class UpdateGalleryCommand
	{
		[Inject]
		public var gallery:Vector.<GalleryItemVO>;

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
