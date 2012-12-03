package signals.requests
{

	import model.vo.GalleryItem;

	import org.osflash.signals.Signal;

	public class RequestImageSelectSignal extends Signal
	{
		public function RequestImageSelectSignal() {
			super( GalleryItem );
		}
	}
}
