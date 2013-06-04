package model
{
	import mx.core.IUID;

	/**
	 * A redefinable element is an element that, when defined in the context 
	 * of a classifier, can be redefined more specifically or differently 
	 * in the context of another classifier that specializes (directly or 
	 * indirectly) the context classifier.
	 * 
	 * @author kamal
	 * 
	 */
	public interface IUmlModelRedefinableElement extends IUmlModelNamedElement
	{
		
		/**
		 * Indicates whether it is possible to further specialize 
		 * a RedefinableElement. If the value is true, then it is not 
		 * possible to further specialize the RedefinableElement. 
		 * Default value is false
		 */
		function get isLeaf():Boolean;
		
		/**
		 * The redefinable element that is being redefined by this element. 
		 * This is a derived union.
		 */
		function get redefinedElements():Array;
		
		/**
		 * References the contexts that this element may be redefined from. 
		 * This is a derived union.
		 */
		function get redefinitionContexts():Array;
		
		/**
		 * specifies, for any two RedefinableElements in a context in which 
		 * redefinition is possible, whether redefinition would be logically 
		 * consistent. 
		 * 
		 * By default, this is false;
		 *  
		 * this operation must be overridden for subclasses of RedefinableElement 
		 * to define the consistency conditions.
		 */
		function isConsistentWith(redefinee:IUmlModelRedefinableElement):Boolean;
		
		/**
		 * specifies whether the redefinition contexts of this RedefinableElement 
		 * are properly related to the redefinition contexts of the specified 
		 * RedefinableElement to allow this element to redefine the other. 
		 * By default at least one of the redefinition contexts of this element 
		 * must be a specialization of at least one of the redefinition contexts 
		 * of the specified element.
		 */
		function isRedefinitionContextValid(redefined:IUmlModelRedefinableElement):Boolean;
		
	}
	
}
