package model
{
	/**
	 * A typed element is an element that has a type that serves as a constraint 
	 * on the range of values the element can represent. 
	 * 
	 * Typed element is an abstract metaclass.
	 * 
	 * @author kamal
	 * 
	 */
	internal class UmlModelTypedElement extends UmlModelNamedElement
	{
		
		/**
		 * The type of the TypedElement.
		 */
		protected var _type			:UmlModelType		= null;
		
		/**
		 * 
		 * @param id
		 * @param name
		 * 
		 */
		public function UmlModelTypedElement(id:String, name:String)
		{
			super(id, name);
		}
		
		public function get type():UmlModelType
		{
			return _type;
		}
		public function set type(type:UmlModelType):void
		{
			_type = type;
		}
		
	}
	
}
