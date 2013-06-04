package model
{
	import mx.events.IndexChangedEvent;
	
	/**
	 * 
	 * @author kamal
	 * 
	 */
	internal class	UmlModelAssociationClass 
		extends		UmlModelClass
		implements	IUmlModelAssociation
	{
		
		/**
		 * 
		 * 
		 * 
		 */
		private var _relativeAssociationId		:int			= -1;
		
		
		/**
		 * 
		 * @param id
		 * @param name
		 * @param relativeAssociationId
		 * @param visibility
		 * 
		 */
		public function UmlModelAssociationClass(
									id						:String, 
									name					:String, 
									relativeAssociationId	:int, 
									visibility				:UmlModelVisibilityKind	= null)
		{
			super(id, name, visibility);
			
			_relativeAssociationId = relativeAssociationId
		}
		
		/**
		 * 
		 * @param associationId
		 * 
		 */
		public function setAssociation(associationId:int):void
		{
			
		}
		
		/* INTERFACE model.IUmlModelAssociation */
		
		public function get isDerived():Boolean
		{
			return false;
		}
		
		public function get memberEnds():Array
		{
			return null;
		}
		
		public function get ownedEnds():Array
		{
			return null;
		}
		
		public function get navigableOwnedEnds():Array
		{
			return null;
		}
		
		public function get endTypes():Array
		{
			return null;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public override function get xml():XML
		{
			_xml = super.xml;
			
			var xAssociation:XML = <relativeAssociation id={_relativeAssociationId} />;
			
			_xml.appendChild(xAssociation);
			
			return _xml;
		}
		
	}
	
}
