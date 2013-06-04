package view.newView.associations
{
	import view.core.UmlViewDashedLine;
	import view.core.UmlViewSolidLine;
	import view.newView.UmlViewDiagram;

	public class UmlViewBinding extends UmlViewAssociation
	{
		
		public function UmlViewBinding(umlParent:UmlViewDiagram)
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
