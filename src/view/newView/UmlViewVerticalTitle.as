package view.newView
{
	import flash.display.CapsStyle;
	import flash.display.JointStyle;
	import flash.display.LineScaleMode;
	import flash.geom.Point;
	
	import mx.containers.VBox;
	
	public class UmlViewVerticalTitle extends UmlViewTitle
	{
		
		public static const TITLE_WIDTH				:Number			= 20;
		
		
		public function UmlViewVerticalTitle(text:String, iconUrl:String="")
		{
			super(text, iconUrl);
		}
		
		//--------------------------
		// overriden functions
		//--------------------------
		
		protected override function measure():void
		{
			super.measure();
			
			measuredHeight			= measuredMinHeight		= 400;
			measuredWidth			= measuredMinWidth		= TITLE_WIDTH;
		}
		
		/**
		 * 
		 * 
		 */
		protected override function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			_holder.width			= TITLE_WIDTH;
			_holder.height			= unscaledHeight;
			
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
			
			var rightPoint:Point = new Point(width, -20);
			var leftPoint:Point = new Point();
			
			for (var i:uint = 0; i < numberVerticalLines; i++)
			{
				rightPoint.y	+= _backgroundGridSpacing;
				leftPoint.y		+= _backgroundGridSpacing;
				
				_backgound.graphics.moveTo(width, rightPoint.y);
				_backgound.graphics.lineTo(0, leftPoint.y);
			}
			
			/*
			*	dessin du triangle à coté du label, comme une icône
			*/
			var coordinateSystem:Point = new Point(5, 5);
			_triangle.graphics.lineStyle(_triangleLineTickness, _triangleLineColor, 1, false, LineScaleMode.NORMAL, CapsStyle.ROUND, JointStyle.MITER);
			
			_triangle.graphics.moveTo(coordinateSystem.x, coordinateSystem.y);
			_triangle.graphics.lineTo(coordinateSystem.x, coordinateSystem.y + 10);
			
			_triangle.graphics.lineStyle(_triangleLineTickness, _triangleLineColor, 1, false, LineScaleMode.NORMAL, CapsStyle.ROUND, JointStyle.MITER);
			_triangle.graphics.moveTo(coordinateSystem.x, coordinateSystem.y + 10);
			_triangle.graphics.lineTo(coordinateSystem.x + 10, coordinateSystem.y + 5);
			
			_triangle.graphics.lineStyle(_triangleLineTickness, _triangleLineColor, 1, false, LineScaleMode.NORMAL, CapsStyle.ROUND, JointStyle.MITER);
			_triangle.graphics.moveTo(coordinateSystem.x + 10, coordinateSystem.y + 5);
			_triangle.graphics.lineTo(coordinateSystem.x, coordinateSystem.y);
			
//			_triangle.rotation = -90;
			
			_triangle.filters = [_triangleFilter];
		}
		
		protected override function initHolder():void
		{
			_holder = new VBox();
		}
		
	}
	
}
