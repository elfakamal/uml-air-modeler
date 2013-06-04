package model
{
	public interface	IUmlModelFeature 
		extends			IUmlModelRedefinableElement, 
						IUmlModelTypedElement
	{
		
		function get isStatic():Boolean;
		
		function get featuringClassifiers():Array;
		
		/**
		 * The query isNavigable() indicates whether it is possible to navigate 
		 * across the property.
		 * 
		 * Property::isNavigable() : Boolean
		 * isNavigable = not classifier->isEmpty() or association.owningAssociation.navigableOwnedEnd->includes(self)
		 * 
		 * @param value
		 */		
		function setNavigable(value:Boolean):void;
		function isNavigable():Boolean;
		
	}
	
}
