package view
{
	import controler.UmlControler;
	
	import mx.core.WindowedApplication;
	import mx.events.FlexEvent;
	import mx.events.ResizeEvent;
	


	public class UmlWindowedApplication extends WindowedApplication
	{
		
		/**
		 * 
		 * 
		 */
//		protected var _diagramWorkspace			:UmlViewWorkspace2			= null;
		
		/**
		 * 
		 * 
		 */
		protected var _isLayoutDirty			:Boolean					= false;
		
		/**
		 * 
		 * 
		 */
		public function UmlWindowedApplication()
		{
			super();
			
			initListeners();
			startUp();
		}
		
		protected override function createChildren():void
		{
			super.createChildren();
			
//			_diagramWorkspace = new UmlViewWorkspace2();
//			addChild(_diagramWorkspace);
		}
		
		protected override function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			if (_isLayoutDirty)
			{
				
			}
		}
		
		private function initListeners():void
		{
			addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			addEventListener(ResizeEvent.RESIZE, onWindowResize);
		}
		
		private function startUp():void
		{
			UmlControler.getInstance().startUpApplication();
			initObjects();
		}
		
		private function initObjects():void
		{
			
		}
		
		protected function onWindowResize(e:ResizeEvent):void
		{
			_isLayoutDirty = true;
			invalidateDisplayList();
		}
		
		private function onCreationComplete(event:FlexEvent):void
		{
			maximize();
		}
	}
}