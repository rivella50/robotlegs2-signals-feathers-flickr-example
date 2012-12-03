package view.base
{

	import feathers.core.DisplayListWatcher;
	import feathers.themes.MetalWorksMobileTheme;

	import view.imageview.ImageView;

	import view.thumbsview.ThumbsView;

	public class StarlingRootSprite extends StarlingViewBase
	{
		protected var _feathersTheme:DisplayListWatcher;

		public function StarlingRootSprite() {

			super();

		}

		override protected function onSetup():void {

			// Define application UI theme.
			_feathersTheme = new MetalWorksMobileTheme( stage );

			// Add child views.
			addChild( new ImageView() );
			addChild( new ThumbsView() );

		}
	}
}
