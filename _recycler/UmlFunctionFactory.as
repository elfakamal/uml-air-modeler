package model
{
	
	public class UmlFunctionFactory// extends UmlLevel3Factory
	{
		
		protected var _parametersList		:Array			= null;
		
		public function UmlFunctionFactory(
								name				:String, 
								accessor			:String, 
								type				:String, 
								isMember			:Boolean = true,  
								parametersList		:Array = null
						)
		{
	//		super(name, accessor, type, isMember);
			
		//	_parametersList = (parametersList) ? parametersList : new Array(); 
		}
		
//		protected override function factoryCreateNode():IUmlModelNode
//		{
//			return new UmlModelFunction(_id, _name, _accessor, _type, _isMember, _parametersList);
//		}
		
	}
}