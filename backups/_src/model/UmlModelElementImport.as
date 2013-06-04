package model
{
	
	/**
	 * An element import identifies an element in another package, and allows 
	 * the element to be referenced using its name without a qualifier.
	 * 
	 * An element import is defined as a directed relationship between 
	 * an importing namespace and a packageable element. The name of the 
	 * packageable element or its alias is to be added to the namespace 
	 * of the importing namespace. It is also possible to control whether 
	 * the imported element can be further imported.
	 * 
	 * @author kamal
	 * 
	 */
	internal class UmlModelElementImport extends UmlModelDirectedRelationship
	{
		
		/**
		 * Specifies the visibility of the imported PackageableElement within 
		 * the importing Package. The default visibility is the same as that 
		 * of the imported element. If the imported element does not have 
		 * a visibility, it is possible to add visibility to the element import. 
		 * Default value is public.
		 */
		protected var _visibility:UmlModelVisibilityKind = UmlModelVisibilityKind.$public;
		
		/**
		 * Specifies the name that should be added to the namespace 
		 * of the importing Package in lieu of the name of the imported 
		 * PackagableElement. The aliased name must not clash with any 
		 * other member name in the importing Package. 
		 * By default, no alias is used
		 */
		protected var _alias:String = "";
		
		/**
		 * Specifies the PackageableElement whose name is to be added 
		 * to a Namespace. 
		 * Subsets DirectedRelationship::target.
		 */
		protected var _importedElement:IUmlModelPackageableElement = null;
		
		/**
		 * Specifies the Namespace that imports a PackageableElement 
		 * from another Package. 
		 * Subsets DirectedRelationship::source and Element::owner.
		 */
		protected var _importingNamespace:IUmlModelNamespace = null;
		
		
		/**
		 * 
		 * @param p_uid
		 * 
		 */
		public function UmlModelElementImport(p_uid:String)
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
		
		public function set alias(value:String):void
		{
			_alias = value;
		}
		public function get alias():String
		{
			return _alias;
		}
		
		public function set importedElement(value:IUmlModelPackageableElement):void
		{
			_importedElement = value;
		}
		public function get importedElement():IUmlModelPackageableElement
		{
			return _importedElement;
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
			
			if (importedElement != null)
			{
				elements.push(importedElement);
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
		
		/**
		 * returns the name under which the imported PackageableElement 
		 * will be known in the importing namespace.
		 */
		public function getName():String
		{
			if (alias != "")
			{
				return alias;
			}
			else
			{
				return importedElement.name;
			}
		}
		
	}
	
}
