package model.vo
{

	public class GalleryItem
	{
		public var title:String;
		public var url:String;
		public var thumbURL:String;

		public function GalleryItem( title:String, url:String, thumbUrl:String ) {

			this.title = title;
			this.url = url;
			this.thumbURL = thumbUrl;

		}

		public function toString():String {

			return "GalleryItem - title: " + title + ", url: " + url + ", thumbUrl: " + thumbURL;

		}
	}
}
