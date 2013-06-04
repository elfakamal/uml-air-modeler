package model
{
	
	/**
	 * An InterfaceRealization is a specialized Realization relationship 
	 * between a Classifier and an Interface. This relationship signifies 
	 * that the realizing classifier conforms to the contract specified 
	 * by the Interface.
	 * 
	 * @author kamal
	 * 
	 */
	internal class UmlModelInterfaceRealization extends UmlModelRealization
	{
		
		/**
		 * References the Interface specifying the conformance contract. 
		 * (Subsets Dependency::supplier).
		 */
		protected var _contract					:UmlModelInterface				= null;
		
		/**
		 * References the BehavioredClassifier that owns this Interfacerealization 
		 * (i.e., the classifier that realizes the Interface to which it points). 
		 * (Subsets Dependency::client, Element::owner)
		 */
		protected var _implementingClassifier	:UmlModelBehavioredClassifier	= null;
		
		/**
		 * 
		 * @param p_uid
		 * 
		 */
		public function UmlModelInterfaceRealization(p_uid:String)
		{
			super(p_uid);
		}
		
		public function set contract(value:UmlModelInterface):void
		{
			_contract = value;
		}
		public function get contract():UmlModelInterface
		{
			return _contract;
		}
		
		public function set implementingClassifier(value:UmlModelBehavioredClassifier):void
		{
			_implementingClassifier = value;
		}
		public function get implementingClassifier():UmlModelBehavioredClassifier
		{
			return _implementingClassifier;
		}
		
		//subsetting 
		//from Dependency
		public override function get suppliers():Array
		{
			var elements:Array = [];
			
			if (super.suppliers != null)
			{
				elements = elements.concat(super.suppliers);
			}
			
			if (contract != null)
			{
				return elements.push(contract);
			}
			
			return elements;
		}
		
		//subsetting 
		//from Dependency
		public override function get clients():Array
		{
			var elements:Array = [];
			
			if (super.clients)
			{
				elements = elements.concat(super.clients);
			}
			
			if (implementingClassifier != null)
			{
				elements.push(implementingClassifier);
			}
			
			return elements;
		}
		
		//subsetting 
		//from Element
		public override function get owner():IUmlModelElement
		{
			if (implementingClassifier != null)
			{
				return implementingClassifier;
			}
			
			return super.owner;
		}
		
	}
	
}
