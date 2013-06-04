package model 
{
	import model.UmlModelDataType;
	import model.UmlModelVisibilityKind;
	
	/**
	 * A primitive type defines a predefined data type, without any relevant 
	 * substructure (i.e., it has no parts in the context of UML). 
	 * A primitive datatype may have an algebra and operations defined outside 
	 * of UML, for example, mathematically.
	 * 
	 * The instances of primitive type used in UML itself include Boolean, 
	 * Integer, UnlimitedNatural, and String.
	 * 
	 * @author EL FARSAOUI Kamal
	 * 
	 */
	internal class UmlModelPrimitiveType extends UmlModelDataType
	{
		
		public function UmlModelPrimitiveType(
								p_uid			:String, 
								p_name			:String, 
								p_visibility	:UmlModelVisibilityKind = null) 
		{
			super(p_uid, p_name, p_visibility);
		}
		
	}
	
}
