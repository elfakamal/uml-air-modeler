package model
{
	import flash.events.IEventDispatcher;
	
	import mx.core.IUID;
	
	/**
	 * 
	 * Element is an abstract metaclass with no superclass. It is used as the 
	 * common superclass for all metaclasses in the infrastructure library. 
	 * Element has a derived composition association to itself to support 
	 * the general capability for elements to own other elements.
	 * 
	 * @author kamal
	 * 
	 */
	public interface IUmlModelElement extends IUID, IEventDispatcher
	{
		
		/**
		 * The Data structure of this element.
		 */
		function get xml():XML;
		function get xmi():XML;
		
		/**
		 * The Element that owns this element.
		 */
		function set owner(value:IUmlModelElement):void;
		function get owner():IUmlModelElement;
		
		/**
		 * The Elements owned by this element.
		 */
		function get ownedElements():Array;
		function addElement(element:IUmlModelElement):void;
		//function editElement(elementUID:String, newElement:IUmlModelElement):void;
		function removeElement(element:IUmlModelElement):void;
		
		function edit(newElement:IUmlModelElement):void;
		
		
		/**
		 * gives all of the direct and indirect owned elements of an element.
		 */
		function getAllOwnedElements():Array;
		
		/**
		 * The Comments owned by this element. 
		 */
		function get ownedComments():Array;
		function addComment(comment:UmlModelComment):void;
		//function editComment(commentUID:String, newComment:UmlModelComment):void;
		function removeComment(comment:UmlModelComment):void;
		
		/**
		 * verifies whether this node contains the element in parameter.
		 */
		function contains(element:IUmlModelElement):Boolean;
		
		/**
		 * this function indicates whether elements of this type must have 
		 * an owner. Subclasses of Element that do not require an owner must 
		 * override this operation.
		 */
		function mustBeOwned():Boolean;
		
	}
	
}
