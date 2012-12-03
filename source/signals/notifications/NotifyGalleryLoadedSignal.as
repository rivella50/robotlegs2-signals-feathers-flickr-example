package signals.notifications
{

	import model.vo.GalleryItemVO;

	import org.osflash.signals.Signal;

	public class NotifyGalleryLoadedSignal extends Signal
	{
		public function NotifyGalleryLoadedSignal() {

			super( Vector.<GalleryItemVO> );

		}
	}
}
