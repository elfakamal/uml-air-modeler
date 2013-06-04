package model
{
	
	/**
	 * A value specification is the specification of a (possibly empty) 
	 * set of instances, including both objects and data values.
	 * 
	 * ValueSpecification is an abstract metaclass used to identify a value 
	 * or values in a model. It may reference an instance or it may be 
	 * an expression denoting an instance or instances when evaluated.
	 * 
	 * @author kamal
	 * 
	 */
	public class	UmlModelValueSpecification 
		extends		UmlModelNamedElement 
		implements	IUmlModelTypedElement, 
					IUmlModelPackageableElement
	{
		
		protected var _type			:IUmlModelType			= null;
		
		/**
		 * 
		 * @param id
		 * @param name
		 * 
		 */
		public function UmlModelValueSpecification(
									p_uid				:String, 
									p_name				:String, 
									p_visibility		:UmlModelVisibilityKind = null)
		{
			super(p_uid, p_name, p_visibility);
		}
		
		public function set type(value:IUmlModelType):void
		{
			_type = value;
		}
		public function get type():IUmlModelType
		{
			return _type;
		}
		
		public override function get xml():XML
		{
			return null;
		}
		
		public function get packageableElementVisibility():UmlModelVisibilityKind
		{
			return null;
		}
		
		/**
		 * determines whether a value specification can be computed in a model. 
		 * This operation cannot be fully defined in OCL. A conforming 
		 * implementation is expected to deliver true for this operation 
		 * for all value specifications that it can compute, and to compute 
		 * all of those for which the operation is true. A conforming 
		 * implementation is expected to be able to compute the value 
		 * of all literals
		 */
		public function get isComputable():Boolean
		{
			return false;
		}
		
		public function get integerValue():int
		{
			return 0;
		}
		
		public function get booleanValue():Boolean
		{
			return false;
		}
		
		public function get stringValue():String
		{
			return null;
		}
		
		public function get unlimitedValue():Number
		{
			return 0.0;
		}
		
		public function get isNull():Boolean
		{
			return false;
		}
		
	}
	
}
