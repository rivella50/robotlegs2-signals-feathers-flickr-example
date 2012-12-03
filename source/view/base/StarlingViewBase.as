package view.base
{

	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.ResizeEvent;

	public class StarlingViewBase extends Sprite
	{
		public function StarlingViewBase() {

			super();

			addEventListener( Event.ADDED_TO_STAGE, onAddedToStage );
		}

		private function onAddedToStage( event:Event ):void {

			removeEventListener( Event.ADDED_TO_STAGE, onAddedToStage );

			stage.addEventListener( ResizeEvent.RESIZE, onStageResize );

			onSetup();

		}

		private function onStageResize( event:ResizeEvent ):void {

			onLayout();

		}

		protected function onLayout():void {

			// Override.

		}

		protected function onSetup():void {

			// Override.

		}
	}
}
