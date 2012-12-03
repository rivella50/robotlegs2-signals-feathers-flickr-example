package view.thumbsview
{

	import feathers.controls.Callout;
	import feathers.controls.Label;
	import feathers.controls.List;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.core.FeathersControl;
	import feathers.display.Image;
	import feathers.display.ScrollRectManager;

	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.geom.Point;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;

	import model.vo.GalleryItemVO;

	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;

	public class GalleryItemRenderer extends FeathersControl implements IListItemRenderer
	{
		private var _loader:Loader;
		private var _image:Image;
		private var _currentImageURL:String;
		private var _fadeTween:Tween;
		private var _touchPointID:int = -1;

		private static const LOADER_CONTEXT:LoaderContext = new LoaderContext( true );
		private static const HELPER_POINT:Point = new Point();

		public function GalleryItemRenderer() {
			super();
			isQuickHitAreaEnabled = true;
			addEventListener( TouchEvent.TOUCH, onControlTouched );
			addEventListener( Event.REMOVED_FROM_STAGE, onRemovedFromStage );
		}

		override protected function draw():void {

//			trace( "GalleryItemRenderer.as - draw() - data: " + _data );

			if( isInvalid( INVALIDATION_FLAG_DATA ) ) {
				if( _data ) {
					if( _data.thumbURL != _currentImageURL ) {
						// Clean up.
						if( _loader ) {
							clearLoader();
						}
						if( _image ) {
							_image.visible = false;
						}
						if( _fadeTween ) {
							Starling.juggler.remove( _fadeTween );
							_fadeTween = null;	
						}
						// Reload.
						_currentImageURL = _data.thumbURL;
						_loader = new Loader();
						_loader.contentLoaderInfo.addEventListener( Event.COMPLETE, onLoaderComplete );
						_loader.contentLoaderInfo.addEventListener( IOErrorEvent.IO_ERROR, onLoaderError );
						_loader.contentLoaderInfo.addEventListener( SecurityErrorEvent.SECURITY_ERROR, onLoaderError );
						_loader.load(new URLRequest( _data.thumbURL ), LOADER_CONTEXT );
					}
				}
				else {
					if( _loader ) {
						clearLoader();
					}
					if( _image ) {
						clearImage();
					}
					_currentImageURL = null;
				}
			}

			if( autoSizeNeeded() || isInvalid( INVALIDATION_FLAG_SIZE ) ) {
				if( _image ) {
					_image.x = ( actualWidth - _image.width ) / 2;
					_image.y = ( actualHeight - _image.height ) / 2;
				}
			}

		}

		private function autoSizeNeeded():Boolean {
			const needsWidth:Boolean = isNaN( explicitWidth );
			const needsHeight:Boolean = isNaN( explicitHeight );
			if( !needsWidth && !needsHeight ) {
				return false;
			}
			var newWidth:Number = explicitWidth;
			if( needsWidth ) {
				if( _image ) {
					newWidth = _image.width;
				}
				else {
					newWidth = 100;
				}
			}
			var newHeight:Number = explicitHeight;
			if( needsHeight ) {
				if( _image ) {
					newHeight = _image.height;
				}
				else {
					newHeight = 100;
				}
			}
			return setSizeInternal( newWidth, newHeight, false );
		}

		private function clearLoader():void {
			_loader.contentLoaderInfo.removeEventListener( Event.COMPLETE, onLoaderComplete );
			_loader.contentLoaderInfo.removeEventListener( IOErrorEvent.IO_ERROR, onLoaderError );
			_loader.contentLoaderInfo.removeEventListener( SecurityErrorEvent.SECURITY_ERROR, onLoaderError );
			_loader = null;
		}

		private function clearImage():void {
			_image.texture.dispose();
			removeChild( _image, true );
			_image = null;
		}

		override public function dispose():void {
			if( _image ) clearImage();
			if( _loader ) clearLoader();
			super.dispose();
		}

		private function onLoaderComplete( event:flash.events.Event ):void {

			const bitmap:Bitmap = Bitmap( _loader.content );
			const texture:Texture = Texture.fromBitmap( bitmap );
			if( _image ) {
				_image.texture.dispose();
				_image.texture = texture;
				_image.readjustSize();
			}
			else {
				_image = new Image( texture );
				addChild( _image );
			}
			_image.alpha = 0;
			_image.visible = true;
			_fadeTween = new Tween( _image, 0.25, Transitions.EASE_OUT );
			_fadeTween.fadeTo( 1 );
			Starling.juggler.add( _fadeTween );
			invalidate( INVALIDATION_FLAG_SIZE );

			clearLoader();
		}

		private function onLoaderError( event:IOErrorEvent ):void {
			clearLoader();
		}

		private function onOwnerScroll( event:Event ):void {
			_touchPointID = -1;
		}

		private function onRemovedFromStage( event:Event ):void {
			_touchPointID = -1;
		}

		// TODO: this needs to be understood, run some traces to see what's going on
		private function onControlTouched( event:TouchEvent ):void {
			const touches:Vector.<Touch> = event.getTouches( this );
			if( touches.length == 0 ) {
				return;
			}
			if( _touchPointID >= 0 ) {
				var touch:Touch;
				for each( var currentTouch:Touch in touches ) {
					if( currentTouch.id == _touchPointID ) {
						touch = currentTouch;
						break;
					}
				}
				if( !touch ) {
					return;
				}
				showCallout( _data.title );
				if( touch.phase == TouchPhase.ENDED ) {
					touch.getLocation( this, HELPER_POINT );
					ScrollRectManager.adjustTouchLocation( HELPER_POINT, this );
					if( hitTest( HELPER_POINT, true ) != null && !_isSelected ) {
						isSelected = true;
					}
					_touchPointID = -1;
				}
			}
			else {
				for each( touch in touches ) {
					if( touch.phase == TouchPhase.BEGAN ) {
						_touchPointID = touch.id;
						return;
					}
				}
			}
		}

		private function showCallout( title:String ):void {

			const content:Label = new Label();
			content.text = title;
			Callout.show( content, this, Callout.DIRECTION_UP );

		}

		// ---------------------------------------------------------------------
		// IListItemRenderer implementation.
		// ---------------------------------------------------------------------

		private var _data:GalleryItemVO;
		private var _owner:List;
		private var _index:int = -1;

		public function get owner():List {
			return _owner;
		}

		public function set owner( value:List ):void {
			if( _owner && value == _owner ) return;
			if( _owner ) {
				_owner.removeEventListener( Event.SCROLL, onOwnerScroll );
			}
			_owner = value;
			if( _owner ) {
				_owner.addEventListener( Event.SCROLL, onOwnerScroll );
			}
			invalidate( INVALIDATION_FLAG_DATA );
		}

		public function get index():int {
			return _index;
		}

		public function set index( value:int ):void {
			if( _index == value ) return;
			_index = value;
			invalidate( INVALIDATION_FLAG_DATA );
		}

		public function get data():Object {
			return _data;
		}

		public function set data( value:Object ):void {
			_data = value as GalleryItemVO;
			invalidate( INVALIDATION_FLAG_DATA );
		}

		// ---------------------------------------------------------------------
		// IToggle implementation.
		// ---------------------------------------------------------------------

		private var _isSelected:Boolean;

		public function get isSelected():Boolean {
			return _isSelected;
		}

		public function set isSelected( value:Boolean ):void {
			if( value == _isSelected ) return;
			_isSelected = value;
			dispatchEventWith( Event.CHANGE );
		}
	}
}
