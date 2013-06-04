package model
{
	/**
	 * 
	 * @author kamal
	 * 
	 */
	public interface IUmlModelAssociation extends IUmlModelClassifier
	{
		
		function get isDerived():Boolean;
		
		function get memberEnds():Array; // [2..*] Property
		
		function get ownedEnds():Array; // [*] Property
		
		function get navigableOwnedEnds():Array; // [*] Property
		
		function get endTypes():Array; // [1..*] UmlModelType
		
	}
	
}
