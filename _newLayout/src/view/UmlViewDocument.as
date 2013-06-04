package view
{
	import controler.UmlControler;
	
	import flash.events.MouseEvent;
	
	import mx.containers.Canvas;
	import mx.events.FlexEvent;

	public class UmlViewDocument extends Canvas
	{
		
		private var _gridVerticalSpacing			:Number = 20;
		private var _gridHorizontalSpacing			:Number = 20;
		
		public function UmlViewDocument()
		{
			super();
			initListeners();
		}
		
		private function initListeners():void
		{
			addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		}
		
		private function onMouseDown(e:MouseEvent):void
		{
			if (UmlControler.getInstance().isReadyToMoveDocument())
			{
				addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
				addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
				
				this.startDrag();
			}
		}
		
		private function onMouseMove(e:MouseEvent):void
		{
			if (UmlControler.getInstance().isReadyToMoveDocument())
			{
				e.updateAfterEvent();
				invalidateProperties();
			}
		}
		
		private function onMouseUp(e:MouseEvent):void
		{
			if (UmlControler.getInstance().isReadyToMoveDocument())
			{
				this.stopDrag();
				
				removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
				removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			}
		}
		
		protected function onCreationComplete(e:FlexEvent):void
		{
			
		}
		
		/**
		 * 
		 * 
		 * 
		 */
		protected override function updateDisplayList(w:Number, h:Number):void
		{
			graphics.clear();
			
			graphics.lineStyle(0.25, 0x333333, 1, true);
			
			// draws the gradient
			drawRoundRect(0, 0, w, h, 0, [0x222222,0x222222], [1, 1], verticalGradientMatrix(0, 0, w, h), null, null);
			
			var numberVerticalLines:uint = width / _gridVerticalSpacing;
			
			for (var i:uint = 0; i < numberVerticalLines; i++)
			{
				graphics.moveTo(i * _gridVerticalSpacing, 0);
				graphics.lineTo(i * _gridVerticalSpacing, height);
			}
			
			graphics.lineStyle(.25, 0x333333, 1, true);
			var numberHorizontalLines:uint = height / _gridHorizontalSpacing;
			
			for (i = 0; i < numberHorizontalLines; i++)
			{
				graphics.moveTo(0, i * _gridHorizontalSpacing);
				graphics.lineTo(width, i * _gridHorizontalSpacing);
			}
			
		}
		
	}
	
}
