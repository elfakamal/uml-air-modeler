package model
{
	
	/**
	 * An expression represents a node in an expression tree, which may 
	 * be non-terminal or terminal. It defines a symbol, and has a possibly 
	 * empty sequence of operands that are value specifications.
	 * 
	 * @author kamal
	 * 
	 */
	internal class UmlModelExpression extends UmlModelValueSpecification
	{
		
		protected var _symbol			:String				= "";
		protected var _operands			:Array				= null;  
		
		/**
		 * 
		 * 
		 */
		public function UmlModelExpression(
									p_uid				:String, 
									p_name				:String, 
									p_visibility		:UmlModelVisibilityKind = null)
		{
			super(p_uid, p_name, p_visibility);
		}
		
		public function set symbol(value:String):void
		{
			_symbol = value;
		}
		public function get symbol():String
		{
			return _symbol;
		}
		
		public function set operands(value:Array):void
		{
			_operands		= value;
		}
		public function get operands():Array
		{
			return _operands;
		}
		
		public override function get ownedElements():Array
		{
			var elements:Array = [];
			
			if (super.ownedElements != null)
			{
				elements = elements.concat(super.ownedElements);
			}
			
			if (operands != null)
			{
				elements = elements.concat(operands);
			}
			
			return elements;
		}
		
	}
	
}
