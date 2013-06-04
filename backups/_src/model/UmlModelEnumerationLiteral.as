package model
{
	/**
	 * 
	 * @author kamal
	 * 
	 */
	internal class UmlModelEnumerationLiteral extends UmlModelInstanceSpecification
	{
		
		/**
		 * 
		 */
		protected var _enumeration		:UmlModelEnumeration		= null;
		
		/**
		 * 
		 * @param id
		 * @param name
		 * @param type
		 * @param p_value
		 * 
		 */
		public function UmlModelEnumerationLiteral(
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
			_xml = <umlEnumerationLiteral 
									id			= {uid} 
									name		= {name} />;
			return _xml;
		}
		
		public function get enumeration():UmlModelEnumeration
		{
			return _enumeration;
		}
		public function set enumeration(value:UmlModelEnumeration):void 
		{
			_enumeration = value;
		}
		
		override public function get $namespace():IUmlModelNamespace
		{
			if (enumeration != null)
			{
				return enumeration;
			}
			
			return super.$namespace;
		}
		
	}
	
}
