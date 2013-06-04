package model
{
	
	/**
	 * 
	 * A classifier is a namespace whose members can include features. 
	 * Classifier is an abstract metaclass.
	 * 
	 * A classifier is a type and can own generalizations, thereby making 
	 * it possible to define generalization relationships to other classifiers. 
	 * 
	 * A classifier can specify a generalization hierarchy by referencing 
	 * its general classifiers.
	 * 
	 * A classifier is a redefinable element, meaning that it is possible 
	 * to redefine nested classifiers.
	 * 
	 * @author kamal
	 * 
	 */
	public interface	IUmlModelClassifier 
		extends			IUmlModelNamespace, 
						IUmlModelRedefinableElement
	{
		
		/**
		 * <p>
		 * If true, the Classifier does not provide a complete declaration 
		 * and can typically not be instantiated. <br/>
		 * An abstract classifier is intended to be used by other classifiers
		 * <br/> 
		 * (e.g., as the target of general metarelationships or generalization 
		 * relationships).
		 * </p>
		 * 
		 * Default value is false.
		 */
		function set isAbstract(value:Boolean):void;
		function get isAbstract():Boolean;
		
		/**
		 * Refers to all of the Properties that are direct (i.e., not inherited 
		 * or imported) attributes of the classifier. 
		 * Subsets Classifier::feature and is a derived union
		 * 
		 * must to be redefined in subclasses to return only the classifier's 
		 * direct attributes.
		 */
		function get attributes():Array;
		
		/**
		 * Specifies each feature defined in the classifier. 
		 * Subsets Namespace::member. This is a derived union.
		 * 
		 * must be redefined in subclasses to return the subsetting collection 
		 * property.
		 */
		function get features():Array;
		
		/**
		 * Specifies the general Classifiers for this Classifier. 
		 * This is derived.
		 */
		function get generals():Array;
		
		/**
		 * Specifies the Generalization relationships for this Classifier. 
		 * These Generalizations navigate to more general classifiers 
		 * in the generalization hierarchy. 
		 * Subsets Element::ownedElement
		 */
		function get generalizations():Array;
		
		/**
		 * Specifies all elements inherited by this classifier from the general 
		 * classifiers. 
		 * Subsets Namespace::member. This is derived.
		 */
		function get inheritedMembers():Array;
		
		/**
		 * References the Classifiers that are redefined by this Classifier. 
		 * Subsets RedefinableElement::redefinedElement
		 */
		function get redefinedClassifiers():Array;
		
		/**
		 * References the substitutions that are owned by this Classifier. 
		 * Subsets Element::ownedElement and NamedElement::clientDependency.
		 */
		function get substitutions():Array;
		
		/**
		 * Designates the GeneralizationSet of which the associated Classifier 
		 * is a power type.
		 */
		function get powerTypeExtent():UmlModelGeneralizationSet;
		
		/**
		 * gives all of the features in the namespace of the classifier. 
		 * In general, through mechanisms such as inheritance, this will 
		 * be a larger set than feature.
		 */
		function getAllFeatures():Array;
		
		/**
		 * gives all of the immediate ancestors of a generalized Classifier
		 */
		function getParents():Array;
		
		/**
		 * gives all of the direct and indirect ancestors of a generalized 
		 * Classifier.
		 */
		function getAllParents():Array;
		
		/**
		 * gives all of the members of a classifier that may be inherited 
		 * in one of its descendants, subject to whatever visibility 
		 * restrictions apply.
		 */
		function getInheritableMembersOf(classifier:IUmlModelClassifier):Array;
		
		/**
		 * determines whether a named element is visible in the classifier. 
		 * By default all are visible. It is only called when the argument 
		 * is something owned by a parent.
		 */
		function hasVisibilityOf(element:IUmlModelNamedElement):Boolean;
		
		/**
		 * gives true for a classifier that defines a type that conforms 
		 * to another. This is used, for example, in the specification 
		 * of signature conformance for operations.
		 */
		//function conformsTo(classifier:IUmlModelClassifier):Boolean;
		
		/**
		 * defines how to inherit a set of elements. Here the operation 
		 * is defined to inherit them all. It is intended to be redefined 
		 * in circumstances where inheritance is affected by redefinition.
		 */
		function inherit(elements:Array):Array;
		
		/**
		 * determines whether this classifier may have a generalization 
		 * relationship to classifiers of the specified type. By default 
		 * a classifier may specialize classifiers of the same or a more 
		 * general type. It is intended to be redefined by classifiers 
		 * that have different specialization constraints.
		 */
		function maySpecializeType(classifier:IUmlModelClassifier):Boolean;
		
	}
	
}
