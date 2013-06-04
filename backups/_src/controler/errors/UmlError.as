package controler.errors
{
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import mx.utils.UIDUtil;
	
	
	/**
	 * 
	 * @author kamal
	 * 
	 */
	public class UmlError implements IEventDispatcher
	{
		
		
		/**
		 * 
		 */
		public static const ERROR			:String		= "error";
		public static const WARNING			:String		= "warning";
		
		
		/**
		 * events handling
		 */
		private var _eventDispatcher		:EventDispatcher		= null;
		
		
		/**
		 * 
		 * 
		 */
		protected var _uid					:String		= "";
		protected var _description			:String		= "";
		protected var _ressourceUID			:String		= "";
		protected var _type					:String		= ERROR;
		
		
		/**
		 * 
		 * @param ressourceUID
		 * @param description
		 * @param type
		 * 
		 */
		public function UmlError(
							ressourceUID		:String, 
							description			:String	="unknown error", 
							type				:String	=ERROR)
		{
			_uid			= UIDUtil.createUID();
			
			// à vérifier ultérieurement avec UIDUtil.isUID(...) 
			// en cas d'erreur, marquer la ressource comme "Unknown"
			_ressourceUID	= ressourceUID;
			_description	= description;
			_type			= type;
		}
		
		public function get uid():String
		{
			return _uid;
		}
		
		public function get ressourceUID():String
		{
			return _ressourceUID;
		}
		public function set ressourceUID(value:String):void
		{
			_ressourceUID = value;
		}
		
		public function get description():String
		{
			return _description;
		}
		public function set description(value:String):void
		{
			_description = value;
		}
		
		public function get type():String
		{
			return _type;
		}
		public function set type(value:String):void
		{
			_type = value;
		}
		
		
		/***********************************************************************
		 ***********************************************************************
		 * events handling
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
