package view.newView.associations
{
	import flash.display.CapsStyle;
	import flash.display.JointStyle;
	import flash.display.LineScaleMode;
	import flash.geom.Point;
	
	import view.core.UmlViewSolidLine;
	import view.newView.UmlViewDiagram;

	/**
	 * 
	 * @author kamal
	 * 
	 */
	public class UmlViewAggregation extends UmlViewAssociation
	{
		
		protected var _firstArrowColor		:uint		= 0x222222;
		protected var _firstArrowAlpha		:Number		= 1;
		
		/**
		 * 
		 * @param umlParent
		 * 
		 */
		public function UmlViewAggregation(umlParent:UmlViewDiagram)
		{
			super(umlParent);
			_isUsingFilledArrow = false;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		protected override function createLine():UmlViewSolidLine
		{
			return new UmlViewSolidLine();
		}
		
		/**
		 * 
		 * 
		 */
		protected override function paintFirstArrow():void
		{
			var coordinateSystem:Point = new Point(0, 0);
			with (_firstArrow.graphics)
			{
				clear();
				
				beginFill(_firstArrowColor, _firstArrowAlpha);
				moveTo(0, 0);
				lineTo(-ARROW_SIZE, -ARROW_SIZE / 2);
				lineTo(-ARROW_SIZE, ARROW_SIZE / 2);
				
				moveTo(-ARROW_SIZE * 2, 0);
				lineTo(-ARROW_SIZE, -ARROW_SIZE / 2);
				lineTo(-ARROW_SIZE, ARROW_SIZE / 2);
				endFill();
				
				lineStyle(0.1, 0xFFFFFF, 1, false, LineScaleMode.NORMAL, CapsStyle.ROUND, JointStyle.ROUND);
				
				moveTo(0, 0);
				lineTo(-ARROW_SIZE, -ARROW_SIZE / 2);
				
				moveTo(-ARROW_SIZE, -ARROW_SIZE / 2);
				lineTo(-ARROW_SIZE * 2, 0);
				
				moveTo(-ARROW_SIZE * 2, 0);
				lineTo(-ARROW_SIZE, ARROW_SIZE / 2);
				
				moveTo(-ARROW_SIZE, ARROW_SIZE / 2);
				lineTo(0, 0);
				
			}
		}
		
	}
	
}
