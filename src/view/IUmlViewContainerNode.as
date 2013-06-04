package view
{
	import mx.core.UIComponent;
	
	public interface IUmlViewContainerNode
	{
		
		/**
		 * 
		 * @param p_width
		 * @param p_height
		 * 
		 */
		function layoutChildren(p_width:Number, p_height:Number):void;
		
	}
	
}