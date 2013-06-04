package model
{
	
	import controler.namespaces.creator;
	import controler.UmlControler;
	
	/**
	 * 
	 * @author kamal
	 * 
	 */
	public class UmlModelFactoryField
	{
		
		
		
		/**
		 * 
		 * @param name
		 * @param visibility
		 * @param type
		 * @return 
		 * 
		 */
		creator static function createConstant(
									name			:String, 
									visibility		:UmlModelVisibilityKind, 
									type			:IUmlModelType ):IUmlModelElement
		{
			var newConstant:UmlModelConstant = new UmlModelConstant
			(
				UmlControler.getInstance().getNewUniqueIdentifier(), 
				name, 
				visibility
			);
			
			newConstant.type = type;
			
			return newConstant;
		}
		
		
		/**
		 * 
		 * @param name
		 * @param visibility
		 * @param type
		 * @param isMember
		 * @return 
		 * 
		 */
		creator static function createAttribute(
									name			:String, 
									visibility		:UmlModelVisibilityKind, 
									type			:IUmlModelType):IUmlModelElement
		{
			var property:UmlModelProperty = new UmlModelProperty
			(
				UmlControler.getInstance().getNewUniqueIdentifier(), 
				name, 
				visibility
			);
			
			property.type = type;
			
			return property;
		}
		
		/**
		 * 
		 * @param name
		 * @param visibility
		 * @param type
		 * @param isMember
		 * @param parameters
		 * 
		 * @return 
		 */
		creator static function createOperation(
									name			:String, 
									visibility		:UmlModelVisibilityKind, 
									type			:IUmlModelType = null, 
									parameters		:Array = null):IUmlModelElement
		{
			var newOperation:UmlModelOperation = new UmlModelOperation
			(
				UmlControler.getInstance().getNewUniqueIdentifier(), 
				name,
				visibility
			);
			
			newOperation.type				= type;
			newOperation.ownedParameters	= parameters;
			
			return newOperation;
		}
		
		/**
		 * 
		 * @param name
		 * @param type
		 * @return 
		 * 
		 */
		creator static function createParameter(
									name			:String, 
									visibility		:UmlModelVisibilityKind, 
									type			:IUmlModelType):IUmlModelElement
		{
			var newParameter:UmlModelParameter = new UmlModelParameter
			(
				UmlControler.getInstance().getNewUniqueIdentifier(), 
				name,
				visibility
			);
			
			newParameter.type = type;
			
			return newParameter;
		}
		
		/**
		 * 
		 * @param name
		 * @param visibility
		 * @param type
		 * @return 
		 * 
		 */
		creator static function createAssociationEnd(
									name			:String, 
									visibility		:UmlModelVisibilityKind, 
									type			:IUmlModelType, 
									isNavigable		:Boolean = false, 
									multiplicity	:Array=null):IUmlModelElement
		{
			var newAssociationEnd:UmlModelAssociationEnd = new UmlModelAssociationEnd
			(
				UmlControler.getInstance().getNewUniqueIdentifier(), 
				name, 
				visibility, 
				isNavigable, 
				multiplicity
			);
			
			newAssociationEnd.type = type;
			
			return newAssociationEnd;
		}
		
		/**
		 * 
		 * @param name
		 * @param visibility
		 * @param type
		 * @return 
		 * 
		 */
		creator static function createSignalAttribute(
										name			:String, 
										visibility		:String, 
										type			:String ):IUmlModelElement
		{
			return new UmlModelSignalAttribute
			(
				UmlControler.getInstance().getNewUniqueIdentifier(), 
				name, 
				visibility, 
				type 
			);
		}
		
		/**
		 * 
		 * @param id
		 * @param name
		 * @param type
		 * @param value
		 * @return 
		 * 
		 */
		creator static function createEnumerationLiteral(
										name		:String, 
										type		:IUmlModelType, 
										value		:Object ):IUmlModelElement
		{
			return new UmlModelEnumerationLiteral
			(
				UmlControler.getInstance().getNewUniqueIdentifier(), 
				name
			);
		}
		
	}
	
}
