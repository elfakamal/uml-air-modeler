package model
{
	import model.UmlModelElement;
	import model.IUmlModelElement;
	import model.IUmlModelAssociation;
	
	/**
	 * Relationship is an abstract concept that specifies some kind 
	 * of relationship between elements.
	 * 
	 * @author kamal
	 * 
	 */
	internal class UmlModelRelationship extends UmlModelElement
	{
		
		protected var _name					:String					= "";
		
		/**
		 * 
		 * @param id
		 */
		public function UmlModelRelationship(p_uid:String)
		{
			super(p_uid);
		}
		
		/**
		 * must to be redefined in subclasses, 
		 * it is derived.
		 */
		public function get relatedElements():Array
		{
			return null;
		}
		
		public function set name(value:String):void
		{
			_name = value;
		}
		public function get name():String
		{
			return _name;
		}
		
		public override function get xml():XML
		{
			return null;
		}
		
	}
	
}
