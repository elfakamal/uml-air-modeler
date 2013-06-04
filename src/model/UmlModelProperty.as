package model
{
	import controler.events.UmlEvent;
	import controler.serialization.XmiController;
	
	import flash.errors.IllegalOperationError;
	
	
	/**
	 * 
	 * @author kamal
	 * 
	 */
	internal class UmlModelProperty extends UmlModelStructuralFeature
	{
		
		/**
		 * Specifies the kind of aggregation that applies to the Property. 
		 * The default value is none.
		 */
		protected var _aggregation:UmlModelAggregationKind = 
												UmlModelAggregationKind.none;
		
		/**
		 * Specifies whether the Property is derived, i.e., whether its value 
		 * or values can be computed from other information. 
		 * The default value is false
		 */
		protected var _isDerived			:Boolean					= false;
		
		/**
		 * indicates whether it is possible to navigate across the property.
		 */		
		protected var _isNavigable			:Boolean					= false;
		
		/**
		 * Specifies whether the property is derived as the union of all 
		 * of the properties that are constrained to subset it. 
		 * The default value is false.
		 */
		protected var _isDerivedUnion		:Boolean					= false;
		
		/**
		 * References the association of which this property is a member, if any
		 */
		protected var _association			:UmlModelAssociation		= null;
		
		/**
		 * References the owning association of this property. 
		 * Subsets : 
		 * 
		 * Property::association, 
		 * NamedElement::namespace, 
		 * Feature::featuringClassifier, and 
		 * RedefinableElement::redefinitionContext.
		 */
		protected var _owningAssociation	:UmlModelAssociation		= null;
		
		/**
		 * The DataType that owns this Property. 
		 * Subsets : 
		 * 
		 * NamedElement::namespace, 
		 * Feature::featuringClassifier, and 
		 * Property::classifier
		 */
		protected var _dataType				:UmlModelDataType			= null;
		
		/**
		 * A ValueSpecification that is evaluated to give a default value 
		 * for the Property when an object of the owning Classifier 
		 * is instantiated. 
		 * 
		 * Subsets Element::ownedElement.
		 */
		protected var _defaultValue			:UmlModelValueSpecification	= null;
		
		/**
		 * References the properties that are redefined by this property. 
		 * Subsets RedefinableElement::redefinedElement.
		 */
		protected var _redefinedProperties	:Array						= null;
		
		/**
		 * References the properties of which this property is constrained 
		 * to be a subset.
		 */
		protected var _subsettedProperties	:Array						= null;
		
		/**
		 * References the Class that owns the Property. 
		 * Subsets NamedElement::namespace, Feature::featuringClassifier
		 */
		protected var _class				:UmlModelClass				= null;
		
		/**
		 * Designates the optional association end that owns a qualifier 
		 * attribute. 
		 * Subsets Element::owner
		 */
		protected var _associationEnd		:UmlModelProperty			= null;
		
		/**
		 * An optional list of ordered qualifier attributes for the end. 
		 * If the list is empty, then the Association is not qualified. 
		 * Subsets Element::ownedElement
		 */
		protected var _qualifier			:UmlModelProperty			= null;
		
		
		public function UmlModelProperty(
								p_uid				:String, 
								p_name				:String, 
								p_visibility		:UmlModelVisibilityKind = null)
		{
			super(p_uid, p_name, p_visibility);
		}
		
		public override function get xml():XML
		{
			_xml = <umlAttribute 
						id			={uid} 
						name		={name} 
						visibility	={visibility.toString()} 
						type		={type.toString()} />;
			
			return _xml;
		}
		
		/**
		 * 
		 * <UML:Attribute 
		 * 		xmi.id="DCE.77CDD30A-8021-82FC-7035-35962C84E63B" 
		 * 		visibility="private" 
		 * 		name="nomLangue" 
		 * 		type="DCE.FC61298D-ED88-2F36-9174-8D14876C7D63" 
		 * 		owner="DCE.708C9384-2770-C337-8D12-C957484D3B6A">
		 * 
		 * 	<UML:Element.presentation></UML:Element.presentation>
		 * 
		 * 	<UML:TypedElement.multiplicity>
		 * 		<UML:Multiplicity xmi.id="DCE.6982AF02-5BD7-BAE6-30DB-7F7102D061C1"/>
		 * 	</UML:TypedElement.multiplicity>
		 * 	
		 * 	<UML:Attribute.default>
		 * 		<UML:Expression xmi.id="DCE.1DF9FA20-3CCD-5E60-005B-220B08D2B6B6"/>
		 * 	</UML:Attribute.default>
		 * 	
		 * </UML:Attribute>
		 * 
		 * 
		 */
		public override function get xmi() : XML
		{
			var prefix:String = XmiController.UML.prefix + ":";
			
			_xmi = <Attribute 
							id={uid}
							visibility={visibility.toString()}
							name={name} 
							type={type.uid} 
							owner={owner.uid} />;
			
//			XmiController.getInstance().setAttributeXmiNamespace(_xmi, 0);
//			XmiController.getInstance().addUmlNamspace(_xmi);
			
			return _xmi;
		}
		
		public function setMultiplicity(multiplicity:Array):void
		{
			if (multiplicity != null && multiplicity.length == 2)
			{
				if (multiplicity[0] != null && multiplicity[1] != null)
				{
					lowerValue = multiplicity[0];
					upperValue = multiplicity[1];
				}
			}
		}
		
		public override function edit(newElement:IUmlModelElement):void
		{
			if (newElement != null && (newElement is UmlModelProperty))
			{
				var newProperty:UmlModelProperty = newElement as UmlModelProperty;
				
				this.name			= newProperty.name;
				this.type			= newProperty.type;
				this.visibility		= newProperty.visibility;
				
				this.lowerValue		= newProperty.lowerValue;
				this.upperValue		= newProperty.upperValue;
				
				var event:UmlEvent = new UmlEvent(UmlEvent.ELEMENT_EDITED);
				event.setEditedNode(this);
				dispatchEvent(event);
			}
		}
		
		public override function addElement(umlNode:IUmlModelElement):void
		{
			throw new IllegalOperationError("a property does not contain nodes");
		}
		
		public override function removeElement(umlNode:IUmlModelElement):void
		{
			throw new IllegalOperationError("a property does not contain nodes");
		}
		
		public override function get ownedElements():Array
		{
			var elements:Array = [];
			
			if (super.ownedElements != null)
			{
				elements = elements.concat(super.ownedElements);
			}
			
			if (defaultValue != null)
			{
				elements.push(defaultValue);
			}
			
			if (qualifier != null)
			{
				elements.push(qualifier);
			}
			
			return elements;
		}
		
		override public function get owner():IUmlModelElement
		{
			if (associationEnd != null)
			{
				return associationEnd;
			}
			
			return super.owner;
		}
		
		override public function get redefinitionContexts():Array
		{
			var elements:Array = [];
			
			if (super.redefinitionContexts != null)
			{
				elements = elements.concat(super.redefinitionContexts);
			}
			
			if (owningAssociation != null)
			{
				elements.push(owningAssociation);
			}
			
			return elements;
		}
		
		override public function get $namespace():IUmlModelNamespace
		{
			if (dataType != null)
			{
				return dataType;
			}
			else if (owningAssociation != null)
			{
				return owningAssociation;
			}
			
			return super.$namespace;
		}
		
		override public function get featuringClassifiers():Array
		{
			var elements:Array = [];
			
			if (super.featuringClassifiers != null)
			{
				elements = elements.concat(super.featuringClassifiers);
			}
			
			if (dataType != null)
			{
				elements.push(dataType);
			}
			else if (owningAssociation != null)
			{
				elements.push(owningAssociation);
			}
			else if ($class != null)
			{
				
			}
			
			return elements;
		}
		
		override public function get redefinedElements():Array
		{
			var elements:Array = [];
			
			if (super.redefinedElements != null)
			{
				elements = elements.concat(super.redefinedElements);
			}
			
			if (redefinedProperties != null)
			{
				elements = elements.concat(redefinedProperties);
			}
			
			return redefinedProperties;
		}
		
		public override function isConsistentWith
									(element:IUmlModelRedefinableElement):Boolean
		{
			return false;
		}
		
		public function subsettingContext():Array
		{
			return null;
		}
		
		public override function setNavigable(value:Boolean):void
		{
			_isNavigable = value;
		}
		public override function isNavigable():Boolean
		{
			return _isNavigable;
		}
		
		public static function isAttribute(property:UmlModelProperty):Boolean
		{
			return true;
		}
		
		public function get aggregation():UmlModelAggregationKind
		{
			return _aggregation;
		}
		public function set aggregation(value:UmlModelAggregationKind):void 
		{
			_aggregation = value;
		}
		
		public function get $default():String
		{
			return "";
		}
		
		/**
		 * is a derived value
		 */
		public function get isComposite():Boolean
		{
			return false;
		}
		
		public function get isDerived():Boolean
		{
			return _isDerived;
		}
		public function set isDerived(value:Boolean):void 
		{
			_isDerived = value;
		}
		
		public function get isDerivedUnion():Boolean
		{
			return _isDerivedUnion;
		}
		public function set isDerivedUnion(value:Boolean):void 
		{
			_isDerivedUnion = value;
		}
		
		public function get association():UmlModelAssociation
		{
			if (owningAssociation != null)
			{
				return owningAssociation;
			}
			
			return _association;
		}
		public function set association(value:UmlModelAssociation):void 
		{
			_association = value;
			owningAssociation = _association;
		}
		
		public function get owningAssociation():UmlModelAssociation
		{
			return _owningAssociation;
		}
		public function set owningAssociation(value:UmlModelAssociation):void 
		{
			_owningAssociation = value;
		}
		
		public function get dataType():UmlModelDataType
		{
			return _dataType;
		}
		public function set dataType(value:UmlModelDataType):void 
		{
			_dataType = value;
		}
		
		public function get defaultValue():UmlModelValueSpecification
		{
			return _defaultValue;
		}
		public function set defaultValue(value:UmlModelValueSpecification):void 
		{
			_defaultValue = value;
		}
		
		public function get redefinedProperties():Array
		{
			return _redefinedProperties;
		}
		public function set redefinedProperties(value:Array):void 
		{
			_redefinedProperties = value;
		}
		
		public function get subsettedProperties():Array
		{
			return _subsettedProperties;
		}
		public function set subsettedProperties(value:Array):void 
		{
			_subsettedProperties = value;
		}
		
		/**
		 * In the case where the property is one navigable end of a binary 
		 * association with both ends navigable, this gives the other end.
		 */
		public function get opposite():UmlModelProperty
		{
			return null;
		}
		
		public function get $class():UmlModelClass
		{
			return _class;
		}
		public function set $class(value:UmlModelClass):void 
		{
			_class = value;
		}
		
		public function get associationEnd():UmlModelProperty
		{
			return _associationEnd;
		}
		public function set associationEnd(value:UmlModelProperty):void 
		{
			_associationEnd = value;
		}
		
		public function get qualifier():UmlModelProperty
		{
			return _qualifier;
		}
		public function set qualifier(value:UmlModelProperty):void 
		{
			_qualifier = value;
		}
		
	}
	
}
