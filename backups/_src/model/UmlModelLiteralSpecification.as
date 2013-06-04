package model 
{
	import model.UmlModelValueSpecification;
	import model.UmlModelVisibilityKind;
	
	/**
	 * 
	 * A literal specification identifies a literal constant being modeled
	 * A literal specification is an abstract specialization 
	 * of ValueSpecification that identifies a literal constant being modeled.
	 * 
	 * @author EL FARSAOUI Kamal
	 * 
	 */
	internal class UmlModelLiteralSpecification extends UmlModelValueSpecification
	{
		
		protected var _value:* = null;
		
		public function UmlModelLiteralSpecification(
										p_uid			:String, 
										p_name			:String, 
										p_visibility	:UmlModelVisibilityKind = null) 
		{
			super(p_uid, p_name, p_visibility);
		}
		
	}
	
}
