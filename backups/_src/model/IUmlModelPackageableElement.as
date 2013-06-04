package model
{
	
	/**
	 * A packageable element indicates a named element that may be owned 
	 * directly by a package.
	 * 
	 * @author kamal
	 * 
	 */
	public interface IUmlModelPackageableElement extends IUmlModelNamedElement
	{
		
		/**
		 * Indicates that packageable elements must always have a visibility 
		 * (i.e., visibility is not optional). 
		 * Redefines NamedElement::visibility. 
		 * Default value is false.
		 */
		function get packageableElementVisibility():UmlModelVisibilityKind;
		
	}
	
}
