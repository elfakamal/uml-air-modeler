package view.newView
{
	/**
	 * 
	 * @author kamal
	 * 
	 */
	public class UmlViewArtifact extends UmlViewObject
	{
		
		/**
		 * 
		 * @param xml
		 * @param parentUID
		 * 
		 */
		public function UmlViewArtifact(modelElement:IUmlModelElement, parentUID:String)
		{
			super(modelElement,  parentUID);
		}
		
		/**
		 * 
		 * 
		 */
		protected override function initStereotypeLabel():void
		{
			_stereotypeLabel.text = "<<Artifact>>";
		}
		
	}
	
}
