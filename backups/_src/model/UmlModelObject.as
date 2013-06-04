package model
{
	/**
	 * 
	 * @author kamal
	 * 
	 */
	internal class UmlModelObject extends UmlModelNamedElement
	{
		
		/**
		 * 
		 */
		protected var _content		:String			= "";
		
		/**
		 * 
		 * @param id
		 * @param name
		 * @param visibility
		 * 
		 */
		public function UmlModelObject(id:String, name:String)
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
			_xml = <umlObject id={uid} name={name} />;
			return _xml;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public override function get ownedElements():Array
		{
			return null;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public override function get selectedNodes():Array
		{
			return null;
		}
		
		/**
		 * 
		 * @param content
		 * 
		 */
		public function setContent(content:String):void
		{
			throw new Error("this function can't be called here, " + 
					"it must be overriden in subClasses");
		}
		public function getContent():String
		{
			return _content;
		}
		
	}
	
}
