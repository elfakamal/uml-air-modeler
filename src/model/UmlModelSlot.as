package model 
{
	
	import model.UmlModelElement;
	
	/**
	 * A slot specifies that an entity modeled by an instance specification 
	 * has a value or values for a specific structural feature.
	 * 
	 * A slot is owned by an instance specification. It specifies the value 
	 * or values for its defining feature, which must be a structural feature 
	 * of a classifier of the instance specification owning the slot.
	 * 
	 * @author EL FARSAOUI Kamal
	 */
	internal class UmlModelSlot extends UmlModelElement
	{
		
		/**
		 * The structural feature that specifies the values that may be held 
		 * by the slot.
		 */
		protected var _definingFeature		:UmlModelStructuralFeature	= null;
		
		/**
		 * The instance specification that owns this slot. 
		 * Subsets Element::owner
		 */
		protected var _owningInstance		:UmlModelInstanceSpecification = null;
		
		/**
		 * The value or values corresponding to the defining feature for 
		 * the owning instance specification. This is an ordered association. 
		 * Subsets Element::ownedElement
		 */
		protected var _values				:Array						= null;
		
		
		public function UmlModelSlot(uid:String) 
		{
			super(uid);
		}
		
		public function get definingFeature():UmlModelStructuralFeature
		{
			return _definingFeature;
		}
		public function set definingFeature(value:UmlModelStructuralFeature):void
		{
			_definingFeature = value;
		}
		
		public function get owningInstance():UmlModelInstanceSpecification
		{
			return _owningInstance;
		}
		public function set owningInstance(value:UmlModelInstanceSpecification):void 
		{
			_owningInstance = value;
		}
		
		public function get values():Array
		{
			return _values;
		}
		public function set values(aValues:Array):void 
		{
			_values = aValues;
		}
		
		override public function get owner():IUmlModelElement
		{
			if (owningInstance != null)
			{
				return owningInstance;
			}
			
			return super.owner;
		}
		
		override public function get ownedElements():Array
		{
			var elements:Array = [];
			
			if (super.ownedElements != null)
			{
				elements = elements.concat(super.ownedElements);
			}
			
			if (values != null)
			{
				elements = elements.concat(values);
			}
			
			return elements;
		}
		
	}
	
}