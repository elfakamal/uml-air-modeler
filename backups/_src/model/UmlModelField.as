package model
{
	
	/**
	 * 
	 * @author kamal
	 * 
	 */
	internal class UmlModelField extends UmlModelNamedElement
	{
		
		protected var _type					:String;
		protected var _isMember				:Boolean			= true;
		
		/**
		 * 
		 * @param id
		 * @param name
		 * @param visibility
		 * @param type
		 * @param isMember
		 * 
		 */
		public function UmlModelField(
								id						:String, 
								name					:String, 
								visibility				:String,
								type					:String, 
								isMember				:Boolean = true
						)
		{
			super(id, name);
			
			_type				= type;
			_isMember			= isMember;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public override function get xml():XML
		{
			return _xml;
		}
		
		public function getType():String
		{
			return _type;
		}
		public function setType(value:String):void
		{
			_type = value;
		}
		
		public function isMember():Boolean
		{
			return _isMember;
		}
		public function setIsMember(value:Boolean):void
		{
			_isMember = value;
		}
		
	}
	
}
