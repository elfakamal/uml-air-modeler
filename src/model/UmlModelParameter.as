package model
{
	import controler.events.UmlEvent;
	
	import flash.errors.IllegalOperationError;
	
	
	/**
	 * 
	 * A parameter is a specification of an argument used to pass information 
	 * into or out of an invocation of a behavioral feature. It has a type, 
	 * and may have a multiplicity and an optional default value.
	 * 
	 * @author EL FARSAOUI kamal
	 * 
	 */
	internal class	UmlModelParameter 
		extends		UmlModelNamedElement
		implements	IUmlModelTypedElement, 
					IUmlModelMultiplicityElement
	{
		
		/**
		 * 
		 */
		protected var _type				:IUmlModelType					= null;
		
		/**
		 * Indicates whether a parameter is being sent into or out 
		 * of a behavioral element. 
		 * The default value is in. 
		 */
		protected var _direction		:UmlModelParameterDirectionKind	= 
											UmlModelParameterDirectionKind.$in;
		
		/**
		 * Specifies a ValueSpecification that represents a value to be used 
		 * when no argument is supplied for the Parameter. 
		 * Subsets Element::ownedElement
		 */
		protected var _defaultValue		:UmlModelValueSpecification		= null;
		
		protected var _lowerValue		:UmlModelValueSpecification		= null;
		protected var _upperValue		:UmlModelValueSpecification		= null;
		
		
		
		public function UmlModelParameter(
								p_uid				:String, 
								p_name				:String, 
								p_visibility		:UmlModelVisibilityKind = null)
		{
			super(p_uid, p_name, p_visibility);
		}
		
		public override function edit(newElement:IUmlModelElement) : void
		{
			if (newElement != null && (newElement is UmlModelParameter))
			{
				var newParameter:UmlModelParameter = newElement as UmlModelParameter;
				
				this.name			= newParameter.name;
				this.type			= newParameter.type;
				this.visibility		= newParameter.visibility;
				this.direction		= newParameter.direction;
				this.defaultValue	= newParameter.defaultValue;
				
				var event:UmlEvent = new UmlEvent(UmlEvent.ELEMENT_EDITED);
				event.setEditedNode(this);
				UmlModel.getInstance().dispatchEvent(event);
			}
		}
		
		/**
		 * Specifies a String that represents a value to be used when 
		 * no argument is supplied for the Parameter. 
		 * This is a derived value.
		 */
		public function get $default():String
		{
			return "";
		}
		
		/**
		 * References the Operation owning this parameter. 
		 * Subsets NamedElement::namespace
		 */
		public function get operation():UmlModelOperation
		{
			return null;
		}
		
		override public function get $namespace():IUmlModelNamespace
		{
			if (operation != null)
			{
				return operation;
			}
			
			return super.$namespace;
		}
		
		override public function get ownedElements():Array
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
			
			return elements;
		}
		
		public function get direction():UmlModelParameterDirectionKind
		{
			return _direction;
		}
		public function set direction(value:UmlModelParameterDirectionKind):void
		{
			_direction = value;
		}
		
		public function get defaultValue():UmlModelValueSpecification
		{
			return _defaultValue;
		}
		public function set defaultValue(value:UmlModelValueSpecification):void 
		{
			_defaultValue = value;
		}
		
		
		/* INTERFACE model.IUmlModelTypedElement */
		
		public function set type(value:IUmlModelType):void
		{
			_type = value;
		}
		public function get type():IUmlModelType
		{
			return _type;
		}
		
		public override function get xml():XML
		{
			_xml = <umlParameter 
							id			={uid} 
							name		={name} 
							type		={type.toString()}/>;
			return _xml;
		}
		
		
		/* INTERFACE model.IUmlModelMultiplicityElement */
		
		public function set isOredred(value:Boolean):void
		{
			
		}
		public function get isOredred():Boolean
		{
			return false;
		}
		
		public function set isUnique(value:Boolean):void
		{
			
		}
		public function get isUnique():Boolean
		{
			return false;
		}
		
		public function set lowerValue(value:UmlModelValueSpecification):void
		{
			if (value is UmlModelLiteralInteger || value is UmlModelLiteralNull) 
			{
				if (value.integerValue > _upperValue.integerValue)
				{
					throw new IllegalOperationError("the lower value is upper " + 
													"than the upper value");
				}
				else
				{
					_lowerValue = value;
				}
			}
		}
		public function get lowerValue():UmlModelValueSpecification
		{
			return _lowerValue;
		}
		
		public function set upperValue(value:UmlModelValueSpecification):void
		{
			if (value is UmlModelLiteralInteger || 
				value is UmlModelLiteralUnlimitedNatural ||
				value is UmlModelLiteralNull) 
			{
				if (_lowerValue.integerValue > value.integerValue)
				{
					throw new IllegalOperationError("the lower value is upper " + 
													"than the upper value");
				}
				else
				{
					_upperValue = value;
				}
			}
		}
		public function get upperValue():UmlModelValueSpecification
		{
			return _upperValue;
		}
		
		public function toMultiplicityString():String
		{
			var strMultiplicity		:String = "";
			var strLower			:String = "";
			var strUpper			:String = "";
			
			if (lowerBound() >= 0 && upperBound() > 0)
			{
				strLower = String(lowerBound());
				strUpper = String(upperBound());
				
				if (upperBound() == Infinity)
				{
					strUpper = "*";
				}
				
				strMultiplicity = "[" + strLower + ".." + strUpper + "]";
			}
			else if (lowerBound() > 0 && upperBound() <= 0)
			{
				strMultiplicity = "[" + strLower + "]";
			}
			
			return strMultiplicity;
		}
		
		public function lowerBound():int
		{
			if (lowerValue != null)
			{
				return lowerValue.integerValue;
			}
			
			return 0;
		}
		
		public function upperBound():Number
		{
			if (upperValue != null)
			{
				return upperValue.unlimitedValue;
			}
			
			return 0;
		}
		
		public function isMultivalued():Boolean
		{
			return false;
		}
		
		public function includesCardinality(cardinality:int):Boolean
		{
			return false;
		}
		
		public function includesMultiplicity
							(multiplicity:IUmlModelMultiplicityElement):Boolean
		{
			return false;
		}
		
	}
	
}
