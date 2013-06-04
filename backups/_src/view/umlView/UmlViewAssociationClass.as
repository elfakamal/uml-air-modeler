package view.umlView
{
	import model.IUmlModelElement;
	
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	
	import view.core.UmlViewAssociationClassLine;
	import view.newView.UmlViewDiagram;
	import view.newView.associations.UmlViewAssociation;
	
	
	public class UmlViewAssociationClass extends UmlViewClass
	{
		
		/**
		 * 
		 * 
		 */
		private var _relativeAssociation			:UmlViewAssociation					= null;
		
		/**
		 * 
		 * 
		 */
		private var _associationClassLine			:UmlViewAssociationClassLine		= null;
		
		/**
		 * 
		 * 
		 */
		public function UmlViewAssociationClass(
										modelElement			:IUmlModelElement, 
										parentUID				:String, 
										relativeAssociation		:UmlViewAssociation = null)
		{
			super(modelElement,  parentUID);
			
			_relativeAssociation = relativeAssociation;
		}
		
		protected override function initListeners():void
		{
			super.initListeners();
		}
		
		/**
		 * 
		 * 
		 */
		protected override function onCreationComplete(e:FlexEvent):void
		{
			super.onCreationComplete(e);
			
			// TODO: here we can add the dashed line to the relative association.
			_associationClassLine = new UmlViewAssociationClassLine
			(
				this._parentUID, 
				(parent as UIComponent), 
				_relativeAssociation, 
				this
			);
			_relativeAssociation.setAssociationClassLine(_associationClassLine);
			(parent as UmlViewDiagram).addChildAt(_associationClassLine, 0);
		}
//		
//		/**
//		 * 
//		 * 
//		 */
//		public override function setAssociation(umlAssociation:UmlViewAssociation):void
//		{
//			super.setAssociation(umlAssociation);
//		}
		
	}
	
}