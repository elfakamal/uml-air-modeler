package model
{
	
	/**
	 * 
	 * @author kamal
	 * 
	 */
	internal class UmlModelNote extends UmlModelObject
	{
		
		/**
		 * 
		 * @param id
		 * @param name
		 * 
		 */
		public function UmlModelNote(id:String, name:String, content:String="")
		{
			super(id, name);
			
			_content = content;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public override function get xml():XML
		{
			_xml = <umlNote 
							id			={uid} 
							name		={name} 
							content		={getContent()} />;
			return _xml;
		}
		
		/**
		 * 
		 * @param content
		 * 
		 */
		public override function setContent(content:String):void
		{
			_content = content;
		}
		
	}
	
}
