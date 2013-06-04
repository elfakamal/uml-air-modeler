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
	public class UmlViewImplementation extends UmlViewDependency
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
