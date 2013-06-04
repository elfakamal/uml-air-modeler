package model
{
	/**
	 * A generalization is a taxonomic relationship between a more general 
	 * classifier and a more specific classifier. Each instance of the specific 
	 * classifier is also an indirect instance of the general classifier. 
	 * Thus, the specific classifier inherits the features of the more general 
	 * classifier
	 * 
	 * @author kamal
	 * 
	 */
	internal class UmlModelGeneralization extends UmlModelDirectedRelationship
	{
		
		/**
		 * Indicates whether the specific classifier can be used wherever 
		 * the general classifier can be used. If true, the execution traces 
		 * of the specific classifier will be a superset of the execution 
		 * traces of the general classifier.
		 */
		protected var _isSubstitutable		:Boolean				= false;
		
		/**
		 * References the general classifier in the Generalization relationship. 
		 * Subsets DirectedRelationship::target
		 */
		protected var _general				:IUmlModelClassifier	= null;
		
		/**
		 * References the specializing classifier in the Generalization relationship. 
		 * Subsets DirectedRelationship::source and Element::owner
		 */
		protected var _specific				:IUmlModelClassifier	= null;
		
		/**
		 * Designates a set in which instances of Generalization are considered members.
		 */
		protected var _generalizationSet	:UmlModelGeneralizationSet = null;
		
		/**
		 * 
		 */
		public function UmlModelGeneralization(p_uid:String)
		{
			super(p_uid);
		}
		
		public function set general(value:IUmlModelClassifier):void
		{
			_general = value;
		}
		public function get general():IUmlModelClassifier
		{
			return _general;
		}
		
		public function set specific(value:IUmlModelClassifier):void
		{
			_specific = value;
		}
		public function get specific():IUmlModelClassifier
		{
			return _specific;
		}
		
		public override function get targets():Array
		{
			//general Subsets DirectedRelationship::target
			var elements:Array = [];
			
			if (super.targets)
			{
				elements = elements.concat(super.targets);
			}
			
			if (general != null)
			{
				elements.push(general);
			}
			
			return elements;
		}
		
		public override function get sources():Array
		{
			//specific Subsets DirectedRelationship::source
			var elements:Array = [];
			
			if (super.sources)
			{
				elements = elements.concat(super.sources);
			}
			
			if (specific != null)
			{
				elements.push(specific);
			}
			
			return elements;
		}
		
		public override function get owner():IUmlModelElement
		{
			//specific Subsets Element::owner
			if (specific != null)
			{
				return specific;
			}
			
			return super.owner;
		}
		
	}
	
}
