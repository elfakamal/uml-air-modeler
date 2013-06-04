package model
{
	import controler.UmlControler;
	import controler.events.UmlEvent;
	
	internal class UmlModelSignal extends UmlModelNamedElement
	{
		
		/**
		 * 
		 * @param id
		 * @param name
		 * @param visibility
		 * 
		 */
		public function UmlModelSignal(id:String, name:String)
		{
			super(id, name);
			
//			_ownedElements = new Array();
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public override function get xml():XML
		{
			_xml = <umlSignal id={uid} name={name} />;
			
			if (ownedElements && ownedElements.length > 0)
			{
				var signalAttributeXml:XML = <signalAttributes />;
				for (var i:int = 0; i < ownedElements.length; i++)
				{
					var umlSignalAttribute:UmlModelSignalAttribute = null;
					umlSignalAttribute = UmlModelSignalAttribute(ownedElements[i]);
					signalAttributeXml.appendChild(umlSignalAttribute.xml);
				}
				_xml.appendChild(signalAttributeXml);
			}
			
			return _xml;
		}
		
		/**
		 * 
		 * @param umlNode
		 * 
		 */
		public override function addElement(umlNode:IUmlModelElement):void
		{
			if (umlNode is UmlModelSignalAttribute)
			{
//				_ownedElements.push(umlNode);
				
				var event:UmlEvent = new UmlEvent(UmlEvent.SIGNAL_ATTRIBUTE_ADDED);
				event.setAddedSignalAttribute(umlNode.xml);
				UmlModel.getInstance().dispatchEvent(event);
			}
			else
			{
				// rien
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
//				var oldElement:IUmlModelElement = UmlControler.getInstance().getNodeById(elementUID, ownedElements);
//				if (oldElement)
//				{
//					if (oldElement is UmlModelSignalAttribute && newElement is UmlModelSignalAttribute)
//					{
//						(oldElement as UmlModelSignalAttribute).name = (newElement as UmlModelSignalAttribute).name;
////						(oldElement as UmlModelSignalAttribute).setVisibility((newElement as UmlModelSignalAttribute).getVisibility());
////						(oldElement as UmlModelSignalAttribute).setType((newElement as UmlModelSignalAttribute).getType());
////						(oldElement as UmlModelSignalAttribute).setIsMember((newElement as UmlModelSignalAttribute).isMember());
//						
//						var event:UmlEvent = new UmlEvent(UmlEvent.ELEMENT_EDITED);
//						event.setEditedNode(oldElement);
//						UmlModel.getInstance().dispatchEvent(event);
//					}
//				}
//			}
//		}
		
	}
	
}
