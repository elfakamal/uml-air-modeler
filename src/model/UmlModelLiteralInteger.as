package model 
{
	import model.UmlModelLiteralSpecification;
	import model.UmlModelVisibilityKind;
	
	/**
	 * 
	 * @author EL FARSAOUI Kamal
	 * 
	 */
	public class UmlModelLiteralInteger extends UmlModelLiteralSpecification
	{
		
		/**
		 * 
		 */
		//protected var _value:int = 0;
		
		
		public function UmlModelLiteralInteger(
								p_uid			:String, 
								p_name			:String, 
								p_visibility	:UmlModelVisibilityKind = null) 
		{
			super(p_uid, p_name, p_visibility);
		}
		
		public function get value():int
		{
			return _value;
		}
		public function set value(value:int):void 
		{
			_value = value;
		}
		
		override public function get integerValue():int
		{
			return value;
		}
		
		override public function get unlimitedValue():Number
		{
			return Number(value);
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
//		public function set isComputable(value:Boolean):void 
//		{
//			//super.isComputable = true;
//		}
		
	}

}
