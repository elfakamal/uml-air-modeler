package model
{
	/**
	 * A multiplicity is a definition of an inclusive interval of non-negative 
	 * integers beginning with a lower bound and ending with a (possibly 
	 * infinite) upper bound. A multiplicity element embeds this information 
	 * to specify the allowable cardinalities for an instantiation of this element.
	 * 
	 * @author kamal
	 * 
	 */
	public interface IUmlModelMultiplicityElement extends IUmlModelElement
	{
		
		/**
		 * For a multivalued multiplicity, this attribute specifies whether 
		 * the values in an instantiation of this element are sequentially 
		 * ordered. Default is false.
		 */
		function set isOredred(value:Boolean):void;
		function get isOredred():Boolean;
		
		/**
		 * For a multivalued multiplicity, this attributes specifies whether 
		 * the values in an instantiation of this element are unique. 
		 * Default is true.
		 */
		function set isUnique(value:Boolean):void;
		function get isUnique():Boolean;
		
		/**
		 * Specifies the lower bound of the multiplicity interval, 
		 * if it is expressed as an integer.
		 */
		function set lowerValue(value:UmlModelValueSpecification):void;
		function get lowerValue():UmlModelValueSpecification;
		
		/**
		 * Specifies the upper bound of the multiplicity interval, 
		 * if it is expressed as an unlimited natural. 
		 */
		function set upperValue(value:UmlModelValueSpecification):void;
		function get upperValue():UmlModelValueSpecification;
		
		/**
		 * cette fonction retourne une chaine de caractères sous forme d'intervalle
		 * ex : [0..1], [0..*], [1], [2..*], ...etc
		 */
		function toMultiplicityString():String;
		
		/**
		 * The specification of the lower bound for this multiplicity. 
		 * Subsets Element::ownedElement
		 */
		function lowerBound():int;
		
		/**
		 * The specification of the upper bound for this multiplicity. 
		 * Subsets Element::ownedElement
		 */
		function upperBound():Number;
		
		/**
		 * checks whether this multiplicity has an upper bound greater than one.
		 */
		function isMultivalued():Boolean;
		
		/**
		 * checks whether the specified cardinality is valid for this multiplicity.
		 */
		function includesCardinality(cardinality:int):Boolean;
		
		/**
		 * hecks whether this multiplicity includes all the cardinalities 
		 * allowed by the specified multiplicity.
		 */
		function includesMultiplicity(multiplicity:IUmlModelMultiplicityElement):Boolean;
		
	}
	
}
