package view
{
	
	import mx.containers.Canvas;
	import mx.core.ScrollPolicy;
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	
	public class UmlProjectWorkspace extends Canvas
	{
		
		/**
		 * 
		 */
		private var _document				:UmlViewDocument			= null;
		
		/**
		 * 
		 */
		private var _viewToolBar			:UmlViewToolBar				= null;
		
		/**
		 * 
		 * 
		 */
		private var _menuBar				:UIComponent				= null;
		
		/**
		 * 
		 */
		private var _isInitialized			:Boolean					= false;
		
		/**
		 * 
		 */
		public function UmlProjectWorkspace()
		{
			super();
			
			initListeners();
		}
		
		protected function initListeners():void
		{
			addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
		}
		
		/**
		 * 
		 * 
		 */
		protected function initWorkspaceViews():void
		{
			percentHeight				= 100;
			percentWidth				= 100;
			
			_document					= new UmlViewDocument();
			addChild(_document);
			
			_document.percentWidth		= 150;
			_document.percentHeight		= 150;
			
			initToolBar();
		}
		
		/**
		 * 
		 * 
		 */
		protected function initToolBar():void
		{
			_viewToolBar		= new UmlViewToolBar();
			
			_viewToolBar.addTool(new UmlViewToolItem("class"));
			_viewToolBar.addTool(new UmlViewToolItem("interface"));
			_viewToolBar.addTool(new UmlViewToolItem("association"));
			_viewToolBar.addTool(new UmlViewToolItem("asso-Class"));
			_viewToolBar.addTool(new UmlViewToolItem("package"));
			_viewToolBar.addTool(new UmlViewToolItem("Enumeration"));
			_viewToolBar.addTool(new UmlViewToolItem("data-type"));
			
			addChild(_viewToolBar);
		}
		
		/**
		 * 
		 * 
		 */
		protected function onCreationComplete(e:FlexEvent):void
		{
			_viewToolBar.move(0, this.height - UmlViewToolBar.TOOL_BAR_HEIGHT);
		}
		
		/**
		 * 
		 * 
		 */
		protected override function createChildren():void
		{
			super.createChildren();
			
			initWorkspaceViews();
		}
		
		protected override function childrenCreated():void
		{
			super.childrenCreated();
			
			//_document.move(this.width/2 - _document.width/2, this.height/2 - _document.height/2);
			_viewToolBar.move(0, this.height - UmlViewToolBar.TOOL_BAR_HEIGHT);
			
			horizontalScrollPolicy		= ScrollPolicy.OFF;
			verticalScrollPolicy		= ScrollPolicy.OFF;
		}
		
		/**
		 * 
		 * 
		 */
		protected override function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			_viewToolBar.setActualSize(this.width, _viewToolBar.height);
			//_viewToolBar.move(0, this.height - UmlViewToolBar.TOOL_BAR_HEIGHT);
		}
		
	}
	
}
