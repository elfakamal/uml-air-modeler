package model
{
	import mx.controls.List;
	
	public class UmlConstructorFactory extends UmlFunctionFactory
	{
		
		public function UmlConstructorFactory(name:String, parameterList:Array = null)
		{
			super(name, "public", "", true, parameterList);
		}
		
		protected override function factoryCreateNode():IUmlModelNode
		{
			return new UmlModelConstructor(_id, _name, _parametersList);
		}
	}
}
