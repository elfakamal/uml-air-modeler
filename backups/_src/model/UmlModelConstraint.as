package model
{
	
	import model.UmlModelVisibilityKind;
	
	/**
	 * A constraint is a condition or restriction expressed in natural language 
	 * text or in a machine readable language for the purpose of declaring some 
	 * of the semantics of an element.
	 * 
	 * Constraint contains a ValueSpecification that specifies additional 
	 * semantics for one or more elements. Certain kinds of constraints 
	 * (such as an association �xor� constraint) are predefined in UML, 
	 * others may be user-defined. 
	 * 
	 * A user-defined Constraint is described using a specified language, whose 
	 * syntax and interpretation is a tool responsibility. One predefined language 
	 * for writing constraints is OCL. In some situations, a programming language 
	 * such as Java may be appropriate for expressing a constraint. In other 
	 * situations natural language may be used. 
	 * 
	 * Constraint is a condition (a Boolean expression) that restricts 
	 * the extension of the associated element beyond what is imposed 
	 * by the other language constructs applied to that element.
	 * 
	 * Constraint contains an optional name, although they are commonly unnamed.
	 * 
	 * @author kamal
	 * 
	 */
	internal class	UmlModelConstraint 
		extends		UmlModelNamedElement 
		implements	IUmlModelPackageableElement
	{
		
		/**
		 * The ordered set of Elements referenced by this Constraint.
		 */
		protected var _constrainedElements	:Array						= null;
		
		/**
		 * 
		 */
		protected var _specification		:UmlModelValueSpecification = null;
		
		/**
		 * 
		 * @param id
		 * @param name
		 * 
		 */
		public function UmlModelConstraint(
								p_uid			:String, 
								p_name			:String, 
								p_visibility	:UmlModelVisibilityKind = null)
		{
			super(p_uid, p_name, p_visibility);
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public override function get xml():XML
		{
			_xml = <umlConstraint 
							id			={uid} 
							name		={name} />;
			return _xml;
		}
		
		/**
		 * Specifies the Namespace that is the context for evaluating this 
		 * constraint. 
		 * 
		 * Subsets NamedElement::namespace.
		 * & must to be overriden in subclasses.
		 */
		public function get context():IUmlModelNamespace
		{
			return null;
		}
		
		override public function get $namespace():IUmlModelNamespace
		{
			if (context != null)
			{
				return context;
			}
			return super.$namespace;
		}
		
		override public function get ownedElements():Array
		{
			var elements:Array = [];
			
			if (super.ownedElements != null)
			{
				elements = elements.concat(super.ownedElements);
			}
			
			if (specification != null)
			{
				elements = elements.concat([specification]);
			}
			
			return elements;
		}
		
		/* INTERFACE model.IUmlModelPackageableElement */
		
		public function get packageableElementVisibility():UmlModelVisibilityKind
		{
			return visibility;
		}
		
		public function get specification():UmlModelValueSpecification
		{
			return _specification;
		}
		public function set specification(value:UmlModelValueSpecification):void 
		{
			_specification = value;
		}
		
		public function get constrainedElements():Array
		{
			return _constrainedElements;
		}
		public function set constrainedElements(value:Array):void 
		{
			_constrainedElements = value;
		}
		
	}
	
}
