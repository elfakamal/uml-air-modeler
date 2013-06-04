package model
{
	import controler.events.UmlEvent;
	
	
	/**
	 * 
	 * @author kamal
	 * 
	 */
	internal class UmlModelAssociationEnd extends UmlModelProperty
	{
		
		/**
		 * 
		 * @param p_uid
		 * @param p_name
		 * @param p_visibility
		 * @param p_isNavigable
		 * 
		 */
		public function UmlModelAssociationEnd(
									p_uid			:String, 
									p_name			:String, 
									p_visibility	:UmlModelVisibilityKind=null, 
									p_isNavigable	:Boolean = false, 
									p_multiplicity	:Array = null)
		{
			super(p_uid, p_name, p_visibility);
			
			setNavigable(p_isNavigable);
			
			if (p_multiplicity != null && p_multiplicity.length > 0)
			{
				this.lowerValue = p_multiplicity[0] as UmlModelValueSpecification;
				
				if (p_multiplicity.length > 1)
				{
					this.upperValue = p_multiplicity[1] as UmlModelValueSpecification;
				}
			}
		}
		
		public override function edit(newElement:IUmlModelElement):void
		{
			var newAssociationEnd:UmlModelAssociationEnd = null;
			
			if (newElement != null && (newElement is UmlModelAssociationEnd))
			{
				newAssociationEnd	= newElement as UmlModelAssociationEnd;
				
				this.lowerValue		= newAssociationEnd.lowerValue;
				this.upperValue		= newAssociationEnd.upperValue;
				
				this.setNavigable(newAssociationEnd.isNavigable());
				
//				this.name			= newAssociationEnd.name;
//				this.type			= newAssociationEnd.type;
//				this.visibility		= newAssociationEnd.visibility;
//				
//				var event:UmlEvent = new UmlEvent(UmlEvent.ELEMENT_EDITED);
//				event.setEditedNode(this);
//				dispatchEvent(event);
			}
			
			super.edit(newAssociationEnd);
		}
		
		public override function set $class(value:UmlModelClass):void
		{
			super.$class = value;
			updateNavigability();
		}
		
		public override function set association(value:UmlModelAssociation):void
		{
			super.association = value;
			updateNavigability();
		}
		
		private function updateNavigability():void
		{
			var isEndNavigable:Boolean = false;
			
			isEndNavigable = $class != null || association.navigableOwnedEnds.indexOf(this) >= 0;
			
			setNavigable(isEndNavigable);
		}
		
	}
	
}
