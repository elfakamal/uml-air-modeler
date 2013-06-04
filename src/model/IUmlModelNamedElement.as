package model
{
	
	/**
	 * 
	 * A named element represents elements that may have a name. The name 
	 * is used for identification of the named element within the namespace 
	 * in which it is defined. A named element also has a qualified name 
	 * that allows it to be unambiguously identified within a hierarchy 
	 * of nested namespaces. 
	 * 
	 * NamedElement is an abstract metaclass.
	 * 
	 * @author kamal
	 * 
	 */
	public interface IUmlModelNamedElement extends IUmlModelElement
	{
		
		function set name(value:String):void;
		function get name():String;
		
		/**
		 * A name that allows the NamedElement to be identified within 
		 * a hierarchy of nested Namespaces. It is constructed from the 
		 * names of the containing namespaces starting at the root of the 
		 * hierarchy and ending with the name of the NamedElement itself. 
		 * This is a derived attribute.
		 */
		function get qualifiedName():String;
		
		/**
		 * Determines where the NamedElement appears within different Namespaces 
		 * within the overall model, and its accessibility.
		 */
		function set visibility(value:UmlModelVisibilityKind):void;
		function get visibility():UmlModelVisibilityKind;
		
		/**
		 * Specifies the namespace that owns the NamedElement. 
		 * Subsets Element::owner. This is a derived union.
		 */
		function get $namespace():IUmlModelNamespace;
		
		/**
		 * Indicates the dependencies that reference the client
		 */
		function get clientDependencies():Array;
		
		/**
		 * gives the string that is used to separate names when constructing 
		 * a qualified name
		 */
		function get separator():String;
		
		/**
		 * gives the sequence of namespaces in which the NamedElement is nested, 
		 * working outwards.
		 */
		function getAllNamespaces():Array; // or LinkedList ;-)
		
		/**
		 * determines whether two NamedElements may logically co-exist within 
		 * a Namespace. By default, two named elements are distinguishable 
		 * if (a) they have unrelated types or (b) they have related types but 
		 * different names.
		 */
		function isDistinguishableFrom(element:IUmlModelNamedElement, ns:IUmlModelNamespace):Boolean;
		
	}
	
}
