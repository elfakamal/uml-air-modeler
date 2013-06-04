package view
{
	import flash.events.IEventDispatcher;
	
	import model.IUmlModelElement;
	
	/**
	 * 
	 * @author kamal
	 * 
	 */
	public interface IUmlViewElement extends IEventDispatcher
	{
		
		function get modelElement():IUmlModelElement;
		
		/**
		 * this function adds a view element to this element, 
		 * it is the final step of adding a model element to the global model.
		 * 
		 * @param viewElement
		 * @return 
		 * 
		 */
		function addElement(viewElement:IUmlViewElement):IUmlViewElement;
		
		/**
		 * this function removes a view element from this element, 
		 * it is the final step of removing a model element 
		 * from the global model.
		 * 
		 * @param viewElement
		 * @return 
		 * 
		 */
		function removeElement(viewElement:IUmlViewElement):IUmlViewElement;
		
		/**
		 * 
		 * @return 
		 * 
		 */
		function getParentId():String;
		
		/**
		 * 
		 * @return 
		 * 
		 */
		function get uid():String;
		
		/**
		 * 
		 * 
		 */
		function hideSelectionColor():void;
		
		/**
		 * 
		 * @param selected
		 * 
		 */
		function setSelected(selected:Boolean):void;
		function isSelected():Boolean;
		
		
		function getContextMenuItems():Array;
		
		function dispose():void;
		
	}
	
}
