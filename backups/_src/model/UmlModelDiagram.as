package model
{
	import flash.errors.IllegalOperationError;
	
	
	/**
	 * 
	 * @author kamal
	 * 
	 */
	internal class	UmlModelDiagram 
		extends		UmlModelNamedElement 
		implements	IUmlModelDiagram
	{
		
		public function UmlModelDiagram(id:String, name:String)
		{
			super(id, name);
		}
		
		public override function get xml():XML
		{
			return null;
		}
		
	}
	
}
