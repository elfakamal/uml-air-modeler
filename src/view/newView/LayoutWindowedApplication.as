package view.newView
{
	import controler.UmlControler;
	import controler.events.UmlEvent;
	
	import flash.desktop.NativeApplication;
	import flash.events.MouseEvent;
	
	import model.IUmlModelElement;
	import model.UmlModel;
	import model.UmlModelProject;
	
	import mx.core.Application;
	import mx.core.WindowedApplication;
	import mx.events.FlexEvent;
	
	import view.panels.UmlViewCommandBar;
	
	
	public class LayoutWindowedApplication extends WindowedApplication
	{
		
		protected var _projects					:Array						= null;
		protected var _selectedProjectWorkspace	:UmlViewProjectWorkspace	= null;
		
		
		protected var _commandsBar				:UmlViewCommandBar	= null;
		
		
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
		
		protected override function initializationComplete():void
		{
			super.initializationComplete();
			
			this.maximize();
		}
		
		protected override function createChildren():void
		{
			super.createChildren();
			
			//createCommandbar();
		}
		
		protected function createCommandbar():void
		{
			_commandsBar = new UmlViewCommandBar();
			addChild(_commandsBar);
		}
		
		protected override function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			if (_commandsBar != null)
			{
				_commandsBar.x = 0;
				_commandsBar.y = 0;
			}
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
				addChildAt(addedProject, 0);
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
			
			this.showStatusBar = false;
			
			UmlControler.getInstance().addProjet("projet 1", "/home/dezolo/");
			
		}
		
		public function getSelectedProjectWorkspace():UmlViewProjectWorkspace
		{
			return _selectedProjectWorkspace;
		}
		
	}
	
}
