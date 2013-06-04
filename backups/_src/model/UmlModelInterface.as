package model
{
	import controler.events.UmlEvent;
	
	
	/**
	 * 
	 * An interface is a kind of classifier that represents a declaration 
	 * of a set of coherent public features and obligations. An interface 
	 * specifies a contract; any instance of a classifier that realizes 
	 * the interface must fulfill that contract. The obligations that may be 
	 * associated with an interface are in the form of various kinds 
	 * of constraints (such as pre- and post-conditions) or protocol 
	 * specifications, which may impose ordering restrictions on interactions 
	 * through the interface. 
	 * 
	 * Since interfaces are declarations, they are not instantiable. Instead, 
	 * an interface specification is implemented by an instance of an instantiable 
	 * classifier, which means that the instantiable classifier presents 
	 * a public facade that conforms to the interface specification. Note that 
	 * a given classifier may implement more than one interface and that 
	 * an interface may be implemented by a number of different classifiers 
	 * (see �InterfaceRealization (from Interfaces)� on page 89).
	 * 
	 * for more infos see Uml specs.
	 * 
	 * @author kamal
	 * 
	 */
	internal class UmlModelInterface extends UmlModelClassifier
	{
		
		/**
		 * References all the properties owned by the Interface. 
		 * (Subsets Namespace::ownedMember and Classifier::feature)
		 */
		protected var _ownedAttributes			:Array		= null;
		
		/**
		 * References all the operations owned by the Interface. 
		 * (Subsets Namespace::ownedMember and Classifier::feature)
		 */
		protected var _ownedOperations			:Array		= null;
		
		/**
		 * (References all the Classifiers owned by the Interface. 
		 * (Subsets Namespace::ownedMember)
		 */
		protected var _nestedClassifiers		:Array		= null;
		
		/**
		 * (References all the Interfaces redefined by this Interface. 
		 * (Subsets Element::redefinedElement)
		 */
		protected var _redefinedInterface		:Array		= null;
		
		
		public function UmlModelInterface(
								p_uid				:String, 
								p_name				:String, 
								p_visibility		:UmlModelVisibilityKind = null
							)
		{
			super(p_uid, p_name, p_visibility);
		}
		
		/**
		 * constraint : 
		 * The visibility of all features owned by an interface must be public.
		 * self.feature->forAll(f | f.visibility = #public)
		 */
		public override function addElement(element:IUmlModelElement):void
		{
			if (element != null)
			{
				var event:UmlEvent = null;
				
				if (element is UmlModelFeature)
				{
					if (UmlModelFeature(element).visibility != UmlModelVisibilityKind.$public)
					{
						return;
					}
					
					if (element is UmlModelProperty)
					{
						_ownedAttributes.push(element);
						
						event = new UmlEvent(UmlEvent.ATTRIBUTE_ADDED);
						event.setAddedAttribute(element.xml);
						UmlModel.getInstance().dispatchEvent(event);
					}
					else if (element is UmlModelOperation)
					{
						_ownedOperations.push(element);
						
						event = new UmlEvent(UmlEvent.OPERATION_ADDED);
						event.setAddedFunction(element.xml);
						UmlModel.getInstance().dispatchEvent(event);
					}
				}
				else if (element is IUmlModelClassifier)
				{
					_nestedClassifiers.push(element);
					
					event = new UmlEvent(UmlEvent.CLASSIFIER_ADDED);
					event.setAddedClassifier(element.xml);
					UmlModel.getInstance().dispatchEvent(event);
				}
			}
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public override function get xml():XML
		{
			_xml = <umlInterface 
						id				= {uid} 
						name			= {name} 
						visibility		= {visibility.toString()}  />;
			
			if (ownedElements && ownedElements.length > 0)
			{
				var functionXml:XML = <functions />;
				for (var i:int = 0; i < ownedElements.length; i++)
				{
					var umlFunction:UmlModelFeature = UmlModelFeature(ownedElements[i]);
					functionXml.appendChild(umlFunction.xml);
				}
				_xml.appendChild(functionXml);
			}
			
			return _xml;
		}
		
		public function get ownedAttributes():Array
		{
			return _ownedAttributes;
		}
		public function set ownedAttributes(value:Array):void 
		{
			_ownedAttributes = value;
		}
		
		public function get ownedOperations():Array
		{
			return _ownedOperations;
		}
		public function set ownedOperations(value:Array):void 
		{
			_ownedOperations = value;
		}
		
		public function get nestedClassifiers():Array
		{
			return _nestedClassifiers;
		}
		public function set nestedClassifiers(value:Array):void 
		{
			_nestedClassifiers = value;
		}
		
		public function get redefinedInterface():Array
		{
			return _redefinedInterface;
		}
		public function set redefinedInterface(value:Array):void 
		{
			_redefinedInterface = value;
		}
		
		//subsetting
		//from Namespace
		override public function get ownedMembers():Array
		{
			var elements:Array = new Array();
			
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
			
			if (nestedClassifiers != null)
			{
				elements = elements.concat(nestedClassifiers);
			}
			
			return elements;
		}
		
		//subsetting
		//from Classifier
		override public function get redefinedElements():Array
		{
			var elements:Array = [];
			
			if (super.redefinedElements)
			{
				elements = elements.concat(super.redefinedElements);
			}
			
			if (redefinedClassifiers != null)
			{
				return elements.concat(redefinedClassifiers);
			}
			
			return elements;
		}
		
	}
	
}
