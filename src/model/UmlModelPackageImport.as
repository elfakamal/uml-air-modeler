package model
{
	
	/**
	 * A package import is a relationship that allows the use of unqualified 
	 * names to refer to package members from other namespaces.
	 * 
	 * A package import is defined as a directed relationship that identifies 
	 * a package whose members are to be imported by a namespace.
	 * 
	 * @author kamal
	 * 
	 */
	internal class UmlModelPackageImport extends UmlModelDirectedRelationship
	{
		
		/**
		 * Specifies the visibility of the imported PackageableElements within 
		 * the importing Namespace, i.e., whether imported elements will 
		 * in turn be visible to other packages that use that importingPackage 
		 * as an importedPackage. If the PackageImport is public, the imported 
		 * elements will be visible outside the package, while if it is private 
		 * they will not. By default, the value of visibility is public
		 * 
		 */
		protected var _visibility :UmlModelVisibilityKind = UmlModelVisibilityKind.$public;
		
		/**
		 * Specifies the Package whose members are imported into a Namespace. 
		 * Subsets DirectedRelationship::target
		 */
		protected var _importedPackage		:UmlModelPackage		= null;
		
		/**
		 * Specifies the Namespace that imports the members from a Package. 
		 * Subsets DirectedRelationship::source and Element::owner
		 */
		protected var _importingNamespace	:IUmlModelNamespace		= null;
		
		/**
		 * 
		 */
		public function UmlModelPackageImport(p_uid:String)
		{
			super(p_uid);
		}
		
		/**
		 * The visibility of a PackageImport is either public or private.
		 */
		public function set visibility(value:UmlModelVisibilityKind):void
		{
			// cuz of costraints
			if (
				value == UmlModelVisibilityKind.$public || 
				value == UmlModelVisibilityKind.$private
				)
			{
				_visibility = value;
			}
		}
		public function get visibility():UmlModelVisibilityKind
		{
			return _visibility;
		}
		
		public function set importedPackage(value:UmlModelPackage):void
		{
			_importedPackage = value;
		}
		public function get importedPackage():UmlModelPackage
		{
			return _importedPackage;
		}
		
		public function set importingNamespace(value:IUmlModelNamespace):void
		{
			_importingNamespace = value;
		}
		public function get importingNamespace():IUmlModelNamespace
		{
			return _importingNamespace;
		}
		
		public override function get targets():Array
		{
			var elements:Array = [];
			
			if (super.targets != null)
			{
				elements = elements.concat(super.targets);
			}
			
			if (importedPackage != null)
			{
				elements.push(importedPackage);
			}
			return [];
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
			
			if (importingNamespace != null)
			{
				elements.push(importingNamespace);
			}
			
			return elements;
		}
		
		/**
		 * importingNamespace subsets owner
		 */
		public override function get owner():IUmlModelElement
		{
			if (importingNamespace != null)
			{
				return importingNamespace;
			}
			
			return super.owner;
		}
		
	}
	
}
