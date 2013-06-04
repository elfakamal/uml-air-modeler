package controler.events
{
	import flash.events.Event;
	
	import model.IUmlModelElement;
	
	import view.IUmlViewElement;
	import view.newView.UmlViewElement;
	
	
	/**
	 * 
	 * @author kamal
	 * 
	 */
	public class UmlEvent extends Event
	{
		
		public static const ADDED							:String			= "added";
		public static const DELETED							:String			= "deleted";
		public static const MOVED							:String			= "moved";
		
		
		public static const PROJECT_ADDED					:String			= "projectAdded";
		public static const DIAGRAM_ADDED					:String			= "diagramAdded";
		
		public static const CLASSIFIER_ADDED				:String			= "classifierAdded";
		
		public static const CLASS_ADDED						:String			= "classAdded";
		public static const INTERFACE_ADDED					:String			= "interfaceAdded";
		
		public static const OPERATION_ADDED					:String			= "functionAdded";
		public static const CONSTRUCTOR_ADDED				:String			= "constructorAdded";
		
		public static const ATTRIBUTE_ADDED					:String			= "attributeAdded";
		public static const CONSTANT_ADDED					:String			= "constantAdded";
		public static const PARAMETER_ADDED					:String			= "parameterAdded";
		
		public static const PACKAGE_ADDED					:String			= "packageAdded";
		public static const DATA_TYPE_ADDED					:String			= "dataTypeAdded";
		public static const OBJECT_ADDED					:String			= "objectAdded";
		public static const SIGNAL_ADDED					:String			= "signalAdded";
		public static const SIGNAL_ATTRIBUTE_ADDED			:String			= "signalAttributeAdded";
		public static const ENUMERATION_ADDED				:String			= "enumerationAdded";
		public static const ENUMERATION_LITERAL_ADDED		:String			= "signalAttributeAdded";
		public static const ARTIFACT_ADDED					:String			= "artifactAdded";
		public static const NOTE_ADDED						:String			= "noteAdded";
		public static const COMMENT_ADDED					:String			= "commentAdded";
		public static const CONSTRAINT_ADDED				:String			= "constraintAdded";
		
		
		
		public static const VIEW_CLASS_READY				:String			= "viewClassReady";
		public static const VIEW_ASSOCIATION_CLASS_READY	:String			= "viewAssociationClassReady";
		public static const VIEW_INTERFACE_READY			:String			= "viewInterfaceReady";
		public static const VIEW_ASSOCIATION_READY			:String			= "viewAssociationReady";
		public static const VIEW_FUNCTION_READY				:String			= "viewFunctionReady";
		public static const VIEW_ATTRIBUTE_READY			:String			= "viewAttributeReady";
		
		public static const VIEW_REGULAR_NODE_FORM_READY	:String			= "viewFieldFormReady";
		public static const VIEW_FIELD_FORM_READY			:String			= "viewFieldFormReady";
		
		public static const PICKER_ADD_ASSOCIATION			:String			= "pickerAddAssociation";
		
		public static const ELEMENT_ADDED					:String			= "elementAdded";
		public static const ELEMENT_EDITED					:String			= "nodeEdited";
		public static const ELEMENT_DELETED					:String			= "nodeDeleted";
		public static const ELEMENT_SELECTED					:String			= "nodeSelected";
		public static const ELEMENT_DESELECTED					:String			= "nodeDeselected";
		
		public static const SELECT_ALL_REQUESTED			:String			= "selectAll";
		
		public static const UML_ACTION_CANCELED				:String			= "umlActionCanceled";
		
		////////////////////////////////////////////////////
		
		
		protected var _addedElement					:IUmlModelElement	= null;
		protected var _editedNode					:IUmlModelElement	= null;
		protected var _deletedNode					:IUmlModelElement	= null;
		
		protected var _addedNodeType				:String			= "";
		
		private var _addedProject					:XML			= null;
		private var _addedDiagram					:XML			= null;
		
		private var _addedClassifier				:XML			= null;
		private var _addedClass						:XML			= null;
		private var _addedInterface					:XML			= null;
		
		private var _addedFunction					:XML			= null;
		private var _addedConstructor				:XML			= null;
		
		private var _addedAttribute					:XML			= null;
		private var _addedConstant					:XML			= null;
		private var _addedParameter					:XML			= null;
		
		
		protected var _addedPackage					:XML			= null;
		protected var _addedDataType				:XML			= null;
		protected var _addedObject					:XML			= null;
		protected var _addedSignal					:XML			= null;
		protected var _addedSignalAttribute			:XML			= null;
		protected var _addedEnumeration				:XML			= null;
		protected var _addedEnumerationLiteral		:XML			= null;
		protected var _addedArtifact				:XML			= null;
		protected var _addedNote					:XML			= null;
		protected var _addedComment					:XML			= null;
		protected var _addedConstraint				:XML			= null;
		
		
		private var _selectedNode					:IUmlViewElement	= null;
		private var _deselectedNode					:IUmlViewElement	= null;
		
		protected var _firstSide					:UmlViewElement		= null;
		
		private var _associationCreationClass		:Class				= null;
		
		
		/**
		 * 
		 * @param type
		 * @param bubbles
		 * @param cancelable
		 * 
		 */
		public function UmlEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		
		
		public function getAddedElement():IUmlModelElement
		{
			return _addedElement;
		}
		public function setAddedElement(value:IUmlModelElement):void
		{
			_addedElement = value;
		}
		
		public function getAddedElementType():String
		{
			return _addedNodeType;
		}
		public function setAddedElementType(value:String):void
		{
			_addedNodeType = value;
		}
		
		////////////////////////////////////
		
		public function getAddedProject():XML
		{
			return _addedProject;
		}
		public function setAddedProject(value:XML):void
		{
			_addedProject = value;
		}
		
		public function getAddedDiagram():XML
		{
			return _addedDiagram;
		}
		public function setAddedDiagram(value:XML):void
		{
			_addedDiagram = value;
		}
		
		////////////////////////////////////
		public function getAddedClassifier():XML
		{
			return _addedClassifier;
		}
		public function setAddedClassifier(value:XML):void
		{
			_addedClassifier = value;
		}

		public function getAddedClass():XML
		{
			return _addedClass;
		}
		public function setAddedClass(value:XML):void
		{
			_addedClass = value;
		}
		
		public function getAddedInterface():XML
		{
			return _addedInterface;
		}
		public function setAddedInterface(value:XML):void
		{
			_addedInterface = value;
		}
		
		////////////////////////////////////
		public function getAddedFunction():XML
		{
			return _addedFunction;
		}
		public function setAddedFunction(value:XML):void
		{
			_addedFunction = value;
		}
		
		public function getAddedConstructor():XML
		{
			return _addedConstructor;
		}
		public function setAddedConstructor(value:XML):void
		{
			_addedConstructor = value;
		}
		
		////////////////////////////////////
		public function getAddedAttribute():XML
		{
			return _addedAttribute;
		}
		public function setAddedAttribute(value:XML):void
		{
			_addedAttribute = value;
		}
		
		public function getAddedConstant():XML
		{
			return _addedConstant;
		}
		public function setAddedConstant(value:XML):void
		{
			_addedConstant = value;
		}
		
		public function getAddedParameter():XML
		{
			return _addedParameter;
		}
		public function setAddedParameter(value:XML):void
		{
			_addedParameter = value;
		}
		
		public function setAddedPackage(umlPackage:XML):void
		{
			_addedPackage = umlPackage;
		}
		public function getAddedPackage():XML
		{
			return _addedPackage;
		}
		
		public function setAddedDataType(dataType:XML):void
		{
			_addedDataType = dataType;
		}
		public function getAddedDataType():XML
		{
			return _addedDataType;
		}
		
		public function setAddedObject(object:XML):void
		{
			_addedObject = object;
		}
		public function getAddedObject():XML
		{
			return _addedObject;
		}
		
		public function setAddedSignal(signal:XML):void
		{
			_addedSignal = signal;
		}
		public function getAddedSignal():XML
		{
			return _addedSignal;
		}
		
		public function setAddedSignalAttribute(attribute:XML):void
		{
			_addedSignalAttribute = attribute;
		}
		public function getAddedSignalAttribute():XML
		{
			return _addedSignalAttribute;
		}
		
		public function setAddedEnumeration(enumeration:XML):void
		{
			_addedEnumeration = enumeration;
		}
		public function getAddedEnumeration():XML
		{
			return _addedEnumeration;
		}
		
		public function setAddedEnumerationLiteral(enumerationLiteral:XML):void
		{
			_addedEnumerationLiteral = enumerationLiteral;
		}
		public function getAddedEnumerationLiteral():XML
		{
			return _addedEnumerationLiteral;
		}
		
		public function setAddedArtifact(artifact:XML):void
		{
			_addedArtifact= artifact;
		}
		public function getAddedArtifact():XML
		{
			return _addedArtifact;
		}
		
		public function setAddedNote(note:XML):void
		{
			_addedNote = note;
		}
		public function getAddedNote():XML
		{
			return _addedNote;
		}
		
		public function setAddedComment(comment:XML):void
		{
			_addedComment = comment;
		}
		public function getAddedComment():XML
		{
			return _addedComment;
		}
		
		public function setAddedConstraint(constraint:XML):void
		{
			_addedConstraint = constraint;
		}
		public function getAddedConstraint():XML
		{
			return _addedConstraint;
		}
		
		
		/////////////////////////////////////
		public function getSelectedElement():IUmlViewElement
		{
			return _selectedNode;
		}
		public function setSelectedElement(value:IUmlViewElement):void
		{
			_selectedNode = value;
		}
		
		public function getDeselectedElement():IUmlViewElement
		{
			return _deselectedNode;
		}
		public function setDeselectedElement(value:IUmlViewElement):void
		{
			_deselectedNode = value;
		}
		
		public function getEditedNode():IUmlModelElement
		{
			return _editedNode;
		}
		public function setEditedNode(value:IUmlModelElement):void
		{
			_editedNode = value;
		}
		
		public function getDeletedNode():IUmlModelElement
		{
			return _deletedNode;
		}
		public function setDeletedNode(value:IUmlModelElement):void
		{
			_deletedNode = value;
		}
		
		public function getFirstSide():UmlViewElement
		{
			return _firstSide;
		}
		public function setFirstSide(side:UmlViewElement):void
		{
			_firstSide = side;
		}
		
		public function setAssociationCreationClass(value:Class):void
		{
			_associationCreationClass = value;
		}
		public function getAssociationCreationClass():Class
		{
			return _associationCreationClass;
		}
		
	}
	
}
