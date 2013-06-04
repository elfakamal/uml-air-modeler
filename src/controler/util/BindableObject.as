package controler.util
{
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;
	import mx.events.PropertyChangeEvent;
	import mx.events.PropertyChangeEventKind;
	
	use namespace flash_proxy;
	
	/**
	 * 
	 * @author kamal
	 * 
	 */
	[Bindable("propertyChange")]
	dynamic internal class BindableObject extends Proxy implements IEventDispatcher
	{

		protected var strings:Object;
		protected var eventDispatcher:EventDispatcher;
		
		public function BindableObject()
		{
			strings = {};
			eventDispatcher = new EventDispatcher(this);
		}
	
		flash_proxy override function getProperty(name:*):*
		{
			return strings[name] || name;
		}
	
		flash_proxy override function setProperty(name:*, value:*):void
		{
			var oldValue:* = strings[name];
			strings[name] = value;
			var kind:String = PropertyChangeEventKind.UPDATE;
			dispatchEvent(new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE, false, false, kind, name, oldValue, value, this));
		}

		public function hasEventListener(type:String):Boolean
		{
			return eventDispatcher.hasEventListener(type);
		}
		
		public function willTrigger(type:String):Boolean
		{
			return eventDispatcher.willTrigger(type);
		}
		
		public function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0.0, useWeakReference:Boolean=false):void
		{
			eventDispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		
		public function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void
		{
			eventDispatcher.removeEventListener(type, listener, useCapture);
		}
		
		public function dispatchEvent(event:Event):Boolean
		{
			return eventDispatcher.dispatchEvent(event);
		}
		
	}

}