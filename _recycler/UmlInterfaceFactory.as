package model
{
	public class UmlInterfaceFactory extends UmlNodeFactory
	{
		
		private var _functionsList				:Array				= null;
		private var _constantsList				:Array				= null;
		private var _extendedNodes				:Array				= null;
		
		public function UmlInterfaceFactory(
								name					:String, 
								accessor				:String, 
								extendedNodes			:Array				= null, 
								functionsList			:Array				= null, 
								constantsList			:Array				= null
						)
		{
			//super(name, accessor);
			
			
			_extendedNodes = (extendedNodes) ? extendedNodes : new Array();
			_functionsList = (functionsList) ? functionsList : new Array();
			_constantsList = (constantsList) ? constantsList : new Array();
		}
		
		protected override function factoryCreateNode():IUmlModelNode
		{
			//return new UmlModelInterface(_id, _name, _accessor, _extendedNodes, _functionsList, _constantsList);
			return null;
		}
		
	}
}