package model
{
	import controler.UmlControler;
	import controler.events.UmlEvent;
	
	/**
	 * 
	 * An enumeration is a data type whose values are enumerated in the model 
	 * as enumeration literals.
	 * 
	 * Enumeration is a kind of data type, whose instances may be any of a number 
	 * of user-defined enumeration literals. 
	 * 
	 * It is possible to extend the set of applicable enumeration literals 
	 * in other packages or profiles.
	 * 
	 * @author kamal
	 * 
	 */
	internal class UmlModelEnumeration extends UmlModelDataType
	{
		
		/**
		 * The ordered set of literals for this Enumeration. 
		 * Subsets Namespace::ownedMember
		 */
		protected var _ownedLiterals		:Array		= null;
		
		/**
		 * 
		 * @param id
		 * @param name
		 * @param visibility
		 * 
		 */
		public function UmlModelEnumeration(id:String, name:String)
		{
			super(id, name);
			//_ownedElements = new Array();
		}
		
		/**
		 * 
		 * @param umlNode
		 * 
		 */
		public override function addElement(umlNode:IUmlModelElement):void
		{
			if (umlNode != null && umlNode is UmlModelEnumerationLiteral)
			{
//				_ownedElements.push(umlNode);
				
				var event:UmlEvent = new UmlEvent(UmlEvent.ENUMERATION_LITERAL_ADDED);
				var enumLiteralXml:XML = umlNode.xml;
				event.setAddedEnumerationLiteral(enumLiteralXml);
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
//					if (oldElement is UmlModelEnumerationLiteral && newElement is UmlModelEnumerationLiteral)
//					{
//						(oldElement as UmlModelEnumerationLiteral).name = (newElement as UmlModelEnumerationLiteral).name;
////						(oldElement as UmlModelEnumerationLiteral).setType((newElement as UmlModelEnumerationLiteral).getType());
//						//(oldElement as UmlModelEnumerationLiteral).setValue((newElement as UmlModelEnumerationLiteral).getValue());
//						
//						var event:UmlEvent = new UmlEvent(UmlEvent.ELEMENT_EDITED);
//						event.setEditedNode(oldElement);
//						UmlModel.getInstance().dispatchEvent(event);
//					}
//				}
//			}
//		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public override function get xml():XML
		{
			_xml = <umlEnumeration
						id				= {uid} 
						name			= {name} />;
			
			if (ownedElements && ownedElements.length > 0)
			{
				var enumerationLiteralXml:XML = <enumerationLiterals />;
				for (var i:int = 0; i < ownedElements.length; i++)
				{
					var umlEnumerationLiteral:UmlModelEnumerationLiteral = null;
					umlEnumerationLiteral = UmlModelEnumerationLiteral(ownedElements[i]);
					enumerationLiteralXml.appendChild(umlEnumerationLiteral.xml);
				}
				_xml.appendChild(enumerationLiteralXml);
			}
			
			return _xml;
		}
		
		public function get ownedLiterals():Array
		{
			return _ownedLiterals;
		}
		public function set ownedLiterals(value:Array):void 
		{
			_ownedLiterals = value;
		}
		
		//from Namespace
		override public function get ownedMembers():Array
		{
			var elements:Array = [];
			
			if (super.ownedMembers)
			{
				elements = elements.concat(super.ownedMembers);
			}
			
			if (ownedLiterals != null)
			{
				elements = elements.concat(ownedLiterals);
			}
			
			return elements;
		}
		
	}
	
}
