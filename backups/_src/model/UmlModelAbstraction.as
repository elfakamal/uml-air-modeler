package model
{
	
	/**
	 * An abstraction is a relationship that relates two elements or sets 
	 * of elements that represent the same concept at different levels 
	 * of abstraction or from different viewpoints. 
	 * 
	 * In the metamodel, an Abstraction is a Dependency in which there 
	 * is a mapping between the supplier and the client.
	 * 
	 * @author kamal
	 * 
	 */
	internal class UmlModelAbstraction extends UmlModelDependency
	{
		
		/**
		 * A composition of an Expression that states the abstraction relationship 
		 * between the supplier and the client. In some cases, such as Derivation, 
		 * it is usually formal and unidirectional. In other cases, such as Trace, 
		 * it is usually informal and bidirectional. The mapping expression 
		 * is optional and may be omitted if the precise relationship between 
		 * the elements is not specified.
		 */
		protected var _mapping			:UmlModelExpression			= null;
		
		/**
		 * 
		 * @param p_uid
		 * 
		 */
		public function UmlModelAbstraction(p_uid:String)
		{
			super(p_uid);
		}
		
		public function set mapping(value:UmlModelExpression):void
		{
			_mapping = value;
		}
		public function get mapping():UmlModelExpression
		{
			return _mapping;
		}
		
	}
	
}
