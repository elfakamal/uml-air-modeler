package controler.events
{
	
	import flash.events.Event;
	
	/**
	 * 
	 * @author kamal
	 * 
	 */
	public class UmlAssociationEvent extends UmlEvent
	{
		
		public static const ASSOCIATION_ADDED		:String		= "associationAdded";
		public static const ASSOCIATION_CLASS_ADDED	:String		= "associationClassAdded";
		public static const ASSOCIATION_END_ADDED	:String		= "associationEndAdded";
		public static const RELATIONSHIP_ADDED		:String		= "relationshipAdded";
		
		
		private var _addedAssociationClass			:XML		= null;
		private var _addedAssociation				:XML		= null;
		private var _addedAssociationEnd			:XML		= null;
		
		
		/**
		 * 
		 * @param type
		 * @param bubbles
		 * @param cancelable
		 * 
		 */
		public function UmlAssociationEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		
		public function get addedAssociationClass():XML
		{
			return _addedAssociationClass;
		}
		public function set addedAssociationClass(value:XML):void
		{
			_addedAssociationClass = value;
		}
		
		public function get addedAssociation():XML
		{
			return _addedAssociation;
		}
		public function set addedAssociation(value:XML):void
		{
			_addedAssociation = value;
		}
		
		public function get addedAssociationEnd():XML
		{
			return _addedAssociationEnd;
		}
		public function set addedAssociationEnd(value:XML):void
		{
			_addedAssociationEnd = value;
		}
		
	}
	
}
