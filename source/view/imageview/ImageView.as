package view.imageview
{

	import feathers.controls.Header;
	import feathers.controls.ProgressBar;
	import feathers.display.Image;

	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;

	import model.vo.GalleryItem;

	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Sprite;
	import starling.textures.Texture;

	import view.base.StarlingViewBase;

	public class ImageView extends StarlingViewBase
	{
		private var _header:Header;
		private var _image:Image;
		private var _loader:Loader;
		private var _fadeTween:Tween;
		private var _imageHolder:Sprite;
		private var _progressBar:ProgressBar;

		private static const LOADER_CONTEXT:LoaderContext = new LoaderContext( true );

		public function ImageView() {
			super();
		}

		override protected function onSetup():void {

			_loader = new Loader();
			_loader.contentLoaderInfo.addEventListener( Event.COMPLETE, onLoaderComplete );
			_loader.contentLoaderInfo.addEventListener( ProgressEvent.PROGRESS, onLoaderProgress );

			_progressBar = new ProgressBar();
			_progressBar.minimum = 0;
			_progressBar.maximum = 1;
			_progressBar.value = 0;
			addChild( _progressBar );

			_imageHolder = new Sprite();
			addChild( _imageHolder );

			_header = new Header();
			addChild( _header );

			onLayout();

		}

		override protected function onLayout():void {

			_header.width = stage.stageWidth;

			if( _image ) {
				_image.height = stage.stageHeight - _header.height - AppSettings.THUMBS_PANEL_HEIGHT;
				_image.scaleX = _image.scaleY;
				_image.x = stage.stageWidth / 2 - _image.width / 2;
				_image.y = _header.height;
			}

			_progressBar.x = stage.stageWidth / 2 - _progressBar.width / 2;
			_progressBar.y = _header.height + ( stage.stageHeight - AppSettings.THUMBS_PANEL_HEIGHT - _header.height ) / 2;

		}

		public function showImage( item:GalleryItem ):void {
			_progressBar.value = 0;
			_header.title = item.title;
			if( _image ) {
				_image.visible = false;
			}
			_loader.load(new URLRequest( item.url ), LOADER_CONTEXT );
			onLayout();
		}

		private function onLoaderComplete( event:Event ):void {
			const bitmap:Bitmap = Bitmap( _loader.content );
			const texture:Texture = Texture.fromBitmap( bitmap );
			if( _image ) {
				_image.texture.dispose();
				_image.texture = texture;
				_image.readjustSize();
			}
			else {
				_image = new Image( texture );
				_imageHolder.addChild( _image );
			}
			_image.alpha = 0;
			_image.visible = true;
			_fadeTween = new Tween( _image, 0.25, Transitions.EASE_OUT );
			_fadeTween.fadeTo( 1 );
			Starling.juggler.add( _fadeTween );
			onLayout();
		}

		private function onLoaderProgress( event:ProgressEvent ):void {

			_progressBar.value = event.bytesLoaded / event.bytesTotal;

		}
	}
}
