package controler.serialization.model
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.xml.XMLNode;
	
	internal class XmiInfoItems implements IEventDispatcher
	{
		
		/**
		 * events handling
		 */
		private var _eventDispatcher		:EventDispatcher		= null;
		
		/**
		 * 
		 * 
		 */
		public function XmiInfoItems()
		{
			_eventDispatcher = new EventDispatcher(this);
		}
		
		/***********************************************************************
		 ***********************************************************************
		 * events handling
		 * 
		 * 
		 * 
		 * a decorated method brought from the IEventDispatcher, and that binds 
		 * the real addEventListener in the EventDispatcher class.
		 * 
		 * @param type
		 * @param listener
		 * @param useCapture
		 * @param priority
		 * @param useWeakReference
		 * 
		 */
		public function addEventListener(
			type				:String, 
			listener			:Function, 
			useCapture			:Boolean	= false, 
			priority			:int		= 0, 
			useWeakReference	:Boolean	= false):void
		{
			_eventDispatcher.addEventListener
				(type, listener, useCapture, priority, useWeakReference);
		}
		
		/**
		 * 
		 * a decorated method brought from the IEventDispatcher, and that binds 
		 * the real addEventListener in the EventDispatcher class.
		 * 
		 * @param type
		 * @param listener
		 * @param useCapture
		 * 
		 */
		public function removeEventListener(
			type			:String, 
			listener		:Function, 
			useCapture		:Boolean=false):void
		{
			_eventDispatcher.removeEventListener(type, listener, useCapture);
		}
		
		/**
		 * 
		 * a decorated method brought from the IEventDispatcher, and that binds 
		 * the real addEventListener in the EventDispatcher class.
		 * 
		 * @param event
		 * @return 
		 * 
		 */
		public function dispatchEvent(event:Event):Boolean
		{
			return _eventDispatcher.dispatchEvent(event);
		}
		
		/**
		 * 
		 * a decorated method brought from the IEventDispatcher, and that binds 
		 * the real addEventListener in the EventDispatcher class.
		 * 
		 * @param type
		 * @return 
		 * 
		 */
		public function hasEventListener(type:String):Boolean
		{
			return _eventDispatcher.hasEventListener(type);
		}
		
		/**
		 * 
		 * a decorated method brought from the IEventDispatcher, and that binds 
		 * the real addEventListener in the EventDispatcher class.
		 * 
		 * @param type
		 * @return 
		 * 
		 */
		public function willTrigger(type:String):Boolean
		{
			return _eventDispatcher.willTrigger(type);
		}
		
	}
	
}
