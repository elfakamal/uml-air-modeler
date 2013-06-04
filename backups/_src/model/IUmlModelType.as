package model 
{
	
	/**
	 * 
	 * 
	 * 
	 * @author EL FARSAOUI Kamal
	 * 
	 */
	public interface IUmlModelType extends IUmlModelPackageableElement
	{
		
		/**
		 * 
		 * returns true for a type that conforms to another. 
		 * By default, two types do not conform to each other. 
		 * This function is intended to be redefined for specific conformance 
		 * situations.
		 *  
		 */
		function conformsTo(type:UmlModelType):Boolean;
		
		function toString():String;
		
	}
	
}
