package model
{
	import model.IUmlModelNamedElement;
	import model.UmlModelVisibilityKind;
	
	/**
	 * A package is used to group elements, and provides a namespace for the 
	 * grouped elements.
	 * 
	 * A package is a namespace for its members, and may contain other packages. 
	 * Only packageable elements can be owned members of a package. By virtue 
	 * of being a namespace, a package can import either individual members 
	 * of other packages, or all the members of other packages.
	 * 
	 * In addition a package can be merged with other packages.
	 * 
	 * @author kamal
	 * 
	 */
	internal class	UmlModelPackage 
		extends		UmlModelNamespace
		implements	IUmlModelPackageableElement 
	{
		
		/**
		 * References the PackageMerges that are owned by this Package. 
		 * Subsets Element::ownedElement
		 */
		protected var _packageMerges		:Array					= null;
		
		/**
		 * References the Package that owns this Package. 
		 * Subsets NamedElement::namespace
		 */
		protected var _nestingPackage		:UmlModelPackage		= null;
		
		/**
		 * 
		 * @param id
		 * @param name
		 * @param visibility
		 * 
		 */
		public function UmlModelPackage(id:String, name:String)
		{
			super(id, name);
		}
		
		/**
		 * 
		 * @param umlNode
		 * 
		 */
		public override function addElement(umlNode:IUmlModelElement):void
		{
			if (umlNode != null)
			{
//				_ownedElements.push(umlNode);
			}
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public override function get xml():XML
		{
			_xml = <umlPackage id={uid} name={name} />;
			
			if (ownedElements && ownedElements.length > 0)
			{
				var nodesXml:XML = <umlNodes />;
				for (var i:int = 0; i < ownedElements.length; i++)
				{
					var element:UmlModelElement = UmlModelElement(ownedElements[i]);
					
					// vaux mieux ne pas mettre tou l'xml du noeud, 
					// il pourra contenir beaucoup plus d'infos, 
					// et on aura des redondances de données 
					nodesXml.appendChild(<node id={element.uid} />);
				}
				_xml.appendChild(nodesXml);
			}
			
			return _xml;
		}
		
		public function get packageMerges():Array
		{
			return _packageMerges;
		}
		public function set packageMerges(value:Array):void 
		{
			_packageMerges = value;
		}
		
		public function get nestingPackage():UmlModelPackage
		{
			return _nestingPackage;
		}
		public function set nestingPackage(value:UmlModelPackage):void 
		{
			_nestingPackage = value;
		}
		
		//subsetting
		//from NamedElement
		override public function get ownedElements():Array
		{
			var elements:Array = [];
			
			if (super.ownedElements != null)
			{
				elements = elements.concat(super.ownedElements);
			}
			
			if (packageMerges != null)
			{
				elements = elements.concat(packageMerges);
			}
			
			return elements;
		}
		
		//subsetting
		//from NamedElement
		override public function get $namespace():IUmlModelNamespace
		{
			if (nestingPackage != null)
			{
				return nestingPackage;
			}
			
			return super.$namespace;
		}
		
		/**
		 * References the owned members that are Packages. 
		 * Subsets Package::packagedElement
		 * derived union
		 */
		public function get nestedpackages():Array
		{
			return null;
		}
		
		/**
		 * Specifies the packageable elements that are owned by this Package. 
		 * Subsets Namespace::ownedMember
		 */
		public function get packagedElements():Array
		{
			var elements:Array = [];
			
			if (nestedpackages != null)
			{
				elements = elements.concat(nestedpackages);
			}
			
			if (ownedTypes != null)
			{
				elements = elements.concat(ownedTypes);
			}
			
			return elements;
		}
		
		/**
		 * References the packaged elements that are Types. 
		 * Subsets Package::packagedElement
		 */
		public function get ownedTypes():Array
		{
			return null;
		}
		
		
		/* INTERFACE model.IUmlModelNamespace */
		
		override public function get ownedMembers():Array
		{
			var elements:Array = [];
			
			if (super.ownedMembers != null)
			{
				elements = elements.concat(super.ownedMembers);
			}
			
			if (packagedElements != null)
			{
				elements = elements.concat(packagedElements);
			}
			
			return elements;
		}
		
		/* INTERFACE model.IUmlModelPackageableElement */
		
		public function get packageableElementVisibility():UmlModelVisibilityKind
		{
			return visibility;
		}
		
	}
	
}
