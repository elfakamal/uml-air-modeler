package view.newView
{
	/**
	 * 
	 * @author kamal
	 * 
	 */
	public class UmlViewDataType extends UmlViewObject
	{
		
		/**
		 * 
		 * @param xml
		 * @param parentUID
		 * 
		 */
		public function UmlViewDataType(modelElement:IUmlModelElement, parentUID:String)
		{
			super(modelElement,  parentUID);
		}
		
		/**
		 * 
		 * 
		 */
		protected override function initStereotypeLabel():void
		{
			_stereotypeLabel.text = "<<DataType>>";
		}
		
	}
	
}
