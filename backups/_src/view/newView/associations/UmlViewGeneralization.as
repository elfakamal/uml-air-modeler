package view.newView.associations
{
	import view.core.UmlViewSolidLine;
	import view.newView.UmlViewDiagram;
	
	/**
	 * 
	 * @author kamal
	 * 
	 */
	public class UmlViewGeneralization extends UmlViewAssociation
	{
		
		/**
		 * 
		 * @param umlParent
		 * 
		 */
		public function UmlViewGeneralization(umlParent:UmlViewDiagram)
		{
			super(umlParent);
			_isUsingFilledArrow = true;
		}
		
		protected override function createLine():UmlViewSolidLine
		{
			return new UmlViewSolidLine();
		}
		
	}
	
}
