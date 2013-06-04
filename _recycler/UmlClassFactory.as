package model
{
	
	public class UmlClassFactory// extends UmlNodeFactory
	{
		
		protected var _constructor						:UmlModelFunction			= null;
		protected var _extendedNode						:String						= null;
		
		protected var _implementedInterfaces			:Array						= null;
		protected var _attributesList					:Array						= null;
		protected var _functionsList					:Array						= null;
		
		
		public function UmlClassFactory(
								name						:String, 
								accessor					:String,
								 
								//constructor					:UmlModelConstructor, 
								extendedNode				:String, 
								
								implementedInterfaces		:Array					= null, 
								attributesList				:Array					= null, 
							 	functionsList				:Array					= null 
						)
		{
//			super(name, accessor);
//			
//			_extendedNode				= extendedNode;//(extendedNode is UmlModelClass) ? extendedNode : null;
//			
//			_accessor					= accessor;
//			//_constructor				= constructor;
//			
//			_implementedInterfaces		= (implementedInterfaces)	? implementedInterfaces		: new Array();
//			_attributesList				= (attributesList)			? attributesList			: new Array();
//			_functionsList				= (functionsList)			? functionsList				: new Array();

		}
		
		
//		protected override function factoryCreateNode():IUmlModelNode
//		{
//			return new UmlModelClass(
//							_id, 
//							_name, 
//							_accessor, 
//							//_constructor, 
//							_extendedNode, 
//							_implementedInterfaces, 
//							_attributesList, 
//							_functionsList
//					);
//		}
		
	}
}
