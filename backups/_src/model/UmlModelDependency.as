package model
{
	
	/**
	 * 
	 * A dependency is a relationship that signifies that a single or a set 
	 * of model elements requires other model elements for their specification 
	 * or implementation. This means that the complete semantics of the depending 
	 * elements is either semantically or structurally dependent on the definition 
	 * of the supplier element(s).
	 * 
	 * @author kamal
	 * 
	 */
	internal class UmlModelDependency extends UmlModelDirectedRelationship
	{
		
		/**
		 * The element(s) dependent on the supplier element(s). 
		 * In some cases (such as a Trace Abstraction) the assignment 
		 * of direction (that is, the designation of the client element) 
		 * is at the discretion of the modeler, and is a stipulation. 
		 * Subsets DirectedRelationship::source
		 */
		protected var _clients			:Array				= null;
		
		/**
		 * The element(s) independent of the client element(s), in the same 
		 * respect and the same dependency relationship. In some directed 
		 * dependency relationships (such as Refinement Abstractions), 
		 * a common convention in the domain of class-based OO software 
		 * is to put the more abstract element in this role. 
		 * 
		 * Despite this convention, users of UML may stipulate a sense 
		 * of dependency suitable for their domain, which makes a more 
		 * abstract element dependent on that which is more specific. 
		 * 
		 * Subsets DirectedRelationship::target. 
		 */
		protected var _suppliers		:Array				= null;
		
		/**
		 * 
		 */
		public function UmlModelDependency(p_uid:String)
		{
			super(p_uid);
		}
		
		public function set clients(value:Array):void
		{
			_clients = value;
		}
		public function get clients():Array
		{
			return _clients;
		}
		
		public function set suppliers(value:Array):void
		{
			_suppliers = value;
		}
		public function get suppliers():Array
		{
			return _suppliers;
		}
		
		public override function get sources():Array
		{
			var elements:Array = [];
			
			if (super.sources != null)
			{
				elements = elements.concat(super.sources);
			}
			
			if (clients != null)
			{
				elements = elements.concat(clients);
			}
			
			return elements;
		}
		
		public override function get targets():Array
		{
			var elements:Array = [];
			
			if (super.targets)
			{
				elements = elements.concat(super.targets);
			}
			
			if (suppliers != null)
			{
				elements = elements.concat(suppliers);
			}
			
			return elements;
		}
		
	}
	
}
