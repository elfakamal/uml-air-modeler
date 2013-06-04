package model 
{
	import model.UmlModelLiteralSpecification;
	import model.UmlModelVisibilityKind;
	
	/**
	 * A literal null specifies the lack of a value.
	 * A literal null is used to represent null 
	 * (i.e., the absence of a value).
	 * 
	 * @author EL FARSAOUI Kamal
	 */
	public class UmlModelLiteralNull extends UmlModelLiteralSpecification
	{
		
		
		
		public function UmlModelLiteralNull(
								p_uid			:String, 
								p_name			:String, 
								p_visibility	:UmlModelVisibilityKind = null) 
		{
			super(p_uid, p_name, p_visibility);
		}
		
		public override function get isNull():Boolean
		{
			return true;
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