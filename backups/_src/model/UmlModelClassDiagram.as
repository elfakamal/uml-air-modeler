package model
{
	
	import controler.events.UmlAssociationEvent;
	import controler.events.UmlEvent;
	
	
	/**
	 * 
	 * @author kamal
	 * 
	 */
	internal class UmlModelClassDiagram extends UmlModelDiagram
	{
		
		/**
		 * 
		 */
		protected var _ownedRelationships		:Array			= null;
		
		/**
		 * 
		 */
		protected var _ownedClassifiers			:Array			= null;
		
		
		/**
		 * 
		 * @param id
		 * @param name
		 * 
		 */
		public function UmlModelClassDiagram(id:String, name:String)
		{
			super(id, name);
		}
		
		/**
		 * 
		 * @param umlNode
		 * 
		 */
		public override function addElement(element:IUmlModelElement):void
		{
			if (_ownedClassifiers == null)
			{
				_ownedClassifiers = new Array();
			}
			
			if (_ownedRelationships == null)
			{
				_ownedRelationships = new Array();
			}
			
			
			if (element != null)
			{
				element.owner = this;
				
				if (element is UmlModelAssociation)
				{
					addAssociation(UmlModelAssociation(element));
				}
				else if (element is UmlModelAssociationClass)
				{
					addAssociationClass(UmlModelAssociationClass(element));
				}
				else if (element is UmlModelClass)
				{
					addClass(UmlModelClass(element));
				}
				else if (element is UmlModelInterface)
				{
					addInterface(UmlModelInterface(element));
				}
				else if (element is UmlModelEnumeration)
				{
					addEnumeration(UmlModelEnumeration(element));
				}
				else if (element is UmlModelSignal)
				{
					addSignal(UmlModelSignal(element));
				}
				else if (element is UmlModelDataType)
				{
					addDataType(UmlModelDataType(element));
				}
				else if (element is UmlModelArtifact)
				{
					addArtifact(UmlModelArtifact(element));
				}
				else if (element is UmlModelNote)
				{
					addNote(UmlModelNote(element));
				}
				else if (element is UmlModelComment)
				{
					//addComment(UmlModelComment(umlNode));
				}
				else
				{
					// nth
				}
			}
		}
		
		protected function addClassifier(classifier:IUmlModelClassifier):void
		{
			if (classifier == null)
			{
				return;
			}
			
			_ownedClassifiers.push(classifier);
			
			var umlEvent:UmlEvent = new UmlEvent(UmlEvent.CLASSIFIER_ADDED);
			umlEvent.setAddedElement(classifier);
			dispatchEvent(umlEvent);
		}
		
		protected function addRelationship(relationship:UmlModelRelationship):void
		{
			if (relationship == null)
			{
				return;
			}
			
			_ownedRelationships.push(relationship);
			
			var umlEvent:UmlAssociationEvent = new UmlAssociationEvent(UmlAssociationEvent.ASSOCIATION_ADDED);
			umlEvent.setAddedElement(relationship);
			dispatchEvent(umlEvent);
		}
		
		/**
		 * 
		 * @param umlAssociationClass
		 * 
		 */
		protected function addAssociationClass(umlAssociationClass:UmlModelAssociationClass):void
		{
			if (umlAssociationClass)
			{
				_ownedClassifiers.push(umlAssociationClass);
				
				var umlEvent:UmlAssociationEvent = new UmlAssociationEvent(UmlAssociationEvent.ASSOCIATION_CLASS_ADDED);
				umlEvent.setAddedElement(umlAssociationClass);
				dispatchEvent(umlEvent);
			}
		}
		
		/**
		 * 
		 * @param umlClass
		 * 
		 */
		protected function addClass(umlClass:UmlModelClass):void
		{
			if (umlClass != null)
			{
				_ownedClassifiers.push(umlClass);
				
				var umlEvent:UmlEvent = new UmlEvent(UmlEvent.CLASS_ADDED);
				umlEvent.setAddedElement(umlClass);
				dispatchEvent(umlEvent);
			}
		}
		
		/**
		 * 
		 * @param umlInterface
		 * 
		 */
		protected function addInterface(umlInterface:UmlModelInterface):void
		{
			if (umlInterface)
			{
				_ownedClassifiers.push(umlInterface);
				
				var umlEvent:UmlEvent = new UmlEvent(UmlEvent.INTERFACE_ADDED);
				umlEvent.setAddedElement(umlInterface);
				dispatchEvent(umlEvent);
			}
		}
		
		/**
		 * 
		 * @param umlAssociation
		 * 
		 */
		protected function addAssociation(umlAssociation:UmlModelAssociation):void
		{
			if (umlAssociation != null)
			{
				_ownedRelationships.push(umlAssociation);
				
				var umlEvent:UmlAssociationEvent = new UmlAssociationEvent(UmlAssociationEvent.ASSOCIATION_ADDED);
				umlEvent.setAddedElement(umlAssociation);
				dispatchEvent(umlEvent);
			}
		}
		
		/**
		 * 
		 * @param umlEnumeration
		 * 
		 */
		protected function addEnumeration(umlEnumeration:UmlModelEnumeration):void
		{
			if (umlEnumeration != null)
			{
				_ownedClassifiers.push(umlEnumeration);
				
				var umlEvent:UmlEvent = new UmlEvent(UmlEvent.ENUMERATION_ADDED);
				umlEvent.setAddedElement(umlEnumeration);
				dispatchEvent(umlEvent);
			}
		}
		
		/**
		 * 
		 * @param umlSignal
		 * 
		 */
		protected function addSignal(umlSignal:UmlModelSignal):void
		{
			if (umlSignal != null)
			{
				_ownedClassifiers.push(umlSignal);
				
				var umlEvent:UmlEvent = new UmlEvent(UmlEvent.SIGNAL_ADDED);
				umlEvent.setAddedElement(umlSignal);
				dispatchEvent(umlEvent);
			}
		}
		
		/**
		 * 
		 * @param umlDataType
		 * 
		 */
		protected function addDataType(umlDataType:UmlModelDataType):void
		{
			if (umlDataType != null)
			{
				_ownedClassifiers.push(umlDataType);
				
				var umlEvent:UmlEvent = new UmlEvent(UmlEvent.DATA_TYPE_ADDED);
				umlEvent.setAddedElement(umlDataType);
				dispatchEvent(umlEvent);
			}
		}
		
		/**
		 * 
		 * @param umlArtifact
		 * 
		 */
		protected function addArtifact(umlArtifact:UmlModelArtifact):void
		{
			if (umlArtifact != null)
			{
				_ownedClassifiers.push(umlArtifact);
				
				var umlEvent:UmlEvent = new UmlEvent(UmlEvent.ARTIFACT_ADDED);
				umlEvent.setAddedElement(umlArtifact);
				dispatchEvent(umlEvent);
			}
		}
		
		/**
		 * 
		 * @param umlNote
		 * 
		 */
		protected function addNote(umlNote:UmlModelNote):void
		{
			if (umlNote != null)
			{
				_ownedClassifiers.push(umlNote);
				
				var umlEvent:UmlEvent = new UmlEvent(UmlEvent.NOTE_ADDED);
				umlEvent.setAddedElement(umlNote);
				dispatchEvent(umlEvent);
			}
		}
		
		/**
		 * 
		 * @param umlComment
		 * 
		 */
		public override function addComment(umlComment:UmlModelComment):void
		{
			if (umlComment != null)
			{
				_ownedClassifiers.push(umlComment);
				
				var umlEvent:UmlEvent = new UmlEvent(UmlEvent.COMMENT_ADDED);
				umlEvent.setAddedElement(umlComment);
				UmlModel.getInstance().dispatchEvent(umlEvent);
			}
		}
		
		public override function removeElement(element:IUmlModelElement) : void
		{
			if (element == null)
			{
				return;
			}
			
			if (ownedElements != null && ownedElements.length > 0)
			{
				var elements:Array = null;
				
				if (ownedClassifiers.indexOf(element) >= 0)
				{
					elements = ownedClassifiers;
				}
				else if (ownedRelationships.indexOf(element) >= 0)
				{
					elements = ownedRelationships;
				}
				
				if (elements != null)
				{
					element.owner = null;
					delete elements.splice(elements.indexOf(element), 1);
					
					var event:UmlEvent = new UmlEvent(UmlEvent.ELEMENT_DELETED);
					event.setDeletedNode(element);
					dispatchEvent(event);
				}
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
//					var isNodeEdited:Boolean = false;
//					
//					if (oldElement is UmlModelClass && newElement is UmlModelClass)
//					{
//						use namespace model;
//						
//						UmlModel.getInstance().editTypeByUID
//						(
//							(oldElement as IUmlModelType).uid, 
//							(newElement as IUmlModelType)
//						);
//						
//						(oldElement as UmlModelClass).name = (newElement as UmlModelClass).name;
//						(oldElement as UmlModelClass).visibility = (newElement as UmlModelClass).visibility;
//						
//						isNodeEdited = true;
//					}
//					else if (oldElement is UmlModelInterface && newElement is UmlModelInterface)
//					{
//						use namespace model;
//						
//						UmlModel.getInstance().editTypeByUID
//						(
//							(oldElement as IUmlModelType).uid, 
//							(newElement as IUmlModelType)
//						);
//						
//						(oldElement as UmlModelInterface).name = (newElement as UmlModelInterface).name;
////						(oldElement as UmlModelInterface).setVisibility((newElement as UmlModelInterface).getVisibility());
////						(oldElement as UmlModelInterface).ownedElements = (newElement as UmlModelInterface).ownedElements;
//						isNodeEdited = true;
//					}
//					else if (oldElement is UmlModelAssociation && newElement is UmlModelAssociation)
//					{
////						(oldElement as UmlModelAssociation).name = (newElement as UmlModelAssociation).name;
////						(oldElement as UmlModelAssociation).ownedElements = (newElement as UmlModelAssociation).ownedElements;
//						isNodeEdited = true;
//					}
//					else if (oldElement is UmlModelEnumeration && newElement is UmlModelEnumeration)
//					{
//						(oldElement as UmlModelEnumeration).name = (newElement as UmlModelEnumeration).name;
////						(oldElement as UmlModelEnumeration).ownedElements = (newElement as UmlModelEnumeration).ownedElements;
//						isNodeEdited = true;
//					}
//					else 
//					{
//						// nth
//					}
//					
//					if (isNodeEdited)
//					{
//						var event:UmlEvent = new UmlEvent(UmlEvent.NODE_EDITED);
//						event.setEditedNode(oldElement.xml);
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
			_xml = <umlClassDiagram id={uid} name={name} />;
			
			if (ownedElements && ownedElements.length > 0)
			{
				var classesXml				:XML = <umlClasses />;
				var interfacesXml			:XML = <umlInterfaces />;
				var associationsXml			:XML = <umlAssociations />;
				var enumerationsXml			:XML = <umlEnumerations />;
				var signalsXml				:XML = <umlSignals />;
				var dataTypesXml			:XML = <umlDataTypes />;
				var artifactsXml			:XML = <umlArtifacts />;
				var notesXml				:XML = <umlNotes />;
				var commentsXml				:XML = <umlComments />;
				var packagesXml				:XML = <umlPackages />;
				
				
				var classesCount			:uint = 0;
				var interfacesCount			:uint = 0;
				var associationsCount		:uint = 0;
				var enumerationsCount		:uint = 0;
				var signalsCount			:uint = 0;
				var dataTypesCount			:uint = 0;
				var artifactsCount			:uint = 0;
				var notesCount				:uint = 0;
				var commentsCount			:uint = 0;
				var packagesCount			:uint = 0;
				
				
				for (var i:int = 0; i < ownedElements.length; i++)
				{
					if (ownedElements[i] is UmlModelClass)
					{
						var umlClass:UmlModelClass = UmlModelClass(ownedElements[i]);
						classesXml.appendChild(umlClass.xml);
						classesCount++;
					}
					else if (ownedElements[i] is UmlModelInterface)
					{
						var umlInterface:UmlModelInterface = UmlModelInterface(ownedElements[i]);
						interfacesXml.appendChild(umlInterface.xml);
						interfacesCount++;
					}
					else if (ownedElements[i] is UmlModelAssociation)
					{
						var umlAssociation:UmlModelAssociation = UmlModelAssociation(ownedElements[i]);
						associationsXml.appendChild(umlAssociation.xml);
						associationsCount++;
					}
					else if (ownedElements[i] is UmlModelEnumeration)
					{
						var umlEnumeration:UmlModelEnumeration = UmlModelEnumeration(ownedElements[i]);
						enumerationsXml.appendChild(umlEnumeration.xml);
						enumerationsCount++;
					}
					else if (ownedElements[i] is UmlModelSignal)
					{
						var umlSignal:UmlModelSignal = UmlModelSignal(ownedElements[i]);
						signalsXml.appendChild(umlSignal.xml);
						signalsCount++;
					}
					else if (ownedElements[i] is UmlModelDataType)
					{
						var umlDatatype:UmlModelDataType = UmlModelDataType(ownedElements[i]);
						dataTypesXml.appendChild(umlDatatype.xml);
						dataTypesCount++;
					}
					else if (ownedElements[i] is UmlModelArtifact)
					{
						var umlArtifact:UmlModelArtifact = UmlModelArtifact(ownedElements[i]);
						artifactsXml.appendChild(umlArtifact.xml);
						artifactsCount++;
					}
					else if (ownedElements[i] is UmlModelNote)
					{
						var umlNote:UmlModelNote = UmlModelNote(ownedElements[i]);
						notesXml.appendChild(umlNote.xml);
						notesCount++;
					}
					else if (ownedElements[i] is UmlModelComment)
					{
						var umlComment:UmlModelComment = UmlModelComment(ownedElements[i]);
						commentsXml.appendChild(umlComment.xml);
						commentsCount++;
					}
					else if (ownedElements[i] is UmlModelPackage)
					{
						var umlPackage:UmlModelPackage = UmlModelPackage(ownedElements[i]);
						packagesXml.appendChild(umlPackage.xml);
						packagesCount++;
					}
				}
				
				if (classesCount > 0) 			_xml.appendChild(classesXml);
				if (interfacesCount > 0) 		_xml.appendChild(interfacesXml);
				if (associationsCount > 0) 		_xml.appendChild(associationsXml);
				if (enumerationsCount > 0) 		_xml.appendChild(enumerationsXml);
				if (signalsCount > 0)	 		_xml.appendChild(signalsXml);
				if (dataTypesCount > 0)	 		_xml.appendChild(dataTypesXml);
				if (artifactsCount > 0)	 		_xml.appendChild(artifactsXml);
				if (notesCount > 0)		 		_xml.appendChild(notesXml);
				if (commentsCount > 0)	 		_xml.appendChild(commentsXml);
				if (packagesCount > 0)	 		_xml.appendChild(packagesXml);
				
			}
			
			return _xml;
		}
		
		public override function get ownedElements():Array
		{
			var elements:Array = [];
			
			if (super.ownedElements != null)
			{
				elements = elements.concat(super.ownedElements);
			}
			
			if (ownedClassifiers != null)
			{
				elements = elements.concat(ownedClassifiers);
			}
			
			if (ownedRelationships != null)
			{
				elements = elements.concat(ownedRelationships);
			}
			
			return elements;
		}
		
		public function get ownedRelationships():Array
		{
			return _ownedRelationships;
		}
		public function set ownedRelationships(value:Array):void 
		{
			_ownedRelationships = value;
		}
		
		public function get ownedClassifiers():Array
		{
			return _ownedClassifiers;
		}
		public function set ownedClassifiers(value:Array):void 
		{
			_ownedClassifiers = value;
		}
		
	}
	
}
