package model
{
	
	import controler.events.UmlEvent;
	
	/**
	 * Class is a kind of classifier whose features are attributes and operations. 
	 * Attributes of a class are represented by instances of Property that are 
	 * owned by the class. Some of these attributes may represent the navigable 
	 * ends of binary associations.
	 * 
	 * @author kamal
	 * 
	 */
	internal class UmlModelClass extends UmlModelClassifier
	{
		
		/**
		 * 
		 */
		protected var _nestedClassifiers		:Array				= null;
		protected var _ownedAttributes			:Array				= null;
		protected var _ownedOperations			:Array				= null;
		
		/**
		 * 
		 * @param id
		 * @param name
		 * @param visibility
		 * 
		 */
		public function UmlModelClass(
							p_uid				:String, 
							p_name				:String, 
							p_visibility		:UmlModelVisibilityKind	= null)
		{
			super(p_uid, p_name, p_visibility);
		}
		
		/**
		 * This gives the superclasses of a class. 
		 * It redefines Classifier::general. This is derived.
		 */
		public function get superClasses():Array
		{
			return generals;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public override function get xml():XML
		{
			_xml = <umlClass 
						id					= {uid} 
						name				= {name} 
						visibility			= {visibility} />;
			
			if (ownedElements && ownedElements.length > 0)
			{
				var nestedClassifiersXml	:XML = <umlNestedClassifiers />;
				var constantsXml			:XML = <umlConstants />;
				var attributesXml			:XML = <umlAttributes />;
				var functionsXml			:XML = <umlFunctions />;
				
				var nestedClassifiersCount	:uint = 0;
				var constantsCount			:uint = 0;
				var attributesCount			:uint = 0;
				var functionsCount			:uint = 0;
				
				for (var i:int = 0; i < ownedElements.length; i++)
				{
					if (ownedElements[i] is IUmlModelClassifier)
					{
						var classifier:IUmlModelClassifier = IUmlModelClassifier(ownedElements[i]);
						nestedClassifiersXml.appendChild(classifier.xml);
						nestedClassifiersCount++;
					}
					else if (ownedElements[i] is UmlModelConstant)
					{
						var umlConstants:UmlModelConstant = UmlModelConstant(ownedElements[i]);
						constantsXml.appendChild(umlConstants.xml);
						constantsCount++;
					}
					else if (ownedElements[i] is UmlModelProperty)
					{
						var umlAttribute:UmlModelProperty = UmlModelProperty(ownedElements[i]);
						attributesXml.appendChild(umlAttribute.xml);
						attributesCount++;
					}
					else if (ownedElements[i] is UmlModelOperation)
					{
						var umlFunction:UmlModelOperation = UmlModelOperation(ownedElements[i]);
						functionsXml.appendChild(umlFunction.xml);
						functionsCount++;
					}
				}
				
				if (nestedClassifiersCount	> 0)	_xml.appendChild(nestedClassifiersXml);
				if (constantsCount			> 0)	_xml.appendChild(constantsXml);
				if (attributesCount			> 0)	_xml.appendChild(attributesXml);
				if (functionsCount			> 0)	_xml.appendChild(functionsXml);
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
			if (umlNode != null)
			{
				if (_ownedAttributes == null)
				{
					_ownedAttributes = new Array();
				}
				
				if (_ownedOperations == null)
				{
					_ownedOperations = new Array();
				}
				
				if (_nestedClassifiers == null)
				{
					_nestedClassifiers = new Array();
				}
				
				if (umlNode is UmlModelConstant)
				{
					addConstant(UmlModelConstant(umlNode));
				}
				else if (umlNode is UmlModelProperty)
				{
					addAttribute(UmlModelProperty(umlNode));
				}
				else if (umlNode is UmlModelOperation)
				{
					addOperation(UmlModelOperation(umlNode));
				}
				else if (umlNode is UmlModelInterface)
				{
					addImplementedInterface(UmlModelInterface(umlNode));
				}
				else if (umlNode is IUmlModelClassifier)
				{
					addClassifer(IUmlModelClassifier(umlNode));
				}
				else
				{
					//rien, car il y a une possibilité d'insérer une classe à une AssociationClass
					//throw new IllegalOperationError("umlNode isn't a model object");
				}
			}
		}
		
		/**
		 * 
		 * @param umlInterface
		 * 
		 */
		private function addImplementedInterface(umlInterface:UmlModelInterface):void
		{
			if (umlInterface)
			{
//				_ownedElements.push(umlInterface);
				
				//var event:UmlEvent = new UmlEvent(UmlEvent.ASSOCIATION_ADDED);
				//event.setAddedConstant(umlInterface.xml);
				//UmlModel.getInstance().dispatchEvent(event);
			}
		}
		
		/**
		 * 
		 * @param umlConstant
		 * 
		 */
		private function addConstant(umlConstant:UmlModelConstant):void
		{
			if (umlConstant)
			{
				_ownedAttributes.push(umlConstant);
				
				umlConstant.owner = this;
				
				var event:UmlEvent = new UmlEvent(UmlEvent.CONSTANT_ADDED);
				event.setAddedElement(umlConstant);
				dispatchEvent(event);
			}
		}
		
		/**
		 * 
		 * @param umlAttribute
		 * 
		 */
		private function addAttribute(umlAttribute:UmlModelProperty):void
		{
			if (umlAttribute)
			{
				_ownedAttributes.push(umlAttribute);
				
				umlAttribute.owner = this;
				
				var event:UmlEvent = new UmlEvent(UmlEvent.ATTRIBUTE_ADDED);
				event.setAddedElement(umlAttribute);
				dispatchEvent(event);
			}
		}
		
		/**
		 * 
		 * @param umlFunction
		 * 
		 */
		private function addOperation(umlFunction:UmlModelOperation):void
		{
			if (umlFunction)
			{
				_ownedOperations.push(umlFunction);
				
				umlFunction.owner = this;
				
				var event:UmlEvent = new UmlEvent(UmlEvent.OPERATION_ADDED);
				event.setAddedElement(umlFunction);
				dispatchEvent(event);
			}
		}
		
		protected function addClassifer(classifier:IUmlModelClassifier):void
		{
			if (classifier == null)
			{
				return;
			}
			
			_nestedClassifiers.push(classifier);
			
			classifier.owner = this;
			
			var event:UmlEvent = new UmlEvent(UmlEvent.CLASSIFIER_ADDED);
			event.setAddedElement(classifier);
			dispatchEvent(event);
		}
		
		public override function edit(newElement:IUmlModelElement) : void
		{
			if (newElement == null || !(newElement is UmlModelClass))
			{
				return;
			}
			
			var newClass:UmlModelClass = newElement as UmlModelClass
			
			this.name			= newClass.name;
			this.visibility		= newClass.visibility;
			
			var event:UmlEvent = new UmlEvent(UmlEvent.ELEMENT_EDITED);
			event.setEditedNode(this);
			dispatchEvent(event);
		}
		
		/**
		 * remove an element from the model
		 * 
		 * @param element : the element to delete from the model
		 * 
		 */
		public override function removeElement(element:IUmlModelElement) : void
		{
			var elements:Array = null;
			
			if (element is IUmlModelClassifier)
			{
				elements = nestedClassifiers;
			}
			else if (element is UmlModelProperty)
			{
				elements = ownedAttributes;
			}
			else if (element is UmlModelOperation)
			{
				elements = ownedOperations;
			}
			
			if (elements != null)
			{
				if (element != null && elements.indexOf(element) >= 0)
				{
					delete elements.splice(elements.indexOf(element), 1);
					
					element.owner = null;
					
					var event:UmlEvent = new UmlEvent(UmlEvent.ELEMENT_DELETED);
					event.setDeletedNode(element);
					dispatchEvent(event);
				}
			}
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public override function get ownedElements():Array
		{
			var elements:Array = [];
			
			if (super.ownedElements != null)
			{
				elements = elements.concat(super.ownedElements);
			}
			
			if (nestedClassifiers != null)
			{
				elements = elements.concat(nestedClassifiers);
			}
			
			return elements;
		}
		
		/**
		 * References all the Classifiers that are defined (nested) within 
		 * the Class. Subsets Element::ownedElements
		 */
		public function get nestedClassifiers():Array
		{
			return _nestedClassifiers;
		}
		
		override public function get attributes():Array
		{
			var elements:Array = [];
			
			if (super.attributes != null)
			{
				elements = elements.concat(super.attributes);
			}
			
			if (ownedAttributes != null)
			{
				elements = elements.concat(ownedAttributes);
			}
			
			return elements;
		}
		
		override public function get ownedMembers():Array
		{
			var elements:Array = [];
			
			if (super.ownedMembers != null)
			{
				elements = elements.concat(super.ownedMembers);
			}
			
			if (ownedAttributes != null)
			{
				elements = elements.concat(ownedAttributes);
			}
			
			if (ownedOperations != null)
			{
				elements = elements.concat(ownedOperations);
			}
			
			return elements;
		}
		
		/**
		 * The attributes (i.e., the properties) owned by the class. 
		 * The association is ordered. 
		 * Subsets Classifier::attribute and Namespace::ownedMember
		 */
		public function get ownedAttributes():Array
		{
			return _ownedAttributes;
		}
		
		/**
		 * The operations owned by the class. The association is ordered. 
		 * Subsets Classifier::feature and Namespace::ownedMember
		 */
		public function get ownedOperations():Array
		{
			return _ownedOperations;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		override public function get features():Array
		{
			var elements:Array = [];
			
			if (super.features != null)
			{
				elements = elements.concat(super.features);
			}
			
			if (ownedAttributes != null)
			{
				elements = elements.concat(ownedAttributes);
			}
			
			if (ownedOperations != null)
			{
				elements = elements.concat(ownedOperations);
			}
			
			return elements;
		}
		
	}
	
}
