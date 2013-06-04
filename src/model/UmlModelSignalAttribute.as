package model
{
	/**
	 * 
	 * @author kamal
	 * 
	 */
	internal class UmlModelSignalAttribute extends UmlModelNamedElement
	{
		
		/**
		 * 
		 * @param id
		 * @param name
		 * @param visibility
		 * @param type
		 * 
		 */
		public function UmlModelSignalAttribute(
										id				:String, 
										name			:String, 
										visibility		:String, 
										type			:String)
		{
			super(id, name);//, visibility, type, true);
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public override function get xml():XML
		{
			_xml = <umlSignalAttribute 
								id			= {uid} 
								name		= {name} />;
								/* visibility	= {getVisibility()} 
								type		= {getType()} */ 
								
			return _xml;
		}
		
	}
	
}
