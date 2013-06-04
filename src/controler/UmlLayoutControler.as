package controler
{
	import com.greensock.TweenMax;
	
	import flash.events.EventDispatcher;
	import flash.events.KeyboardEvent;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.GlowFilter;
	import flash.ui.Keyboard;
	
	import mx.core.Application;
	import mx.events.FlexNativeWindowBoundsEvent;
	import mx.events.ResizeEvent;
	
	import view.newView.UmlViewProjectWorkspace;
	
	
	
	public class UmlLayoutControler extends EventDispatcher
	{
		
		private static var _instance				:UmlLayoutControler	= null;
		
		protected static var _tweenMaxInstance		:TweenMax			= null;
		
		/**
		 * 
		 * 
		 */
		private var _isReadyToMoveDocument			:Boolean			= false;
		
		private var _toolBarGlowFilter				:GlowFilter			= null;
		
		private var _isTweenMaxTweening				:Boolean			= false;
		
		
		
		/**
		 * 
		 * @param lock
		 * 
		 */
		public function UmlLayoutControler(lock:Lock)
		{
			_toolBarGlowFilter = new GlowFilter(0xFFFFFF, 1, 6, 6, 2, BitmapFilterQuality.HIGH);
			//setAnimationQualityToHigh();
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public static function getInstance():UmlLayoutControler
		{
			if(_instance)
			{
				return _instance;
			}
			else
			{
				_instance = new UmlLayoutControler(new Lock());
				return _instance;
			}
		}
		
		/**
		 * 
		 * 
		 */
		public function setAnimationQualityToHigh():void
		{
			Application.application.frameRate = 60;
		}
		
		/**
		 * 
		 * @param target
		 * @param duration
		 * @param vars
		 * @param delay
		 * @param ease
		 * @return 
		 * 
		 */
		public static function getTweenMaxInstance(
											target		:Object, 
											duration	:Number, 
											vars		:Object, 
											delay		:uint		= 0, 
											ease		:Function	= null
											):TweenMax
		{
			if (!_tweenMaxInstance)
			{
				_tweenMaxInstance = new TweenMax(target, duration, vars);
				if (delay > 0)
				{
					_tweenMaxInstance.delay		= delay;
				}
				if (ease != null)
				{
					//_tweenMaxInstance.ease		= ease;
				}
			}
			else
			{
				_tweenMaxInstance.target		= target;
				_tweenMaxInstance.duration		= duration;
				_tweenMaxInstance.vars			= vars;
				if (delay > 0)
				{
					_tweenMaxInstance.delay			= delay;
				}
				if (ease != null)
				{
					//_tweenMaxInstance.ease			= ease;
				}
			}
			
			return _tweenMaxInstance;
		}
		
		/**
		 * 
		 * 
		 */
		public function listenToKeyBoard():void
		{
			//Application.application.setFocus();
			Application.application.addEventListener(KeyboardEvent.KEY_DOWN, onApplicationKeyDown);
			//Application.application.addEventListener(KeyboardEvent.KEY_UP, onApplicationKeyUp);
		}
		
		/**
		 * 
		 * 
		 */
		public function addNativeResizeEventListenerZZ(callBack:Function):void
		{
			Application.application.addEventListener(ResizeEvent.RESIZE, callBack);
		}
		
		/**
		 * 
		 * 
		 */
		public function addNativeResizeEventListener(callBack:Function):void
		{
			Application.application.addEventListener(FlexNativeWindowBoundsEvent.WINDOW_RESIZE, callBack);
		}
		
		/**
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
		
		/**
		 * 
		 * @param isReady
		 * 
		 */
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
		public function getSelectedWorkspace():UmlViewProjectWorkspace
		{
			return Application.application.getProjectWorkspace();
		}
		
		public function setTweenMaxTweening(value:Boolean):void
		{
			_isTweenMaxTweening = value;
		}
		public function isTweenMaxTweening():Boolean
		{
			return _isTweenMaxTweening;
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
