package controler
{
	import flash.events.EventDispatcher;
	import flash.events.KeyboardEvent;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.GlowFilter;
	import flash.ui.Keyboard;
	
	import mx.core.Application;
	
	import view.UmlProjectWorkspace;
	
	public class UmlControler extends EventDispatcher
	{
		
		private static var _instance				:UmlControler		= null;
		
		/**
		 * 
		 * 
		 */
		private var _isReadyToMoveDocument			:Boolean			= false;
		
		private var _toolBarGlowFilter						:GlowFilter			= null;
		
		
		public function UmlControler(lock:Lock)
		{
			_toolBarGlowFilter = new GlowFilter(0xFFFFFF, 1, 6, 6, 2, BitmapFilterQuality.HIGH);
		}
		
		public static function getInstance():UmlControler
		{
			if(_instance)
			{
				return _instance;
			}
			else
			{
				_instance = new UmlControler(new Lock());
				return _instance;
			}
		}
		
		public function listenToKeyBoard():void
		{
			Application.application.setFocus();
			Application.application.addEventListener(KeyboardEvent.KEY_DOWN, onApplicationKeyDown);
			//Application.application.addEventListener(KeyboardEvent.KEY_UP, onApplicationKeyUp);
		}
		
		/**
		 * 
		 * TODO: Repair this by creating a MainWindow class
		 * 
		 */
		private function onApplicationKeyDown(e:KeyboardEvent):void
		{
			if (e.keyCode == Keyboard.H)
			{
				setReadyToMoveDocument(true);
			}
			else if (e.keyCode == Keyboard.ESCAPE)
			{
				setReadyToMoveDocument(false);
			}
		}
		
		public function setReadyToMoveDocument(isReady:Boolean):void
		{
			_isReadyToMoveDocument = isReady;
		}
		public function isReadyToMoveDocument():Boolean
		{
			return _isReadyToMoveDocument;
		}
		
		/**
		 * 
		 * 
		 */
		public function getSelectedWorkspace():UmlProjectWorkspace
		{
			return Application.application.getProjectWorkspace();
		}
		
		public function getToolBarGlowFilter():GlowFilter
		{
			return _toolBarGlowFilter;
		}
		
	}
	
}

internal class Lock
{
	public function Lock()
	{
		
	}
}
