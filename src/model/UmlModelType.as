package model
{
	
	/**
	 * A type constrains the values represented by a typed element.
	 * A type serves as a constraint on the range of values represented 
	 * by a typed element. 
	 * 
	 * Type is an abstract metaclass.
	 * 
	 * @author kamal
	 * 
	 */
	internal class	UmlModelType 
		extends		UmlModelNamedElement
		implements	IUmlModelType
	{
		
		/**
		 * 
		 * @param id
		 * @param name
		 * @param visibility
		 * 
		 */
		public function UmlModelType(
							p_uid				:String, 
							p_name				:String, 
							p_visibility		:UmlModelVisibilityKind = null)
		{
			super(p_uid, p_name, p_visibility);
		}
		
		/**
		 * returns true for a type that conforms to another. 
		 * By default, two types do not conform to each other. 
		 * This function is intended to be redefined for specific conformance 
		 * situations.
		 *  
		 */
		public function conformsTo(type:UmlModelType):Boolean
		{
			// by default, it returns false;
			return false;
		}
		
		public function get packageableElementVisibility():UmlModelVisibilityKind
		{
			return visibility;
		}
		
		public function toString():String
		{
			return name;
		}
		
	}
	
}
