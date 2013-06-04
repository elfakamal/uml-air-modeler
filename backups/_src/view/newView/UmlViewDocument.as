package view.newView
{
	import controler.UmlLayoutControler;
	
	import flash.display.CapsStyle;
	import flash.display.JointStyle;
	import flash.display.LineScaleMode;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.BitmapFilterType;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import flash.filters.GradientGlowFilter;
	import flash.geom.Point;
	
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
			if (UmlLayoutControler.getInstance().isReadyToMoveDocument())
			{
				addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
				addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
				
				this.startDrag();
			}
		}
		
		private function onMouseMove(e:MouseEvent):void
		{
			if (UmlLayoutControler.getInstance().isReadyToMoveDocument())
			{
				e.updateAfterEvent();
				invalidateProperties();
			}
		}
		
		private function onMouseUp(e:MouseEvent):void
		{
			if (UmlLayoutControler.getInstance().isReadyToMoveDocument())
			{
				this.stopDrag();
				
				removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
				removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			}
		}
		
		protected function onCreationComplete(e:FlexEvent):void
		{
			// Define a gradient glow. 
			var gradientGlow:GradientGlowFilter = new GradientGlowFilter();
			gradientGlow.distance = 0;
			gradientGlow.angle = 45;
			gradientGlow.colors = [0x000000, 0x000000];
			gradientGlow.alphas = [1, 0];
			gradientGlow.ratios = [0, 255];
			gradientGlow.blurX = 10;
			gradientGlow.blurY = 10;
			gradientGlow.strength = 1;
			gradientGlow.quality = BitmapFilterQuality.HIGH;
			gradientGlow.type = BitmapFilterType.INNER;
			
			var dropShadow:DropShadowFilter = new DropShadowFilter(5, 45, 0x000000, 1, 4, 4, 1, 10);
			filters = [gradientGlow, dropShadow];
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
