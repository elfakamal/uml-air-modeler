package view.newView.associations
{
	
	import flash.display.CapsStyle;
	import flash.display.JointStyle;
	import flash.display.LineScaleMode;
	import flash.geom.Point;
	
	import view.core.UmlViewDashedLine;
	import view.core.UmlViewSolidLine;
	import view.newView.UmlViewDiagram;

	/**
	 * 
	 * @author kamal
	 * 
	 */
	public class UmlViewDependency extends UmlViewAssociation
	{
		
		/**
		 * stereotype's constants
		 * 
		 */
		
		
		
		/**
		 * 
		 * @param umlParent
		 * 
		 */
		public function UmlViewDependency(umlParent:UmlViewDiagram)
		{
			super(umlParent);
			
			_isUsingFilledArrow = false;
			_areEndsAllowed		= false;
		}
		
		protected override function createLine():UmlViewSolidLine
		{
			return new UmlViewDashedLine();
		}
		
		protected override function paintFirstArrow():void
		{
			//rien
		}
		
		protected override function paintLastArrow():void
		{
			drawArrow(_lastArrow);
		}
		
	}
	
}
