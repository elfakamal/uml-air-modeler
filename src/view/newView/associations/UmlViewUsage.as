package view.newView.associations
{
	import view.core.UmlViewDashedLine;
	import view.core.UmlViewSolidLine;
	import view.newView.UmlViewDiagram;

	/**
	 * 
	 * @author kamal
	 * 
	 */
	public class UmlViewUsage extends UmlViewDependency
	{
		
		/**
		 * 
		 * @param umlParent
		 * 
		 */
		public function UmlViewUsage(umlParent:UmlViewDiagram)
		{
			super(umlParent);
			
			_isUsingFilledArrow = false;
		}
		
		protected override function createLine():UmlViewSolidLine
		{
			return new UmlViewDashedLine();
		}
		
	}
	
}
