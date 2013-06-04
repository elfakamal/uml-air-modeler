package view.newView
{
	import model.IUmlModelElement;
	
	import mx.events.FlexEvent;
	
	public class UmlViewEnumerationLiteral extends UmlViewField
	{
		
		
		
		/**
		 * 
		 * @param xml
		 * @param parentUID
		 * 
		 */
		public function UmlViewEnumerationLiteral(modelElement:IUmlModelElement, parentUID:String)
		{
			super(modelElement,  parentUID);
		}
		
		/*******************************************************************************************
		 * 
		 * overriden functions 
		 * 
		 ******************************************************************************************/
		
		/**
		 * 
		 * 
		 */		
		public override function setPrivate():void
		{
			// rien
		}
		public override function setProtected():void
		{
			// rien
		}
		public override function setPackage():void
		{
			// rien
		}
		
		/*******************************************************************************************
		 * 
		 * overriden callback functions 
		 * 
		 ******************************************************************************************/
		
		protected override function onCreationComplete(e:FlexEvent):void
		{
			super.onCreationComplete(e);
			setPublic();
		}
		
	}
	
}
