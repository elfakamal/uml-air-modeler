package model
{
	import controler.UmlControler;
	
	import flash.errors.IllegalOperationError;
	
	public class UmlNodeFactory
	{
		
		public function UmlNodeFactory()
		{
			
		}
		
		public function createNode():IUmlModelNode
		{
			var node:IUmlModelNode = this.factoryCreateNode();
			return node;
		}
		
		protected function factoryCreateNode():IUmlModelNode
		{
			throw new IllegalOperationError("createNode is abstract method : must be called in subclass");
			return null;
		}
		
	}
}
