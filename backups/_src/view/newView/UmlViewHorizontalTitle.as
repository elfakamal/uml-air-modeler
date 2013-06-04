package view.newView
{
	import flash.display.CapsStyle;
	import flash.display.JointStyle;
	import flash.display.LineScaleMode;
	import flash.geom.Point;
	
	import mx.containers.HBox;
	
	public class UmlViewHorizontalTitle extends UmlViewTitle
	{
		
		/**
		 * 
		 * 
		 */
		
		
		/**
		 * 
		 * @param text
		 * @param iconUrl
		 * 
		 */
		public function UmlViewHorizontalTitle(text:String="Untitled", iconUrl:String="")
		{
			super(text, iconUrl);
		}
		
		//--------------------------
		// overriden functions
		//--------------------------
		
		protected override function initHolder():void
		{
			_holder = new HBox();
		}
		
		protected override function measure():void
		{
			super.measure();
			
			percentWidth			= 100;
			measuredHeight			= measuredMinHeight = TITLE_HEIGHT;
		}
		
		/**
		 * 
		 * 
		 */
		protected override function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			_holder.width			= width;
			_holder.height			= TITLE_HEIGHT;
			
			initMask(unscaledWidth, unscaledHeight);
		}
		
		/**
		 * 
		 * 
		 */
		protected override function paintBackground():void
		{
			super.paintBackground();
			
			_backgound.graphics.lineStyle(.25, _backgroundLineColor, 1);
			var numberVerticalLines:uint = width / _backgroundGridSpacing + 5;
			
			var topPoint:Point = new Point();
			var bottomPoint:Point = new Point(-20, height);
			
			for (var i:uint = 0; i < numberVerticalLines; i++)
			{
				topPoint.x			+= _backgroundGridSpacing;
				bottomPoint.x		+= _backgroundGridSpacing;
				
				_backgound.graphics.moveTo(topPoint.x, 0);
				_backgound.graphics.lineTo(bottomPoint.x, height);
			}
			
			_backgound.graphics.lineStyle(1, _backgroundLineColor, .8);
			_backgound.graphics.drawRect(0, 0, width, height);
			
			/*
			*	dessin du triangle à coté du label, comme une icône
			*/
			var coordinateSystem:Point = new Point(5, 5);
			_triangle.graphics.lineStyle(_triangleLineTickness, _triangleLineColor, 1, false, LineScaleMode.NORMAL, CapsStyle.ROUND, JointStyle.MITER);
			
			_triangle.graphics.beginFill(_triangleLineColor, .1);
			
//			_triangle.graphics.moveTo(coordinateSystem.x, coordinateSystem.y);
//			_triangle.graphics.lineTo(coordinateSystem.x, coordinateSystem.y + 10);
//			
//			_triangle.graphics.moveTo(coordinateSystem.x, coordinateSystem.y + 10);
			_triangle.graphics.moveTo(coordinateSystem.x + 10, coordinateSystem.y + 5);
			
			_triangle.graphics.lineTo(coordinateSystem.x, coordinateSystem.y);
			_triangle.graphics.lineTo(coordinateSystem.x, coordinateSystem.y + 10);
			
			_triangle.graphics.endFill();
			
			_triangle.filters = [_triangleFilter];
		}
		
	}
	
}
