package controller
{

	import model.GalleryModel;
	import model.vo.GalleryItem;

	import robotlegs.bender.framework.api.ILogger;

	public class SelectImageCommand
	{
		[Inject]
		public var item:GalleryItem;

		[Inject]
		public var galleryModel:GalleryModel;

		[Inject]
		public var logger:ILogger;

		public function execute():void {

			logger.info( "setting selected image" );

	   		galleryModel.selectedItem = item;

		}
	}
}
