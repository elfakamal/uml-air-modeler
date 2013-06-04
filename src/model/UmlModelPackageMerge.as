package model
{
	
	/**
	 * A package merge is a directed relationship between two packages that 
	 * indicates that the contents of the two packages are to be combined. 
	 * 
	 * It is very similar to Generalization in the sense that the source element 
	 * conceptually adds the characteristics of the target element to its own 
	 * characteristics resulting in an element that combines the characteristics 
	 * of both.
	 * 
	 * This mechanism should be used when elements defined in different packages 
	 * have the same name and are intended to represent the same concept. 
	 * Most often it is used to provide different definitions of a given concept 
	 * for different purposes, starting from a common base definition. 
	 * 
	 * A given base concept is extended in increments, with each increment 
	 * defined in a separate merged package. By selecting which increments 
	 * to merge, it is possible to obtain a custom definition of a concept 
	 * for a specific end. 
	 * 
	 * Package merge is particularly useful in meta-modeling and is extensively 
	 * used in the definition of the UML metamodel.
	 * 
	 * Conceptually, a package merge can be viewed as an operation that takes 
	 * the contents of two packages and produces a new package that combines 
	 * the contents of the packages involved in the merge. In terms of model 
	 * semantics, there is no difference between a model with explicit package 
	 * merges, and a model in which all the merges have been performed.
	 * 
	 * @author kamal
	 * 
	 */
	internal class UmlModelPackageMerge extends UmlModelDirectedRelationship
	{
		
		/**
		 * References the Package that is to be merged with the receiving 
		 * package of the PackageMerge. 
		 * Subsets DirectedRelationship::target
		 */
		protected var _mergedPackage			:UmlModelPackage		= null;
		
		/**
		 * References the Package that is being extended with the contents 
		 * of the merged package of the PackageMerge. 
		 * Subsets Element::owner and DirectedRelationship::source
		 */
		protected var _receivingPackage			:UmlModelPackage		= null;
		
		/**
		 * see semantics for more specifications.
		 */
		public function UmlModelPackageMerge(p_uid:String)
		{
			super(p_uid);
		}
		
		public function set mergedPackage(value:UmlModelPackage):void
		{
			_mergedPackage = value;
		}
		public function get mergedPackage():UmlModelPackage
		{
			return _mergedPackage;
		}
		
		public function set receivingPackage(value:UmlModelPackage):void
		{
			_receivingPackage = value;
		}
		public function get receivingPackage():UmlModelPackage
		{
			return _receivingPackage;
		}
		
		public override function get targets():Array
		{
			var elements:Array = [];
			
			if (super.targets != null)
			{
				elements = elements.concat(super.targets);
			}
			
			if (mergedPackage != null)
			{
				elements.push(mergedPackage);
			}
			
			return elements;
		}
		
		/**
		 * importingNamespace subsets sources 
		 */
		public override function get sources():Array
		{
			var elements:Array = [];
			
			if (super.sources != null)
			{
				elements = elements.concat(super.sources);
			}
			
			if (receivingPackage != null)
			{
				elements.push(receivingPackage);
			}
			
			return elements;
		}
		
		/**
		 * importingNamespace subsets owner
		 */
		public override function get owner():IUmlModelElement
		{
			if (receivingPackage != null)
			{
				return receivingPackage;
			}
			
			return super.owner;
		}
		
	}
	
}
