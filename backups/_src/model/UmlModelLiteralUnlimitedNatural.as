package model 
{
	import model.UmlModelLiteralSpecification;
	import model.UmlModelVisibilityKind;
	
	/**
	 * A literal unlimited natural is a specification of an unlimited natural 
	 * number.
	 * 
	 * @author EL FARSAOUI Kamal
	 * 
	 */
	public class UmlModelLiteralUnlimitedNatural extends UmlModelLiteralSpecification
	{
		
		
		public function UmlModelLiteralUnlimitedNatural(
								p_uid			:String, 
								p_name			:String, 
								p_visibility	:UmlModelVisibilityKind = null) 
		{
			super(p_uid, p_name, p_visibility);
		}
		
		public function get value():Number
		{
			return _value;
		}
		public function set value(numberOrAsterix:*):void 
		{
			if (numberOrAsterix is String && numberOrAsterix == "*")
			{
				_value = Infinity;
			}
			else if (numberOrAsterix is Number || numberOrAsterix is int)
			{
				_value = numberOrAsterix
			}
		}
		
		override public function get integerValue():int
		{
			return int(value);
		}
		
		override public function get unlimitedValue():Number
		{
			return value;
		}
		
		override public function get booleanValue():Boolean
		{
			return (value != 0);
		}
		
		override public function get stringValue():String
		{
			return String(value);
		}
		
		override public function get isNull():Boolean
		{
			return false;
		}
		
		/**
		 * Uml specs : this function is redefined to be true.
		 */
		override public function get isComputable():Boolean
		{
			return true;
		}
//		override public function set isComputable(value:Boolean):void 
//		{
//			super.isComputable = true;
//		}
		
	}
	
}
