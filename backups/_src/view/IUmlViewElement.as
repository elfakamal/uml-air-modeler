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
