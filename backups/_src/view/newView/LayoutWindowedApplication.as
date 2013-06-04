package view.newView
{
	import controler.UmlControler;
	import controler.events.UmlEvent;
	
	import flash.events.MouseEvent;
	
	import model.IUmlModelElement;
	import model.UmlModel;
	import model.UmlModelProject;
	
	import mx.core.WindowedApplication;
	import mx.events.FlexEvent;
	
	
	public class LayoutWindowedApplication extends WindowedApplication
	{
		
		protected var _projects:Array = null;
		private var _selectedProjectWorkspace:UmlViewProjectWorkspace = null;
		
		/**
		 * 
		 * 
		 * 
		 */
		public function LayoutWindowedApplication()
		{
			super();
			
			_projects = new Array();
			
			initListeners();
			UmlControler.getInstance().startUpApplication();
		}
		
		/**
		 * 
		 * 
		 */
		private function initListeners():void
		{
			// dispatched by the model
			UmlModel.getInstance().addEventListener(UmlEvent.ELEMENT_ADDED, onElementAdded);
			
			addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		}
		
		/**
		 * 
		 * @param e
		 * 
		 */
		protected function onElementAdded(e:UmlEvent):void
		{
			if (e.getAddedElement() is UmlModelProject)
			{
				var modelProject:IUmlModelElement = e.getAddedElement();
				_projects.push(modelProject);
				
				var addedProject:UmlViewProjectWorkspace = new UmlViewProjectWorkspace(modelProject);
				addChild(addedProject);
				_selectedProjectWorkspace = addedProject;
			}
			
			UmlModel.getInstance().removeEventListener(UmlEvent.ELEMENT_ADDED, onElementAdded);
			
			//UmlSelectionControler.getInstance().selectNode(addedProject);
		}
		
		private function onMouseDown(e:MouseEvent):void
		{
			//UmlLayoutControler.getInstance().listenToKeyBoard();
		}
		
		private function onCreationComplete(e:FlexEvent):void
		{
			this.maximize();
			this.showStatusBar = false;
			
			UmlControler.getInstance().addProjet("projet 1", "/home/dezolo/");
			
		}
		
		public function getSelectedProjectWorkspace():UmlViewProjectWorkspace
		{
			return _selectedProjectWorkspace;
		}
		
	}
	
}
