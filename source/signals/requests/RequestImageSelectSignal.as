package signals.requests
{

	import model.vo.GalleryItemVO;

	import org.osflash.signals.Signal;

	public class RequestImageSelectSignal extends Signal
	{
		public function RequestImageSelectSignal() {
			super( GalleryItemVO );
		}
	}
}
