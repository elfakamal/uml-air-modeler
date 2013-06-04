package model 
{
	import model.UmlModelInstanceValue;
	import model.UmlModelVisibilityKind;
	
	/**
	 * An instance specification is a model element that represents an instance 
	 * in a modeled system.
	 * 
	 * An instance specification specifies existence of an entity in a modeled 
	 * system and completely or partially describes the entity. 
	 * The description may include:
	 * 
	 * • Classification of the entity by one or more classifiers of which the 
	 *	 entity is an instance. If the only classifier specified is abstract, 
	 * 	 then the instance specification only partially describes the entity.
	 * 
	 * • The kind of instance, based on its classifier or classifiers. 
	 * 	 For example, an instance specification whose classifier is a class 
	 * 	 describes an object of that class, while an instance specification 
	 *	 whose classifier is an association describes a link of that association.
	 * 
	 * • Specification of values of structural features of the entity. 
	 * 	 Not all structural features of all classifiers of the instance 
	 * 	 specification need be represented by slots, in which case the instance 
	 * 	 specification is a partial description.
	 * 
	 * • Specification of how to compute, derive, or construct the instance 
	 * 	 (optional).
	 * 
	 * InstanceSpecification is a concrete class. 
	 * 
	 * @author EL FARSAOUI Kamal
	 * 
	 */
	internal class UmlModelInstanceSpecification extends UmlModelInstanceValue
	{
		
		/**
		 * The classifier or classifiers of the represented instance. 
		 * If multiple classifiers are specified, the instance is classified 
		 * by all of them.
		 */
		protected var _classifiers		:Array							= null;
		
		/**
		 * A slot giving the value or values of a structural feature 
		 * of the instance. An instance specification can have one slot 
		 * perstructural feature of its classifiers, including inherited 
		 * features.
		 * It is not necessary to model a slot for each structural feature, 
		 * in which case the instance specification is a partial description. 
		 * Subsets Element::ownedElement
		 */
		protected var _slots			:Array							= null;
		
		/**
		 * A specification of how to compute, derive, or construct the instance. 
		 * Subsets Element::ownedElement
		 */
		protected var _specification	:UmlModelValueSpecification		= null;
		
		
		public function UmlModelInstanceSpecification(
									p_uid			:String, 
									p_name			:String, 
									p_visibility	:UmlModelVisibilityKind = null) 
		{
			super(p_uid, p_name, p_visibility);
		}
		
		//see Uml Specs
		public function get classifiers():Array
		{
			return _classifiers;
		}
		public function set classifiers(value:Array):void 
		{
			_classifiers = value;
		}
		
		//see Uml Specs
		public function get slots():Array
		{
			return _slots;
		}
		public function set slots(value:Array):void 
		{
			_slots = value;
		}
		
		public function get specification():UmlModelValueSpecification
		{
			return _specification;
		}
		public function set specification(value:UmlModelValueSpecification):void 
		{
			_specification = value;
		}
		
		//subsetting
		//from Element
		override public function get ownedElements():Array
		{
			var elements:Array = new Array();
			
			if (super.ownedElements != null)
			{
				elements = elements.concat(super.ownedElements);
			}
			
			if (slots != null)
			{
				elements = elements.concat(slots);
			}
			
			if (specification != null)
			{
				elements.push(specification);
			}
			
			return elements;
		}

	}

}