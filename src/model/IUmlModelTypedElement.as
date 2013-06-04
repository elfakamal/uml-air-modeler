package model
{
	
	/**
	 * A typed element is an element that has a type that serves as a 
	 * constraint on the range of values the element can represent.
	 * 
	 * @author kamal
	 * 
	 */
	public interface IUmlModelTypedElement extends IUmlModelNamedElement
	{
		
		/**
		 * The type of the TypedElement.
		 */
		function set type(value:IUmlModelType):void;
		function get type():IUmlModelType;
		
	}
	
}
