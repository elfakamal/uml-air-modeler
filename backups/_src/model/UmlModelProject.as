package model
{
	import controler.UmlControler;
	import controler.events.UmlEvent;
	
	/**
	 * 
	 * @author kamal
	 * 
	 */
	public class UmlModelProject extends UmlModelNamedElement
	{
		
		/**
		 * 
		 * subsets Element::ownedElements
		 */
		protected var _ownedDiagrams		:Array				= null;
		
		/**
		 * 
		 */
		protected var _location				:String				= null;
		
		/**
		 * 
		 */
		protected var _selectedDiagram		:IUmlModelDiagram	= null;
		
		/**
		 * 
		 * @param id
		 * @param name
		 * @param location
		 * 
		 */
		public function UmlModelProject(id:String, name:String, location:String)
		{
			super(id, name);
			
			_location = location;
		}
		
		/**
		 * 
		 * @param umlNode
		 * 
		 */
		public override function addElement(element:IUmlModelElement):void
		{
			if (element is IUmlModelDiagram)
			{
				if (_ownedDiagrams == null)
				{
					_ownedDiagrams = new Array();
				}
				
				_ownedDiagrams.push(element);
				
				// listened from the workspace's view UmlProjectWorkspace
//				var umlEvent:UmlEvent = new UmlEvent(UmlEvent.DIAGRAM_ADDED);
//				setSelectedDiagram(UmlModelClassDiagram(umlNode));
//				umlEvent.setAddedDiagram(umlNode.xml);
//				UmlModel.getInstance().dispatchEvent(umlEvent);
				
				setSelectedDiagram(UmlModelClassDiagram(element));
				element.owner = this;
				
				var umlEvent:UmlEvent = new UmlEvent(UmlEvent.ELEMENT_ADDED);
				umlEvent.setAddedElement(element);
				dispatchEvent(umlEvent);
			}
		}
		
		/**
		 * 
		 * @param nodeId
		 * @param newUmlNode
		 * 
		 */
//		public override function editElement(elementUID:String, newElement:IUmlModelElement):void
//		{
//			if (newElement)
//			{
//				var oldUmlNode:IUmlModelElement = UmlControler.getInstance().getNodeById(elementUID, ownedElements);
//				if (oldUmlNode)
//				{
//					if (oldUmlNode is IUmlModelDiagram && newElement is IUmlModelDiagram)
//					{
//						(oldUmlNode as IUmlModelDiagram).name = (newElement as IUmlModelDiagram).name;
//						
//						var event:UmlEvent = new UmlEvent(UmlEvent.ELEMENT_EDITED);
//						event.setEditedNode(oldUmlNode);
//						UmlModel.getInstance().dispatchEvent(event);
//					}
//				}
//			}
//		}
		
		public override function get xml():XML
		{
			// class Diagrams, use case diagrams, sequence diagrams, & state diagrams
			_xml = <umlProject 
						id			={uid} 
						name		={name} 
						location	={getLocation()} /> 
			
			var umlModelXml:XML = <umlModel />;
			_xml.appendChild(umlModelXml);
			
			if (ownedElements && ownedElements.length > 0)
			{
				var diagramsXml:XML = <umlDiagrams />;
				for (var i:uint = 0; i < ownedElements.length; i++)
				{
					var umlNode:IUmlModelElement = ownedElements[i] as IUmlModelElement;
					diagramsXml.appendChild(umlNode.xml);
				}
				_xml.appendChild(diagramsXml);
			}
			
			return _xml;
		}
		
		public override function get owner() : IUmlModelElement
		{
			return null;
		}
		
		public override function get ownedElements():Array
		{
			var elements:Array = new Array();
			
			if (super.ownedElements != null)
			{
				elements = elements.concat(super.ownedElements);
			}
			
			if (ownedDiagrams != null)
			{
				elements = elements.concat(ownedDiagrams);
			}
			
			return elements;
		}
		
		public function get ownedDiagrams():Array
		{
			return _ownedDiagrams;
		}
		public function set ownedDiagrams(diagrams:Array):void
		{
			_ownedDiagrams = diagrams;
		}
		
		public override function get selectedNode():IUmlModelElement
		{
			return getSelectedDiagram();
		}
		
		public override function set selectedNode(node:IUmlModelElement):void
		{
			if (node is IUmlModelDiagram)
			{
				setSelectedDiagram(node as IUmlModelDiagram);
			}
		}
		
		public override function mustBeOwned():Boolean
		{
			return false;
		}
		
		////////////////////////////////////////////////////////////////
		public function getSelectedDiagram():IUmlModelDiagram
		{
			return _selectedDiagram;
		}
		public function setSelectedDiagram(value:IUmlModelDiagram):void
		{
			_selectedDiagram = value;
		}
		
		public function setLocation(value:String):void
		{
			_location = value;
		}
		public function getLocation():String
		{
			return _location;
		}
		
		public override function get visibility():UmlModelVisibilityKind
		{
			return null;
		}
		
	}
	
}
