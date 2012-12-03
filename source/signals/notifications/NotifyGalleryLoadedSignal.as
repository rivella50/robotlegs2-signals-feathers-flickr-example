package signals.notifications
{

	import model.vo.GalleryItem;

	import org.osflash.signals.Signal;

	public class NotifyGalleryLoadedSignal extends Signal
	{
		public function NotifyGalleryLoadedSignal() {

			super( Vector.<GalleryItem> );

		}
	}
}
