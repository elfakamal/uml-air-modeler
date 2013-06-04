package model
{
	import controler.UmlControler;
	import controler.namespaces.creator;
	
	/**
	 * 
	 * @author kamal
	 * 
	 */
	public class UmlModelFactoryNode
	{
		
		/**
		 * 
		 * @param name
		 * @param visibility
		 * 
		 * @return 
		 * 
		 */
		creator static function createClass(
									name			:String, 
									visibility		:UmlModelVisibilityKind = null,  
									isAbstract		:Boolean = false, 
									isFinal			:Boolean = false):IUmlModelClassifier
		{
			var newClass:UmlModelClass = new UmlModelClass
			(
				UmlControler.getInstance().getNewUniqueIdentifier(), 
				name, 
				visibility 
			);
			
			newClass.isAbstract	= isAbstract;
			newClass.isLeaf		= isFinal;
			
			return newClass;
		}
		
		/**
		 * 
		 * @param name
		 * @param relativeAssociationId
		 * @return 
		 * 
		 */
		creator static function createAssociationClass(
										name					:String, 
										relativeAssociationId	:int
									):IUmlModelClassifier
		{
			return new UmlModelAssociationClass
			(
				UmlControler.getInstance().getNewUniqueIdentifier(), 
				name,
				relativeAssociationId
			);
		}
		
		/**
		 * 
		 * @param name
		 * @param visibility
		 * @param extendedNodes
		 * @param functionsList
		 * @return 
		 * 
		 */
		creator static function createInterface(
								name			:String, 
								visibility		:UmlModelVisibilityKind = null,  
								isAbstract		:Boolean = false, 
								isFinal			:Boolean = false):IUmlModelClassifier
		{
			var newInterface:UmlModelInterface = new UmlModelInterface
			(
				UmlControler.getInstance().getNewUniqueIdentifier(), 
				name
			);
			
			newInterface.isAbstract = isAbstract;
			newInterface.isLeaf		= isFinal;
			
			return newInterface;
		}
		
		/**
		 * 
		 * @param name
		 * @param nodes
		 * @return 
		 * 
		 */
		creator static function createAssociation(name:String, elements:Array):IUmlModelElement
		{
			var newAssociation:UmlModelAssociation = null;
			var newId:String = UmlControler.getInstance().getNewUniqueIdentifier();
			
			if (name == "")
			{
				name = "NewAssociation";
			}
			
			newAssociation = new UmlModelAssociation(newId, name, elements);
			
			return newAssociation;
		}
		
		/**
		 * 
		 * @param name
		 * @return 
		 * 
		 */
		creator static function createSignal(name:String=""):IUmlModelElement
		{
			var newId:String = UmlControler.getInstance().getNewUniqueIdentifier();
			if (name == "")
			{
				name = "Signal" + String(newId);
			}
			return new UmlModelSignal(newId, name);
		}
		
		/**
		 * 
		 * @param name
		 * @return 
		 * 
		 */
		creator static function createEnumeration(name:String=""):IUmlModelElement
		{
			var newId:String = UmlControler.getInstance().getNewUniqueIdentifier();
			if (name == "")
			{
				name = "Enumeration" + String(newId);
			}
			return new UmlModelEnumeration(newId, name);
		}
		
		/**
		 * 
		 * @param name
		 * @return 
		 * 
		 */
		creator static function createObject(name:String=""):IUmlModelElement
		{
			var newId:String = UmlControler.getInstance().getNewUniqueIdentifier();
			if (name == "")
			{
				name = "Object" + String(newId);
			}
			return new UmlModelObject(newId, name);
		}
		
		/**
		 * 
		 * @param name
		 * @return 
		 * 
		 */
		creator static function createDataType(name:String=""):IUmlModelElement
		{
			var newId:String = UmlControler.getInstance().getNewUniqueIdentifier();
			if (name == "")
			{
				name = "DataType" + String(newId);
			}
			return new UmlModelDataType(newId, name);
		}
		
		/**
		 * 
		 * @param name
		 * @return 
		 * 
		 */
		creator static function createArtifact(name:String=""):IUmlModelElement
		{
			var newId:String = UmlControler.getInstance().getNewUniqueIdentifier();
			if (name == "")
			{
				name = "Artifact" + String(newId);
			}
			return new UmlModelArtifact(newId, name);
		}
		
		/**
		 * 
		 * @param name
		 * @param content
		 * @return 
		 * 
		 */
		creator static function createNote(name:String="", content:String=""):IUmlModelElement
		{
			var newId:String = UmlControler.getInstance().getNewUniqueIdentifier();
			if (name == "")
			{
				name = "Note" + String(newId);
			}
			return new UmlModelNote(newId, name, content);
		}
		
		/**
		 * 
		 * @param name
		 * @param content
		 * @return 
		 * 
		 */
		creator static function createComment(name:String="", content:String=""):IUmlModelElement
		{
			var newId:String = UmlControler.getInstance().getNewUniqueIdentifier();
			if (name == "")
			{
				name = "Comment" + String(newId);
			}
			return null;//new UmlModelComment(newId);//, name, content);
		}
		
		/**
		 * 
		 * @param name
		 * @param content
		 * @return 
		 * 
		 */
		creator static function createConstraint(name:String="", content:String=""):IUmlModelElement
		{
			var newId:String = UmlControler.getInstance().getNewUniqueIdentifier();
			if (name == "")
			{
				name = "Constraint" + String(newId);
			}
			return new UmlModelConstraint(newId, name);
		}
		
		
		creator static function createPrimitiveType(name:String):IUmlModelType
		{
			if (name == "")
			{
				return null
			}
			
			var newId:String = UmlControler.getInstance().getNewUniqueIdentifier();
			return new UmlModelPrimitiveType(newId, name, UmlModelVisibilityKind.$public);
		}
		
	}
	
}
