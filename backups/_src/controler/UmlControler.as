package controler
{
	import controler.namespaces.creator;
	import controler.namespaces.model;
	import controler.namespaces.selector;
	
	import flash.errors.IllegalOperationError;
	import flash.events.EventDispatcher;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	import model.IUmlModelAssociation;
	import model.IUmlModelClassifier;
	import model.IUmlModelElement;
	import model.IUmlModelMultiplicityElement;
	import model.IUmlModelType;
	import model.UmlModel;
	import model.UmlModelFactoryField;
	import model.UmlModelFactoryMetaContainer;
	import model.UmlModelFactoryNode;
	import model.UmlModelLiteralInteger;
	import model.UmlModelLiteralUnlimitedNatural;
	import model.UmlModelValueSpecification;
	import model.UmlModelVisibilityKind;
	
	import mx.collections.ArrayCollection;
	import mx.core.Application;
	import mx.utils.UIDUtil;
	
	import view.IUmlViewElement;
	import view.newView.UmlViewDiagram;
	import view.newView.UmlViewProjectWorkspace;
	import view.panels.UmlViewInterfaceForm;
	
	/**
	 * 
	 * @author kamal
	 * 
	 */
	public class UmlControler extends EventDispatcher 
	{
		
		/**
		 * utilisé quand on veut créer un élément.
		 */
		use namespace creator;
		
		/**
		 * utilisé quand on veut ajouter un élément.
		 */
		use namespace model;
		
		/**
		 * utilisé quand on veut séléctionner un élément.
		 */
		use namespace selector;
		
		/**
		 * 
		 */
		private static var _instance				:UmlControler	= null;
		private static var _isCreationAllowed		:Boolean		= false;
		
		
		/**
		 * behavioural mode of the application, by default it's set as "normal"
		 * it can also be set as "association".
		 */
		private static var _mode					:String			= "normal";
		
		/**
		 * not yet implemented
		 */
		protected var _isSelectedInTree				:Boolean		= false;
		
		
		public function UmlControler()
		{
			if (!_isCreationAllowed)
			{
				throw new IllegalOperationError("UmlControler is a singleton");
			}
		}
		
		public static function getInstance():UmlControler
		{
			if(_instance)
			{
				return _instance;
			}
			else
			{
				_isCreationAllowed	= true;
				_instance			= new UmlControler();
				_isCreationAllowed	= false;
				
				return _instance;
			}
		}
		
		/**
		 * cette fonction doit créer tous les objets nécéssaires au démarrage 
		 * de l'application (les écouteurs, la vue (pas du model), ...)
		 */
		public function startUpApplication():void
		{
			// init all stuffs
			initListeners();
			initView();
			
			// actually for tests
			initObjects();
		}
		
		public function listenToKeyboard():void
		{
			Application.application.setFocus();
		}
		
		private function initListeners():void
		{
			Application.application.addEventListener(KeyboardEvent.KEY_DOWN, handleKeyboardEvent);
			Application.application.addEventListener(KeyboardEvent.KEY_UP, onApplicationKeyUp);
		}
		
		private function initView():void
		{
			
		}
		
		private function initObjects():void
		{
			
//			
//			var att1:IUmlModelElement = UmlModelFieldFactory.createAttribute("name", "private", "String");
//			var att2:IUmlModelElement = UmlModelFieldFactory.createAttribute("age", "private", "Number");
//			
//			var function1:IUmlModelElement = UmlModelFieldFactory.createFunction("eat", "public", "void");
//			
//			var param1:IUmlModelElement= UmlModelFieldFactory.createParameter("sth", "String");
//			
//			var function2:IUmlModelElement = UmlModelFieldFactory.createFunction("drink", "public", "void");
//			function2.addElement(param1);
//			
//			var class1:IUmlModelElement = UmlModelNodeFactory.createClass("Person", "public");
//			
//			class1.addElement(att1);
//			class1.addElement(att2);
//			
//			class1.addElement(function1);
//			class1.addElement(function2);
//			
//			var umlDiagram:IUmlModelElement = UmlModelMetaContainerFactory.createDiagram("diagramNatif");
//			umlDiagram.addElement(class1);
//			
//			
//			var umlProject:IUmlModelElement = UmlModelMetaContainerFactory.createProject("un projet", "un emplacement");
//			UmlModel.getInstance().addElement(umlProject);
//			umlProject.addElement(umlDiagram);
//			
//			UmlModel.getInstance().addChildToElement(class1.uid, UmlModelFieldFactory.createFunction("courir", "public", "Number"));
//			
//			var interface1:IUmlModelElement = UmlModelNodeFactory.createInterface("uneInterface", "public");
//			umlDiagram.addElement(interface1);
//			class1.addElement(interface1);
//			
//			var interface2:IUmlModelElement = UmlModelNodeFactory.createInterface("uneInterface2", "public");
//			umlDiagram.addElement(interface2);
//			class1.addElement(interface2);
//			
//			trace(umlProject.xml.toXMLString());
//			
//			trace("____ suppresion ...");
//			
//			removeNode(class1.uid, function2.uid);
//			trace(umlDiagram.xml.toXMLString());
//			
			//trace("_________________________ \n" + getNodeById(4, UmlModel.getInstance().getAllNodes()).xml.toXMLString());
			
			
		}
		
		/**
		 * 
		 * cette méthode permettra d'effectuer les opération qui se font sur des 
		 * nodes sans avoir à tester leur type, à savoir DELETE, SELECT ALL, ... 
		 * si on veut effectuer un traitement nécessitant la reconnaissance 
		 * du type du node on doit l'implémenter dans le node concerné, 
		 * ou dans le node qui le contient.
		 * 
		 * @param event
		 * 
		 */
		public function handleKeyboardEvent(event:KeyboardEvent):void
		{
			if (event.keyCode == Keyboard.DELETE)
			{
				deleteNodes();
			}
			else if (event.keyCode == Keyboard.A && event.ctrlKey)
			{
				getSelectedDiagram().selectAllNodes();
			}
		}
		
		public function doesApplicationHasListener(eventType:String):Boolean
		{
			return Application.application.hasEventListener(eventType);
		}
		
		public function addListenerToApplication(eventType:String, listener:Function):void
		{
			Application.application.addEventListener(eventType, listener);
		}
		
		public function removeListenerFromApplication(eventType:String, listener:Function):void
		{
			Application.application.removeEventListener(eventType, listener);
		}
		
		protected function deleteNodes():void
		{
			var selectedNodes:Array = null;
			
			if (
					UmlSelectionControler.getInstance().getSelectedAttributes().length > 0 || 
					UmlSelectionControler.getInstance().getSelectedOperation().length > 0
				)
			{
				selectedNodes = new Array();
				selectedNodes = selectedNodes.concat(
					UmlSelectionControler.getInstance().getSelectedAttributes(), 
					UmlSelectionControler.getInstance().getSelectedOperation()
				);
			}
			else if (
						UmlSelectionControler.getInstance().getSelectedClasses().length > 0 || 
						UmlSelectionControler.getInstance().getSelectedInterfaces().length > 0 || 
						UmlSelectionControler.getInstance().getSelectedAssociations().length > 0 
					)
			{
				selectedNodes = new Array();
				selectedNodes = selectedNodes.concat(
					UmlSelectionControler.getInstance().getSelectedClasses(),  
					UmlSelectionControler.getInstance().getSelectedInterfaces(),  
					UmlSelectionControler.getInstance().getSelectedAssociations()
				);
			}
			else if (UmlSelectionControler.getInstance().getSelectedDiagrams().length > 0 && _isSelectedInTree)
			{
				selectedNodes = UmlSelectionControler.getInstance().getSelectedDiagrams();
			}
			
			// test if we have already initialize the array
			if (selectedNodes != null)
			{
				for (var i:uint = 0; i < selectedNodes.length; i++)
				{
					removeNode
					(
						(selectedNodes[i] as IUmlViewElement).getParentId(), 
						(selectedNodes[i] as IUmlViewElement).uid
					);
				}
			}
		}
		
		protected function onApplicationKeyUp(e:KeyboardEvent):void
		{
			
		}
		
		public function shutDownApplication():void
		{
			
		}
		
		/**
		 * 
		 * @param name
		 * @param location
		 * 
		 */
		public function addProjet(name:String, location:String):void
		{
			var project:IUmlModelElement = UmlModelFactoryMetaContainer.createProject(name, location);
			UmlModel.getInstance().addElement(project);
		}
		
		/**
		 * 
		 * @param name
		 * 
		 */
		public function addDiagram(name:String):void
		{
			var diagram:IUmlModelElement = UmlModelFactoryMetaContainer.createDiagram(name);
			UmlModel.getInstance().addElement(diagram);
		}
		
		/**
		 * 
		 * @param parentUID
		 * @param name
		 * 
		 */
		public function addPackage(parentUID:uint, name:String):void
		{
			
		}
		
		/**
		 * 
		 * @param umlAssociationId
		 * 
		 */
		public function addAssociationClass(umlAssociationId:int):void
		{
			var newClassEmpty:IUmlModelElement;
			newClassEmpty = UmlModelFactoryNode.createAssociationClass("NewAssociationClass", umlAssociationId);
			
			UmlModel.getInstance().addChildToElement
			(
				UmlModel.getInstance().getSelectedProject().selectedNode.uid,
				newClassEmpty
			);
		}
		
		public function addClass():void
		{
			var newClass:IUmlModelClassifier = null;
			
			newClass = UmlModelFactoryNode.createClass
			(
				"NewClass", 
				UmlModelVisibilityKind.getVisibilityByName("public")
			);
			
			UmlModel.getInstance().addChildToElement
			(
				UmlModel.getInstance().getSelectedProject().selectedNode.uid,
				newClass
			);
			
			UmlModel.getInstance().model::addType(newClass);
		}
		
		/**
		 * 
		 * @param parentUID
		 * @param id
		 * @param name
		 * @param visibility
		 * @param extendedNode
		 * @param implementedInterfaces
		 * @param constantsList
		 * @param attributesList
		 * @param functionsList
		 * 
		 */
		public function editClass(
							parentUID			:String, 
							id					:String, 
							name				:String, 
							visibility			:String = "public", 
							isAbstract			:Boolean = false, 
							isFinal				:Boolean = false):void
		{
			var oldClass		:IUmlModelElement;
			var newClass		:IUmlModelElement;
			
			oldClass	= getNodeById(id, UmlModel.getInstance().ownedElements);
			newClass	= UmlModelFactoryNode.createClass
			(
				name, 
				UmlModelVisibilityKind.getVisibilityByName(visibility)
			);
			
			if (UmlValidationControler.getInstance().isClassValid())
			{
				oldClass.edit(newClass);
			}
		}
		
		/**
		 * 
		 * @param viewInterfaceForm
		 * 
		 */
		public function addInterface(viewInterfaceForm:UmlViewInterfaceForm=null):void
		{
			if (viewInterfaceForm)
			{
				
			}
		}
		
		/**
		 * 
		 * the types array takes real elements, i mean IUmlModelNode.
		 * and thus the UmlModelAssociation can extract their IDs
		 * and add them to the association.
		 * 
		 * @param name
		 * @param nodes
		 * 
		 */
		public function addAssociation(name:String, types:Array):void
		{
			if (UmlValidationControler.getInstance().isAssociationValid())
			{
				var modelAssociation:IUmlModelElement = UmlModelFactoryNode.createAssociation(name, types);
				
				UmlModel.getInstance().addChildToElement
				(
					UmlModel.getInstance().getSelectedProject().selectedNode.uid, 
					modelAssociation
				);
			}
		}
		
		public function editAssociation(
									parentUID	:String, 
									id			:String, 
									name		:String):void
		{
			var oldAssociation		:IUmlModelAssociation = null;
			var newAssociation		:IUmlModelAssociation = null;
			
			oldAssociation = getNodeById
			(
				id, 
				UmlModel.getInstance().ownedElements
			) as IUmlModelAssociation;
			
			if (oldAssociation != null)
			{
				newAssociation = UmlModelFactoryNode.createAssociation
				(
					name, 
					oldAssociation.ownedEnds
				) as IUmlModelAssociation;
				
				if (UmlValidationControler.getInstance().isAssociationValid())
				{
					oldAssociation.edit(newAssociation);
				}
			}
			else
			{
				trace("the association that you want to edit is NULL");
			}
		}
		
		/**
		 * 
		 * @param parentUID
		 * @param name
		 * @param visibility
		 * @param type
		 * 
		 */
		public function addConstant(
								parentUID		:String, 
								name			:String		= "UNNAMED", 
								visibility		:String		= "public", 
								type			:String		= "int" ):void
		{
			if (UmlValidationControler.getInstance().isAttributeValid())
			{
				name.toUpperCase();
				
				var umlConstant	:IUmlModelElement = null;
				var typeUID		:String = UmlModel.getInstance().getTypeUID(type);
				
				umlConstant = UmlModelFactoryField.createConstant
				(
					name, 
					UmlModelVisibilityKind.getVisibilityByName(visibility), 
					getTypeByUID(typeUID)
				);
				
				UmlModel.getInstance().addChildToElement(parentUID, umlConstant);
			}
		}
		
		public function createMultiplicity(
								lower	:UmlModelValueSpecification, 
								upper	:UmlModelValueSpecification):Array
		{
			return [lower, upper];
		}
		
		/**
		 * 
		 * @param parentUID
		 * @param name
		 * @param visibility
		 * @param type
		 * @param isMember
		 * 
		 */
		public function addAttribute(
							parentUID		:String, 
							name			:String		= "unnamed", 
							visibility		:String		= "public", 
							type			:String		= "int" ):void
		{
			if (UmlValidationControler.getInstance().isAttributeValid())
			{
				var umlAttribute:IUmlModelElement = null;
				var typeUID:String = UmlModel.getInstance().getTypeUID(type);
				
				umlAttribute = UmlModelFactoryField.createAttribute
				(
					name, 
					UmlModelVisibilityKind.getVisibilityByName(visibility), 
					getTypeByUID(typeUID)
				);
				
				UmlModel.getInstance().addChildToElement(parentUID, umlAttribute);
			}
		}
		
		/**
		 * 
		 * @param parentUID
		 * @param id
		 * @param name
		 * @param visibility
		 * @param type
		 * @param isMember
		 * 
		 */
		public function editAttribute(
							parentUID		:String, 
							id				:String, 
							name			:String, 
							visibility		:String		= "", 
							type			:String		= "" ):void
		{
			
			var property:IUmlModelElement = getNodeById
			(
				id, 
				UmlModel.getInstance().ownedElements
			);
			
			var newAttribute:IUmlModelElement = null;
			var typeUID:String = UmlModel.getInstance().getTypeUID(type);
			
			newAttribute = UmlModelFactoryField.createAttribute
			(
				name, 
				UmlModelVisibilityKind.getVisibilityByName(visibility), 
				getTypeByUID(typeUID)
			);
			
			property.edit(newAttribute);
		}
		
		/**
		 * 
		 * @param parentUID
		 * @param name
		 * @param visibility
		 * @param type
		 * @param isMember
		 * @param parametersList
		 * 
		 */
		public function addOperation(
								parentUID			:String, 
								name				:String		= "unnamed", 
								visibility			:String		= "public", 
								type				:String		= "void", 
								parametersList		:Array		= null ):void
		{
			if (UmlValidationControler.getInstance().isOperationValid())
			{
				var umlOperation:IUmlModelElement = null;
				var typeUID:String = UmlModel.getInstance().getTypeUID(type);
				
				umlOperation = UmlModelFactoryField.createOperation
				(
					name, 
					UmlModelVisibilityKind.getVisibilityByName(visibility), 
					getTypeByUID(typeUID), 
					parametersList
				);
				
				UmlModel.getInstance().addChildToElement(parentUID, umlOperation);
			}
		}
		
		/**
		 * 
		 * @param parentUID
		 * @param id
		 * @param name
		 * @param visibility
		 * @param type
		 * @param isMember
		 * @param parameters
		 * 
		 */
		public function editFunction(
								parentUID			:String, 
								id					:String, 
								name				:String		= "", 
								visibility			:String		= "", 
								type				:String		= "", 
								parameters			:Array		= null ):void
		{
			var oldOperation:IUmlModelElement = getNodeById
			(
				id, 
				UmlModel.getInstance().ownedElements
			);
			
			var typeUID:String = UmlModel.getInstance().getTypeUID(type);
			
			var newOperation:IUmlModelElement = UmlModelFactoryField.createOperation
			(
				name, 
				UmlModelVisibilityKind.getVisibilityByName(visibility), 
				getTypeByUID(typeUID), 
				parameters 
			);
			
			oldOperation.edit(newOperation);
		}
		
		/**
		 * 
		 * @param parentUID
		 * @param name
		 * 
		 */
		public function addEnumeration(parentUID:String, name:String=""):void
		{
			var parentNode:IUmlModelElement = getNodeById(parentUID, UmlModel.getInstance().ownedElements);
			var newEnumeration:IUmlModelElement = UmlModelFactoryNode.createEnumeration(name);
			
			parentNode.addElement(newEnumeration);
		}
		
		/**
		 * 
		 * @param parentUID
		 * @param name
		 * @param value
		 * 
		 */
		public function addEnumerationLiteral(
								parentUID			:String, 
								name				:String		= "", 
								type				:String		= "", 
								value				:Object		= null):void
		{
			if (UmlValidationControler.getInstance().isEnumerationLiteralValid())
			{
				var umlEnumerationLiteral:IUmlModelElement;
				var typeUID:String = UmlModel.getInstance().getTypeUID(type);
				
				umlEnumerationLiteral = UmlModelFactoryField.createEnumerationLiteral
				(
					name, 
					getTypeByUID(typeUID), 
					value
				);
				
				UmlModel.getInstance().addChildToElement(parentUID, umlEnumerationLiteral);
			}
		}
		
		/**
		 * 
		 * @param name
		 * 
		 */
		public function addSignal(parentUID:String, name:String=""):void
		{
			var umlSignal:IUmlModelElement;
			umlSignal = UmlModelFactoryNode.createSignal(name);
			UmlModel.getInstance().addChildToElement(parentUID, umlSignal);
		}
		
		/**
		 * 
		 * @param parentUID
		 * @param name
		 * @param type
		 * @param value
		 * 
		 */
		public function addSignalAttribute(
								parentUID			:String, 
								name				:String		= "", 
								visibility			:String		= "", 
								type				:String		= ""):void
		{
			var umlSignalAttribute:IUmlModelElement = null;
			umlSignalAttribute = UmlModelFactoryField.createSignalAttribute(name, visibility, type);
			UmlModel.getInstance().addChildToElement(parentUID, umlSignalAttribute);
		}
		
		/**
		 * 
		 * @param parentUID
		 * @param name
		 * @param type
		 * 
		 */
		public function addParemeter(
								parentUID			:String, 
								name				:String		= "", 
								visibility			:String		= "", 
								type				:String		= ""):void
		{
			if (UmlValidationControler.getInstance().isAttributeValid())
			{
				var umlParameter:IUmlModelElement = null;
				umlParameter = UmlModelFactoryField.createParameter
				(
					name, 
					UmlModelVisibilityKind.getVisibilityByName(visibility), 
					getTypeByUID(type)
				);
				
				UmlModel.getInstance().addChildToElement(parentUID, umlParameter);
			}
		}
		
		/**
		 * 
		 * @param parentUID
		 * @param name
		 * @param visibility
		 * @param type
		 * 
		 */
		public function addAssociationEnd(
								parentUID			:String, 
								name				:String		= "", 
								visibility			:String		= "", 
								typeUID				:String		= "", 
								isNavigable			:Boolean	= false, 
								multiplicity		:Array		= null):void
		{
			if (UmlValidationControler.getInstance().isAttributeValid())
			{
				var associationEnd:IUmlModelElement = null;
				associationEnd = UmlModelFactoryField.createAssociationEnd
				(
					name, 
					UmlModelVisibilityKind.getVisibilityByName(visibility), 
					getTypeByUID(typeUID), 
					isNavigable, 
					multiplicity
				);
				
				UmlModel.getInstance().addChildToElement(parentUID, associationEnd);
			}
		}
		
		public function editAssociationEnd(
								id					:String, 
								name				:String		= "", 
								visibility			:String		= "", 
								type				:String		= "", 
								isNavigable			:Boolean	= false, 
								multiplicity		:Array		= null):void
		{
			var oldAssociationEnd	:IUmlModelElement	= null
			var typeUID				:String				= "";
			var newAssociationEnd	:IUmlModelElement	= null;
			
			oldAssociationEnd = getNodeById(id, UmlModel.getInstance().ownedElements);
			typeUID = UmlModel.getInstance().getTypeUID(type);
			
			newAssociationEnd = UmlModelFactoryField.createAssociationEnd
			(
				name, 
				UmlModelVisibilityKind.getVisibilityByName(visibility), 
				getTypeByUID(typeUID), 
				isNavigable, 
				multiplicity
			);
			
			oldAssociationEnd.edit(newAssociationEnd);
		}
		
		/**
		 * 
		 * @param parentUID
		 * @param childId
		 * 
		 */
		public function removeNode(parentUID:String, childUID:String):void
		{
			var parentElement	:IUmlModelElement	= null;
			var childElement	:IUmlModelElement	= null;
			
			parentElement	= getNodeById(parentUID, UmlModel.getInstance().ownedElements);
			childElement	= getNodeById(childUID, parentElement.ownedElements);
			
			if (childElement is IUmlModelType)
			{
				UmlModel.getInstance().model::removeTypeByUID(childElement.uid);
			}
			
			if (parentElement != null && childElement != null)
			{
				parentElement.removeElement(childElement);
			}
		}
		
		/**
		 * 
		 * @param collection
		 * @param type
		 * @return 
		 * 
		 */
		public function convertToNodesArray(collection:ArrayCollection, type:String):Array
		{
			if (collection == null)
			{
				return null;
			}
			
			var nodesArray:Array = new Array();
			
			switch (true)
			{
				case type == UmlModel.ATTRIBUTE:
					
					for (var i:int = 0; i < collection.length; i++)
					{
						var attribute:IUmlModelElement = UmlModelFactoryField.createAttribute
						(
							(collection.getItemAt(i) as Object).name, 
							(collection.getItemAt(i) as Object).visibility, 
							(collection.getItemAt(i) as Object).type
						);
						nodesArray.push(attribute);
					}
					break;
				case type == UmlModel.OPERATION:
					
					for (i = 0; i < collection.length; i++)
					{
						var fonction:IUmlModelElement = UmlModelFactoryField.createOperation
						(
							(collection.getItemAt(i) as Object).name, 
							(collection.getItemAt(i) as Object).visibility, 
							(collection.getItemAt(i) as Object).parameters
						);
						nodesArray.push(fonction);
					}
					break;
				case type == UmlModel.INTERFACE:
					
					for (i = 0; i < collection.length; i++)
					{
						var umlInterface:IUmlModelElement = UmlModelFactoryNode.createInterface
						(
							(collection.getItemAt(i) as Object).name, 
							(collection.getItemAt(i) as Object).visibility, 
							(collection.getItemAt(i) as Object).extendedNode, 
							(collection.getItemAt(i) as Object).functionsList
						);
						nodesArray.push(umlInterface);
					}
					break;
				case type == UmlModel.CONSTANT:
					
					for (i = 0; i < collection.length; i++)
					{
						var constant:IUmlModelElement = UmlModelFactoryField.createConstant
						(
							(collection.getItemAt(i) as Object).name, 
							(collection.getItemAt(i) as Object).visibility, 
							(collection.getItemAt(i) as Object).type 
						);
						nodesArray.push(constant);
					}
					break;
				case type == UmlModel.PARAMETER:
					
					for (i = 0; i < collection.length; i++)
					{
						var parameter:IUmlModelElement = UmlModelFactoryField.createParameter
						(
							(collection.getItemAt(i) as Object).name, 
							UmlModelVisibilityKind.$public, 
							getTypeByUID((collection.getItemAt(i) as Object).type) 
						);
						
						nodesArray.push(parameter);
					}
					break;
			}
			
			return nodesArray;
		}
		
		/**
		 * 
		 * recursiv search in all the model, trying to find the supposed id.
		 * 
		 * @param id
		 * @param nodes
		 * @return 
		 * 
		 */
		public function getNodeById(id:String, nodes:Array):IUmlModelElement
		{
			if (nodes != null)
			{
				var trouve:Boolean = false;
				
				for (var i:int = 0; i < nodes.length && !trouve; i++)
				{
					if ((nodes[i] as IUmlModelElement).uid == id)
					{
						trouve = true;
					}
				}
				
				if (trouve)
				{
					return nodes[i - 1];
				}
				else
				{
					var found		:Boolean			= false;
					var nodeFound	:IUmlModelElement	= null;
					
					for (i = 0; i < nodes.length && !found; i++)
					{
						nodeFound = getNodeById(id, (nodes[i] as IUmlModelElement).ownedElements);
						if (nodeFound != null)
						{
							found = true;
						}
					}
					
					return nodeFound;
				}
			}
			
			return null;
		}
		
		private function getTypeByUID(
									typeUID		:String, 
									createNew	:Boolean=true):IUmlModelType
		{
			var found	:Boolean		= false;
			var type	:IUmlModelType	= null;
			var i		:uint			= 0;
			
			var types:Array = UmlModel.getInstance().primitiveTypes;
			
			for (i = 0; i < types.length && !found; i++)
			{
				type = (types[i] as IUmlModelType);
				if (type.uid == typeUID)
				{
					found = true;
				}
			}
			
			if (!found)
			{
				types = UmlModel.getInstance().umlTypes;
				
				for (i = 0; i < types.length && !found; i++)
				{
					type = (types[i] as IUmlModelType);
					if (type.uid == typeUID)
					{
						found = true;
					}
				}
			}
			
			if (!found && createNew)
			{
				type = UmlModelFactoryNode.createPrimitiveType("unnamed");
			}
			
			return type;
		}
		
		public function getNewUniqueIdentifier():String
		{
			return UIDUtil.createUID();
		}
		
		public function getSelectedProjectWorkspace():UmlViewProjectWorkspace
		{
			return Application.application.getSelectedProjectWorkspace();
		}
		
		public function getSelectedDiagram():UmlViewDiagram
		{
			return Application.application.getSelectedProjectWorkspace().getSelectedDiagram();
		}
		
		public function getMode():String
		{
			return _mode;
		}
		public function setMode(value:String):void
		{
			_mode = value;
		}
		
	}
	
}
