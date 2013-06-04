package model
{
	
	/**
	 * A substitution is a relationship between two classifiers which 
	 * signifies that the substitutingClassifier complies with the contract 
	 * specified by the contract classifier. This implies that instances 
	 * of the substitutingClassifier are runtime substitutable where instances 
	 * of the contract classifier are expected.
	 * 
	 * @author kamal
	 * 
	 */
	internal class UmlModelSustitution extends UmlModelRealization
	{
		
		/**
		 * Subsets Dependency::target
		 */
		protected var _contract					:IUmlModelClassifier	= null;
		
		/**
		 * Subsets Dependency::client
		 */
		protected var _substitutingClassifier	:IUmlModelClassifier	= null;
		
		/**
		 * 
		 * @param p_uid
		 * 
		 */
		public function UmlModelSustitution(p_uid:String)
		{
			super(p_uid);
		}
		
		public function set contract(value:IUmlModelClassifier):void
		{
			_contract = value;
		}
		public function get contract():IUmlModelClassifier
		{
			return _contract;
		}
		
		public function set substitutingClassifier(value:IUmlModelClassifier):void
		{
			_substitutingClassifier = value;
		}
		public function get substitutingClassifier():IUmlModelClassifier
		{
			return _substitutingClassifier;
		}
		
		public override function get targets():Array
		{
			// cuz contract subsets targets
			var elements:Array = [];
			
			if (super.targets != null)
			{
				elements = elements.concat(super.targets);
			}
			
			if (contract != null)
			{
				elements.push(contract);
			}
			
			return elements;
		}
		
		public override function get clients():Array
		{
			// cuz substitutingClassifier subsets clients
			var elements:Array = [];
			
			if (super.clients != null)
			{
				elements = elements.concat(super.clients);
			}
			
			if (substitutingClassifier != null)
			{
				elements.push(substitutingClassifier);
			}
			
			return elements;
		}
		
	}
	
}
