package model
{
	
	import controler.events.UmlEvent;
	
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	/**
	 * 
	 * @author kamal
	 * 
	 */
	internal class	UmlModelElement 
		implements	IUmlModelElement
	{
		
		/**
		 * events handling
		 */
		private var _eventDispatcher		:EventDispatcher		= null;
		
		/**
		 * $(FlexSDK)\bin\adl.exe;application.xml bin
		 * 
		 * business members
		 */
		protected var _uid					:String					= "";
		protected var _owner				:IUmlModelElement		= null;
		protected var _ownedComments		:Array					= null;
		protected var _selectedNodes		:Array					= null;
		
		protected var _xml					:XML					= null;
		protected var _xmi					:XML					= null;
		
		/**
		 * 
		 */
		public function UmlModelElement(uid:String)
		{
			super();
			
			_uid				= uid;
			
			_ownedComments		= new Array();
			_selectedNodes		= new Array();
			
			_eventDispatcher	= new EventDispatcher(this);
		}
		
		/**
		 * must be overriden
		 */
		public function addElement(umlElement:IUmlModelElement):void
		{
			throw new IllegalOperationError("this is abstract method : " + 
											"must be called in subclass");
		}
		
		public function edit(newElement:IUmlModelElement):void
		{
			throw new IllegalOperationError("this is abstract method : " + 
											"must be called in subclass");
		}
		
		/**
		 * /!\
		 * do NOT override this function.
		 */
		public function removeElement(element:IUmlModelElement):void
		{
			throw new IllegalOperationError("this is abstract method : " + 
											"must be called in subclass");
			
			//if (_ownedElements)
			//{
				//if (element != null && _ownedElements.indexOf(element) >= 0)
				//{
					//delete _ownedElements.splice(_ownedElements.indexOf(element), 1);
					//
					//var event:UmlEvent = new UmlEvent(UmlEvent.NODE_DELETED);
					//event.setDeletedNode(element.xml);
					//UmlModel.getInstance().dispatchEvent(event);
				//}
			//}
		}
		
		/**
		 * 
		 * @param comment
		 * 
		 */
		public function addComment(comment:UmlModelComment):void
		{
			if (comment != null)
			{
				ownedComments.push(comment);
				
				comment.owner = this;
				
				var event:UmlEvent = new UmlEvent(UmlEvent.COMMENT_ADDED);
				event.setAddedElement(comment);
				dispatchEvent(event);
			}
		}
		
		public function removeComment(comment:UmlModelComment):void
		{
			if (_ownedComments != null)
			{
				if (comment != null && _ownedComments.indexOf(comment) >= 0)
				{
					delete _ownedComments.splice(_ownedComments.indexOf(comment), 1);
					
					var event:UmlEvent = new UmlEvent(UmlEvent.ELEMENT_DELETED);
					event.setDeletedNode(comment);
					UmlModel.getInstance().dispatchEvent(event);
				}
			}
		}
		
		public function mustBeOwned():Boolean
		{
			return true;
		}
		
		public function contains(element:IUmlModelElement):Boolean
		{
			return ownedElements.indexOf(element) >= 0;
		}
		
		public function get xml():XML
		{
			return _xml;
		}
		
		public function get xmi():XML
		{
			return _xmi;
		}
		
		public function set uid(value:String):void
		{
			_uid = value;
		}
		public function get uid():String
		{
			return _uid;
		}
		
		public final function set owner(value:IUmlModelElement):void
		{
			var eventType:String = "";
			
			if (_owner == value)
			{
				return;
			}
			
			if (_owner == null && value != null)
			{
				eventType = UmlEvent.ADDED;
			}
			else if (_owner != null && value != null)
			{
				eventType = UmlEvent.MOVED;
			}
			else if (_owner != null && value == null)
			{
				eventType = UmlEvent.DELETED;
			}
			
			_owner = value;
			
			var event:UmlEvent = new UmlEvent(eventType);
			dispatchEvent(event);
		}
		public function get owner():IUmlModelElement
		{
			return _owner;
		}
		
		public function get ownedElements():Array
		{
			var elements:Array = [];
			
			if (ownedComments != null)
			{
				elements = elements.concat(ownedComments);
			}
			
			return elements;
		}
		
		public function get ownedComments():Array
		{
			return _ownedComments;
		}
		public function set ownedComments(value:Array):void
		{
			_ownedComments = value;
		}
		
		public function getAllOwnedElements():Array
		{
			// TODO : recursive search in the children, to return an array 
			//containing all the tree elements.
			return ownedElements;
		}
		
		public function get selectedNodes():Array
		{
			return _selectedNodes;
		}
		
		public function get selectedNode():IUmlModelElement
		{
			return null;
		}
		
		/**
		 * cette fonction est à redéfinir dans une classe fille.
		 */
		public function set selectedNode(element:IUmlModelElement):void
		{
			// rien 
		}
		
		public function selectNode(id:String):void
		{
			throw new IllegalOperationError("this is abstract method : " + 
											"must be called in subclass");
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
