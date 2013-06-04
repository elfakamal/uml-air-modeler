package model 
{
	import model.UmlModelValueSpecification;
	import model.UmlModelVisibilityKind;
	import model.UmlModelInstanceSpecification;
	
	/**
	 * An instance value is a value specification that identifies an instance.
	 * An instance value specifies the value modeled by an instance specification.
	 * 
	 * @author EL FARSAOUI Kamal
	 */
	internal class UmlModelInstanceValue extends UmlModelValueSpecification
	{
		
		/**
		 * The instance that is the specified value.
		 */
		protected var _instance		:UmlModelInstanceSpecification	= null;
		
		
		public function UmlModelInstanceValue(
									p_uid			:String, 
									p_name			:String, 
									p_visibility	:UmlModelVisibilityKind = null) 
		{
			super(p_uid, p_name, p_visibility);
		}
		
		public function get instance():UmlModelInstanceSpecification
		{
			return _instance;
		}
		public function set instance(value:UmlModelInstanceSpecification):void 
		{
			_instance = value;
		}
		
	}

}