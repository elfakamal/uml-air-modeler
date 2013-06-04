package view
{
	import controler.UmlControler;
	
	import flash.events.MouseEvent;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.GlowFilter;
	
	import mx.core.WindowedApplication;
	import mx.events.FlexEvent;

	public class LayoutWindowedApplication extends WindowedApplication
	{
		
		private var _workspace			:UmlProjectWorkspace		= null;
		
		/**
		 * 
		 * 
		 * 
		 */
		public function LayoutWindowedApplication()
		{
			super();
			
			_workspace		= new UmlProjectWorkspace();
			
			initListeners();
		}
		
		/**
		 * 
		 * 
		 */
		private function initListeners():void
		{
			addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		}
		
		/**
		 * 
		 * 
		 */
		private function onMouseDown(e:MouseEvent):void
		{
			UmlControler.getInstance().listenToKeyBoard();
		}
		
		/**
		 * 
		 * 
		 * 
		 */
		private function onCreationComplete(e:FlexEvent):void
		{
			this.maximize();
			this.showStatusBar = false;
			
			setStyle("backgroundColor", "#222222");
			filters = [new GlowFilter(0x000000, 1, 6, 6, 2, BitmapFilterQuality.HIGH, true)];
			
			addChild(_workspace);
		}
		
		public function getProjectWorkspace():UmlProjectWorkspace
		{
			return _workspace;
		}
		
	}
	
}
