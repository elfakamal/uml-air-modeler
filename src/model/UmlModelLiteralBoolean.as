package model 
{
	import model.UmlModelLiteralSpecification;
	import model.UmlModelVisibilityKind;
	
	/**
	 * A literal Boolean is a specification of a Boolean value.
	 * A literal Boolean contains a Boolean-valued attribute. 
	 * Default value is false
	 * 
	 * @author EL FARSAOUI Kamal
	 * 
	 */
	public class UmlModelLiteralBoolean extends UmlModelLiteralSpecification
	{
		
		/**
		 * The specified Boolean value
		 */
		protected var _value			:Boolean		= false;
		
		
		public function UmlModelLiteralBoolean(
								p_uid			:String, 
								p_name			:String, 
								p_visibility	:UmlModelVisibilityKind = null) 
		{
			super(p_uid, p_name, p_visibility);
		}
		
		/**
		 * Uml specs : this function is redefined to be true.
		 */
		override public function get isComputable():Boolean
		{
			return true;
		}
		override public function set isComputable(value:Boolean):void 
		{
			super.isComputable = true;
		}
		
		public function get value():Boolean
		{
			return _value;
		}
		public function set value(value:Boolean):void 
		{
			_value = value;
		}
		
		/**
		 * A LiteralBoolean is shown as either the word "true" or the word "false", 
		 * corresponding to its value.
		 * 
		 * @return
		 */
		public function toString():String 
		{
			return value.toString();
		}
		
	}

}
