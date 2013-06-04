package model
{
	import controler.UmlControler;
	import controler.events.UmlEvent;
	import controler.namespaces.creator;
	import controler.namespaces.model;
	import controler.namespaces.selector;
	
	import flash.errors.IllegalOperationError;
	import flash.events.EventDispatcher;
	
	
	/**
	 * 
	 * @author kamal
	 * 
	 */
	public class UmlModel extends EventDispatcher 
	{
		
		use namespace model;
		
		/////////////////////////////////////////////////////////////////////
		public static const DIAGRAM					:String = "diagram";
		
		public static const CLASS					:String = "class";
		public static const ASSOCIATION_CLASS		:String = "association_class";
		public static const INTERFACE				:String = "interface";
		public static const ASSOCIATION				:String = "association";
		
		public static const ATTRIBUTE				:String = "attribute";
		public static const CONSTANT				:String = "constant";
		public static const ASSOCIATION_END			:String = "associationEnd";
		
		public static const OPERATION				:String = "function";
		
		public static const PARAMETER				:String = "parameter";
		
		public static const ENUMERATION				:String = "enumeration";
		public static const ENUMERATION_LITERAL		:String = "enumeration_literal";
		public static const SIGNAL					:String = "signal";
		public static const SIGNAL_ATTRIBUTE		:String = "signal_attribute";
		
		/**
		 * TODO : complete the other constants
		 */
		
		/////////////////////////////////////////////////////////////////////
		private static var _instance			:UmlModel			= null;
		private static var _isCreationAllowed	:Boolean			= false;
		
		private var _umlProjects			:Array					= null;
		private var _selectedProject		:UmlModelProject		= null;
		private var _selectedNode			:IUmlModelElement		= null;
		
		/**
		 * 
		 * 
		 */
		model var _primitiveTypes			:Array					= null;
		model var _umlTypes					:Array					= null;
		
		
		/**
		 * 
		 * @param lock
		 * 
		 */
		public function UmlModel()
		{
			if (!_isCreationAllowed)
			{
				throw new IllegalOperationError("UmlModel is a singleton");
			}
			else
			{
				_umlProjects = new Array();
				initObjects();
			}
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public static function getInstance():UmlModel
		{
			if (_instance)
			{
				return _instance;
			}
			else
			{
				_isCreationAllowed	= true;
				_instance			= new UmlModel();
				_isCreationAllowed	= false;
				
				return _instance;
			}
		}
		
		private function initObjects():void
		{
			createPrimitiveTypes();
		}
		
		private function createPrimitiveTypes():void
		{
			use namespace creator;
			
			
			_primitiveTypes = new Array();
			
			_primitiveTypes.push(UmlModelFactoryNode.createPrimitiveType("void"));
			_primitiveTypes.push(UmlModelFactoryNode.createPrimitiveType("String"));
			_primitiveTypes.push(UmlModelFactoryNode.createPrimitiveType("int"));
			_primitiveTypes.push(UmlModelFactoryNode.createPrimitiveType("uint"));
			_primitiveTypes.push(UmlModelFactoryNode.createPrimitiveType("Float"));
			_primitiveTypes.push(UmlModelFactoryNode.createPrimitiveType("Double"));
			_primitiveTypes.push(UmlModelFactoryNode.createPrimitiveType("Date"));
		}
		
		model function addType(type:IUmlModelType):void
		{
			if (_umlTypes == null)
			{
				_umlTypes = new Array();
			}
			
			_umlTypes.push(type);
		}
		
		model function removeTypeByUID(uid:String):void
		{
			if (_umlTypes == null || _umlTypes.length == 0)
			{
				return;
			}
			
			if (uid != "")
			{
				var type	:IUmlModelType	= getTypeByUID(uid);
				var found	:Boolean		= false;
				
				if (type != null)
				{
					delete _umlTypes.splice(_umlTypes.indexOf(type), 1);
				}
			}
		}
		
		model function editTypeByUID(oldTypeUID:String, newType:IUmlModelType):void
		{
			if (_umlTypes == null || _umlTypes.length == 0)
			{
				return;
			}
			
			if (oldTypeUID == "")
			{
				return;
			}
			
			var oldType:IUmlModelType = getTypeByUID(oldTypeUID);
			
			if (oldType != null)
			{
				var index:uint		= _umlTypes.indexOf(oldType);
				_umlTypes[index]	= newType;
			}
		}
		
		model function getTypeByUID(uid:String):IUmlModelType
		{
			var type	:IUmlModelType	= null;
			var found	:Boolean		= false;
			
			for (var i:uint = 0; i < _umlTypes.length && !found; i++)
			{
				type = _umlTypes[i] as IUmlModelType;
				
				if (type.uid == uid)
				{
					found = true;
				}
			}
			
			return type;
		}
		
		model function getTypeUID(name:String):String
		{
			var strUID	:String			= "";
			var type	:IUmlModelType	= null;
			var index	:int			= -1;
			
			if (name != "")
			{
				if (primitiveTypesNames.indexOf(name) >= 0)
				{
					index	= primitiveTypesNames.indexOf(name);
					type	= primitiveTypes[index] as IUmlModelType;
				}
				else if (umlTypeNames.indexOf(name) >= 0)
				{
					index	= umlTypeNames.indexOf(name);
					type	= umlTypes[index] as IUmlModelType;
				}
				
				if (type != null)
				{
					strUID	= type.uid;
				}
			}
			
			return strUID;
		}
		
		model function get umlTypes():Array
		{
			return model::_umlTypes;
		}
		
		model function get primitiveTypes():Array
		{
			return model::_primitiveTypes;
		}
		
		model function get umlTypeNames():Array
		{
			var typeNames	:Array	= new Array();
			var i			:uint	= 0;
			
			for (i = 0; i < umlTypes.length; i++)
			{
				typeNames.push((umlTypes[i] as IUmlModelType).name);
			}
			
			return typeNames;
		}
		
		model function get primitiveTypesNames():Array
		{
			var typeNames	:Array	= new Array();
			var i			:uint	= 0;
			
			for (i = 0; i < primitiveTypes.length; i++)
			{
				typeNames.push((primitiveTypes[i] as IUmlModelType).name);
			}
			
			return typeNames;
		}
		
		model function getAllTypeNames():Array
		{
			var typeNames	:Array	= new Array();
			var i			:uint	= 0;
			
			typeNames = typeNames.concat(primitiveTypes, umlTypeNames);
			
			return typeNames;
		}
		
		/**
		 * 
		 * @param umlNode
		 * 
		 */
		model function addElement(umlElement:IUmlModelElement):void
		{
			if (umlElement)
			{
				if (umlElement is UmlModelProject)
				{
					_umlProjects.push(umlElement);
					umlElement.owner = null;
					_selectedProject = umlElement as UmlModelProject;
					
					var umlEvent:UmlEvent = new UmlEvent(UmlEvent.ELEMENT_ADDED);
					umlEvent.setAddedElement(umlElement);
					dispatchEvent(umlEvent);
				}
				else if (umlElement is IUmlModelDiagram)
				{
					if (_selectedProject)
					{
						_selectedProject.addElement(umlElement);
					}
				}
			}
		}
		
		model function addChildToElement(parentUID:String, childElement:IUmlModelElement):void
		{
			if (childElement == null)
			{
				return;
			}
			
			var parentElement:IUmlModelElement = null;
			
			parentElement = UmlControler.getInstance().getNodeById(parentUID, ownedElements);
			
			if (parentElement)
			{
				parentElement.addElement(childElement);
			}
			else
			{
				trace ("le parentUID fourni n'existe pas");
			}
		}
		
		model function editNode(elementUID:String, newUmlNode:IUmlModelElement):void
		{
			if (newUmlNode)
			{
				var oldUmlNode:IUmlModelElement = UmlControler.getInstance().getNodeById(elementUID, ownedElements);
				if (oldUmlNode is UmlModelClassDiagram)
				{
					(newUmlNode as UmlModelClassDiagram).name = (oldUmlNode as UmlModelClassDiagram).name;
				}
			}
		}
		
		model function removeNode(umlNode:IUmlModelElement):void
		{
			
		}
		
		model function contains(umlNode:IUmlModelElement):Boolean
		{
			return _umlProjects.indexOf(umlNode) >= 0;
		}
		
		selector function getSelectedProject():UmlModelProject
		{
			return _selectedProject;
		}
		
		public function get ownedElements():Array
		{
			return _umlProjects;
		}
		
//		public function selectNode(id:String):void
//		{
////			for (var i:int = 0; i < _umlDiagrams.length; i++)
////			{
////				var node:UmlModelClassDiagram = UmlModelClassDiagram(_umlDiagrams[i]);
////				if (node && node.uid == id)
////				{
////					_selectedDiagram = node;
////				}
////			}
//		}
		
		selector function getSelectedNode():IUmlModelElement
		{
			return _selectedNode;
		}
		
		selector function setSelectedNode(node:IUmlModelElement):void
		{
			_selectedNode = node;
		}
		
	}
	
}
