package signals.requests
{

	import model.vo.GalleryItemVO;

	import org.osflash.signals.Signal;

	public class RequestGalleryUpdateSignal extends Signal
	{
		public function RequestGalleryUpdateSignal() {

			super( Vector.<GalleryItemVO> );

		}
	}
}
