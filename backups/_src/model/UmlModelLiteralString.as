package model 
{
	import model.UmlModelLiteralInteger;
	import model.UmlModelVisibilityKind;
	
	/**
	 * 
	 * @author EL FARSAOUI Kamal
	 * 
	 */
	public class UmlModelLiteralString extends UmlModelLiteralSpecification
	{
		
		/**
		 * 
		 */
		protected var _value:String = "";
		
		public function UmlModelLiteralString(
								p_uid			:String, 
								p_name			:String, 
								p_visibility	:UmlModelVisibilityKind = null) 
		{
			super(p_uid, p_name, p_visibility);
		}
		
		public function get value():String
		{
			return _value;
		}
		public function set value(value:String):void 
		{
			_value = value;
		}
		
		override public function get integerValue():int
		{
			return 0;
		}
		
		override public function get unlimitedValue():Number
		{
			return 0;
		}
		
		override public function get booleanValue():Boolean
		{
			return (value != null);
		}
		
		override public function get stringValue():String
		{
			return value;
		}
		
		override public function get isNull():Boolean
		{
			return !booleanValue;
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