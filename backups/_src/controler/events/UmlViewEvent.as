package controler.events
{
	import flash.events.Event;
	
	import view.newView.UmlViewElement;
	import view.newView.UmlViewToolItem;
	
	/**
	 * 
	 * @author dezolo
	 * 
	 */
	public class UmlViewEvent extends Event
	{
		
		/**
		 * 
		 */
		public static const TOOL_ITEM_START_DRAG	:String		= "toolItemStartDrag";
		public static const TOOL_ITEM_END_DRAG		:String		= "toolItemEndDrag";
		
		public static const WINDOW_CLOSED			:String		= "windowClosed";
		
		public static const ELEMENT_ADDED			:String		= "elementAdded";
		
		public static const ELEMENTS_SWAPPED		:String		= "elementsSwapped";
		
		public static const DONE					:String		= "done";
		public static const CANCEL					:String		= "cancel";
		public static const CREATED					:String		= "created";
		public static const ACTIVATED				:String		= "activated";
		public static const DEACTIVATED				:String		= "deactivated";
		
		
		/**
		 * 
		 */
		protected var _draggedToolItem			:UmlViewToolItem		= null;
		protected var _swappedElements			:Array					= null;
		protected var _addedElement				:UmlViewElement			= null;
		
		/**
		 * 
		 * @param type
		 * @param bubbles
		 * @param cancelable
		 * 
		 */
		public function UmlViewEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		public function get addedElement():UmlViewElement
		{
			return _addedElement;
		}
		public function set addedElement(value:UmlViewElement):void
		{
			_addedElement = value;
		}
		
		public function get swappedElements():Array
		{
			return _swappedElements;
		}
		public function set swappedElements(value:Array):void
		{
			_swappedElements = value;
		}

		public function getDraggedToolItem():UmlViewToolItem
		{
			return _draggedToolItem;
		}
		public function setDraggedToolItem(toolItem:UmlViewToolItem):void
		{
			_draggedToolItem = toolItem;
		}
		
		
		
	}
	
}
