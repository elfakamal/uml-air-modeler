package view.newView.associations
{
	import view.newView.UmlViewDiagram;

	/**
	 * 
	 * @author kamal
	 * 
	 */
	public class UmlViewCompostion extends UmlViewAggregation
	{
		
		/**
		 * 
		 * @param umlParent
		 * 
		 */
		public function UmlViewCompostion(umlParent:UmlViewDiagram)
		{
			super(umlParent);
			
			_firstArrowColor = 0xDDDDDD;
		}
		
	}
	
}
