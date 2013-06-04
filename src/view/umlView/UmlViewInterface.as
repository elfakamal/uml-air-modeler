package view.umlView
{
	import model.IUmlModelElement;
	
	import mx.events.FlexEvent;
	
	public class UmlViewInterface extends UmlViewClass
	{
		
		public function UmlViewInterface(modelElement:IUmlModelElement, parentUID:String)
		{
			super(modelElement,  parentUID);
			
			_title.setText("<<I>> " + name);
		}
		
		protected override function onCreationComplete(e:FlexEvent):void
		{
			super.onCreationComplete(e);
			
		}
		
		protected override function initListeners():void
		{
			super.initListeners();
		}
		
	}
	
}