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
	public class UmlViewImplementation extends UmlViewAssociation
	{
		
		/**
		 * 
		 * @param umlParent
		 * 
		 */
		public function UmlViewImplementation(umlParent:UmlViewDiagram)
		{
			super(umlParent);
			
			_isUsingFilledArrow = true;
		}
		
		protected override function createLine():UmlViewSolidLine
		{
			return new UmlViewDashedLine();
		}
		
	}
	
}
