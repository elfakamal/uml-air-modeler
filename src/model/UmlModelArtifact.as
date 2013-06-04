package model
{
	/**
	 * 
	 * @author kamal
	 * 
	 */
	internal class UmlModelArtifact extends UmlModelObject
	{
		
		/**
		 * 
		 * @param id
		 * @param name
		 * 
		 */
		public function UmlModelArtifact(id:String, name:String)
		{
			super(id, name);
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public override function get xml():XML
		{
			_xml = <umlArtifact id={uid} name={name} />;
			return _xml;
		}
		
	}
	
}
