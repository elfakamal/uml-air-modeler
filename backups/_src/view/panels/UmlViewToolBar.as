package view.panels
{
	import controler.UmlControler;
	import controler.UmlViewControler;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.containers.ApplicationControlBar;
	import mx.controls.Button;

	public class UmlViewToolBar extends ApplicationControlBar
	{
		
		public function UmlViewToolBar()
		{
			super();
			
			initListeners();
			initObjects();
		}
		
		private function initListeners():void
		{
			
		}
		
		private function initObjects():void
		{
			// init buttons 
			var createProject:Button = new Button();
			createProject.label = "créer projet";
			createProject.addEventListener(MouseEvent.CLICK, onCreateProjectClick);
			
			var createDiagram:Button = new Button();
			createDiagram.label = "créer diagram";
			createDiagram.addEventListener(MouseEvent.CLICK, onCreateDiagramClick);
			
			var createClass:Button = new Button();
			createClass.label = "créer classe";
			createClass.addEventListener(MouseEvent.CLICK, onCreateClassClick);
			
			var createInterface:Button = new Button();
			createInterface.label = "créer interface";
			createInterface.addEventListener(MouseEvent.CLICK, onCreateInterfaceClick);
			
			var createAssociation:Button = new Button();
			createAssociation.label = "créer association";
			createAssociation.addEventListener(MouseEvent.CLICK, onCreateAssociationClick);
			
			addChild(createProject)
			addChild(createDiagram);
			addChild(createClass);
			addChild(createInterface);
			addChild(createAssociation);
		}
		
		private function onCreateProjectClick(e:MouseEvent):void
		{
			UmlControler.getInstance().addProjet("project 1", "c:\\users\\kamal\\travaux\\flex\\_umlalakon\\");
		}
		
		private function onCreateDiagramClick(e:MouseEvent):void
		{
			UmlControler.getInstance().addDiagram("diagram 1");
		}
		
		private function onCreateClassClick(e:MouseEvent):void
		{
			UmlViewControler.getInstance().showClassForm();
		}
		
		private function onCreateInterfaceClick(e:MouseEvent):void
		{
			UmlViewControler.getInstance().showInterfaceForm();
		}
		
		private function onCreateAssociationClick(e:MouseEvent):void
		{
			// detected by the UmlViewDiagram
			UmlControler.getInstance().dispatchEvent(new Event("association"));
		}
		
	}
	
}
