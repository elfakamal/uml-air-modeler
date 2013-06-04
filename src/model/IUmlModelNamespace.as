package model
{
	
	/**
	 * A namespace is a named element that can own other named elements. 
	 * Each named element may be owned by at most one namespace. 
	 * A namespace provides a means for identifying named elements by name. 
	 * Named elements can be identified by name in a namespace either 
	 * by being directly owned by the namespace or by being introduced 
	 * into the namespace by other means (e.g., importing or inheriting). 
	 * 
	 * A namespace can own constraints. A constraint associated with 
	 * a namespace may either apply to the namespace itself, or it may 
	 * apply to elements in the namespace.
	 * 
	 * A namespace has the ability to import either individual members 
	 * or all members of a package, thereby making it possible to refer 
	 * to those named elements without qualification in the importing namespace. 
	 * In the case of conflicts, it is necessary to use qualified names 
	 * or aliases to disambiguate the referenced elementsA namespace 
	 * is a named element that can own other named elements. 
	 * 
	 * Each named element may be owned by at most one namespace. 
	 * A namespace provides a means for identifying named elements by name. 
	 * Named elements can be identified by name in a namespace either 
	 * by being directly owned by the namespace or by being introduced 
	 * into the namespace by other means (e.g., importing or inheriting). 
	 * 
	 * Namespace is an abstract metaclass.
	 * 
	 */
	public interface IUmlModelNamespace extends IUmlModelElement
	{
		
		/**
		 * References the ElementImports owned by the Namespace. 
		 * Subsets Element::ownedElement
		 */
		function get elementImports():Array;
		
		/**
		 * References the PackageableElements that are members of this Namespace 
		 * as a result of either PackageImports or ElementImports. 
		 * Subsets Namespace::member
		 */
		function get importedMembers():Array;
		
		/**
		 * returns a collection of NamedElements identifiable within 
		 * the Namespace, either by being owned or by being introduced 
		 * by importing or inheritance. This is a derived union.
		 */
		function get members():Array;
		
		/**
		 * returns a collection of NamedElements owned by the Namespace. 
		 * Subsets Element::ownedElement and Namespace::member. 
		 * This is a derived union.
		 */
		function get ownedMembers():Array;
		
		/**
		 * Specifies a set of Constraints owned by this Namespace. 
		 * Subsets Namespace::ownedMember
		 */
		function get ownedRules():Array;
		
		/**
		 * References the PackageImports owned by the Namespace. 
		 * Subsets Element::ownedElement
		 */
		function get packageImports():Array;
		
		/**
		 * returns a set of all of the names that a member would have 
		 * in a Namespace. In general a member can have multiple names 
		 * in a Namespace if it is imported more than once with different 
		 * aliases. 
		 * 
		 * The function takes account of importing.
		 *  
		 * It returns back the set of names that an element would have 
		 * in an importing namespace, either because it is owned; 
		 * or if not owned, then imported individually; 
		 * or if not individually, then from a package.
		 */
		function getNamesOfMember(element:IUmlModelNamedElement):Array;
		
		/**
		 * determines whether all of the namespace’s members are 
		 * distinguishable within it.
		 */
		function membersAreDistinguishable():Boolean;
		
		/**
		 * defines which of a set of PackageableElements are actually imported 
		 * into the namespace. This excludes hidden ones, i.e., those that have 
		 * names that conflict with names of owned members, and also excludes 
		 * elements that would have the same name when imported.
		 */
		function importMembers(elements:Array):Array;
		
		/**
		 * excludes from a set of PackageableElements any that would not be 
		 * distinguishable from each other in this namespace
		 */
		function excludeCollisions(elements:Array):Array;
		
	}
	
}
