package model
{
	
	/**
	 * 
	 * @author kamal
	 * 
	 */
	internal class UmlModelConstant extends UmlModelProperty
	{
		
		
		/**
		 * 
		 * @param id
		 * @param name
		 * @param accessor
		 * @param type
		 * 
		 */
		public function UmlModelConstant(
								p_uid				:String, 
								p_name				:String, 
								p_visibility		:UmlModelVisibilityKind = null)
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
			_xml = <umlConstant 
							id			={uid} 
							name		={name} 
							visibility	={visibility.toString()}
							type		={type.toString()} />; 
			
			return _xml;
		}
		
	}
	
}
