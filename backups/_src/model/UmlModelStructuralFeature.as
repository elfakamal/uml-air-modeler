package model
{
	import controler.errors.UmlError;
	
	import flash.errors.IllegalOperationError;
	
	
	/**
	 * A structural feature is a typed feature of a classifier that specifies 
	 * the structure of instances of the classifier. 
	 * 
	 * Structural feature is an abstract metaclass.
	 * 
	 * By specializing multiplicity element, it supports a multiplicity that 
	 * specifies valid cardinalities for the collection of values associated 
	 * with an instantiation of the structural feature.
	 * 
	 * @author kamal
	 * 
	 */
	internal class	UmlModelStructuralFeature 
		extends		UmlModelFeature 
		implements	IUmlModelMultiplicityElement, 
					IUmlModelTypedElement
	{
		
		/**
		 * States whether the features value may be modified by a client.
		 * 
		 * Default is false.
		 */
		protected var _isReadOnly			:Boolean		= false;
		
		protected var _isOrdered			:Boolean		= false;
		protected var _isUnique				:Boolean		= false;
		
		protected var _lowerValue			:UmlModelValueSpecification	= null;
		protected var _upperValue			:UmlModelValueSpecification	= null;
		
		protected var _lowerBound			:int			= 0;
		protected var _upperBound			:Number			= 0;
		
		protected var _isMultivalued		:Boolean		= false;
		protected var _includesCardinality	:Boolean		= false;
		protected var _includesMultiplicity	:Boolean		= false;
		
		
		
		/**
		 * 
		 * @param id
		 * @param name
		 * 
		 */
		public function UmlModelStructuralFeature(
								p_uid				:String, 
								p_name				:String, 
								p_visibility		:UmlModelVisibilityKind = null)
		{
			super(p_uid, p_name, p_visibility);
		}
		
		public function set isReadOnly(value:Boolean):void
		{
			_isReadOnly = value;
		}
		public function get isReadOnly():Boolean
		{
			return _isReadOnly;
		}
		
		public override function get xml():XML
		{
			return null;
		}
		
		/***********************************************************************
		 * 
		 * IUmlModelMultiplicityElement functions
		 * 
		 */
		public function set isOredred(value:Boolean):void
		{
			_isOrdered = value;
		}
		public function get isOredred():Boolean
		{
			return _isOrdered;
		}
		
		public function set isUnique(value:Boolean):void
		{
			_isUnique = value;
		}
		public function get isUnique():Boolean
		{
			return _isUnique;
		}
		
		public function set lowerValue(value:UmlModelValueSpecification):void
		{
			var error:UmlError = null;
			
			if (value == null)
			{
				//TODO: create an UmlError here
				error = new UmlError(	"the lower value is upper" + 
										"than the upper value");
				
				return;
			}
			
			if (value is UmlModelLiteralInteger || value is UmlModelLiteralNull) 
			{
				if (_upperValue != null && value.integerValue > _upperValue.integerValue)
				{
					//TODO: create an UmlError here
					error = new UmlError(	"the lower value is upper" + 
											"than the upper value");
					
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
		
		/**
		 * 
		 * @throws IllegalOperationError
		 * @param value
		 * 
		 */
		public function set upperValue(value:UmlModelValueSpecification):void
		{
			var isValueValid	:Boolean	= false;
			var error			:UmlError	= null;
			
			if (value == null)
			{
				//TODO: create an UmlError here
				error = new UmlError(	"the lower value is upper" + 
										"than the upper value");
				return;
			}
			
			if (value is UmlModelLiteralUnlimitedNatural)
			{
				if (_lowerValue != null && _lowerValue.integerValue > value.unlimitedValue)
				{
					//TODO: create an UmlError here
					error = new UmlError(	"the lower value is upper" + 
											"than the upper value");
					
					throw new IllegalOperationError("the lower value is upper " + 
													"than the upper value");
					return;
				}
				
				isValueValid = true;
			}
			
			if (value is UmlModelLiteralInteger)
			{
				if (_lowerValue != null && _lowerValue.integerValue > value.integerValue)
				{
					//TODO: create an UmlError here
					error = new UmlError(	"the lower value is upper" + 
											"than the upper value");
					
					throw new IllegalOperationError("the lower value is upper " + 
													"than the upper value");
					return;
				}
				
				isValueValid = true;
			}
			
			if (isValueValid)
			{
				_upperValue = value;
			}
		}
		public function get upperValue():UmlModelValueSpecification
		{
			return _upperValue;
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
				strLower = String(lowerBound());
				strMultiplicity = "[" + strLower + "]";
			}
			
			return strMultiplicity;
		}
		
		public function isMultivalued():Boolean
		{
			return _isMultivalued;
		}
		
		public function includesCardinality(cardinality:int):Boolean
		{
			return _includesCardinality;
		}
		
		public function includesMultiplicity(multiplicity:IUmlModelMultiplicityElement):Boolean
		{
			return _includesMultiplicity;
		}
		
	}
	
}
