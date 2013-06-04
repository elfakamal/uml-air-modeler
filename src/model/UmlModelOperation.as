package model
{
	import controler.events.UmlEvent;
	
	/**
	 * An operation is a behavioral feature of a classifier that specifies 
	 * the name, type, parameters, and constraints for invoking an associated 
	 * behavior.
	 * 
	 * @author kamal
	 * 
	 */
	internal class UmlModelOperation extends UmlModelBehavioralFeature 
	{
		
		/**
		 * The class that owns this operation. 
		 * Subsets RedefinableElement::redefinitionContext, 
		 * NamedElement::namespace and Feature::featuringClassifier
		 */
		protected var _class				:UmlModelClass			= null;
		
		/**
		 * The Interface that owns this Operation. 
		 * (Subsets RedefinableElement::redefinitionContext, 
		 * NamedElement::namespace and Feature::featuringClassifier)
		 */
		protected var _interface			:UmlModelInterface		= null;
		
		/**
		 * Specifies whether an execution of the BehavioralFeature leaves 
		 * the state of the system unchanged (isQuery=true) or whether side 
		 * effects may occur (isQuery=false). 
		 * The default value is false
		 */
		protected var _isQuery				:Boolean				= false;
		
		/**
		 * An optional Constraint on the result values of an invocation of this 
		 * Operation. 
		 * Subsets Namespace::ownedRule
		 */
		protected var _bodyCondition		:UmlModelConstraint		= null;
		
		
		/**
		 * An optional set of Constraints specifying the state of the system 
		 * when the Operation is completed. 
		 * Subsets Namespace::ownedRule.
		 */
		protected var _postConditions		:Array					= null;
		
		/**
		 * An optional set of Constraints on the state of the system when 
		 * the Operation is invoked. 
		 * Subsets Namespace::ownedRule
		 */
		protected var _preConditions		:Array					= null;
		
		/**
		 * References the Operations that are redefined by this Operation. 
		 * Subsets RedefinableElement::redefinedElement
		 */
		protected var _redefinedOperations	:Array					= null;
		
		/**
		 * 
		 */
		public function UmlModelOperation(
								p_uid				:String, 
								p_name				:String, 
								p_visibility		:UmlModelVisibilityKind = null)
		{
			super(p_uid, p_name, p_visibility);
		}
		
		public override function addElement(umlElement:IUmlModelElement) : void
		{
			if (umlElement != null && (umlElement is UmlModelParameter))
			{
				var newParameter:UmlModelParameter = umlElement as UmlModelParameter;
				
				if (hasReturnParameter() && newParameter.direction == UmlModelParameterDirectionKind.$return)
				{
					return;
				}
				
				_ownedParameters.push(newParameter);
			}
		}
		
		public override function edit(newElement:IUmlModelElement) : void
		{
			if (newElement != null && (newElement is UmlModelOperation))
			{
				var newOperation:UmlModelOperation = newElement as UmlModelOperation;
				
				this.name				= newOperation.name;
				this.visibility			= newOperation.visibility;
				this.type				= newOperation.type;
				this.$class				= newOperation.$class;
				this.$interface			= newOperation.$interface;
				this.ownedParameters	= newOperation.ownedParameters;
				
				var event:UmlEvent = new UmlEvent(UmlEvent.ELEMENT_EDITED);
				event.setEditedNode(this);
				dispatchEvent(event);
			}
		}
		
		public function hasReturnParameter(resultParameter:UmlModelParameter=null):Boolean
		{
			if (ownedParameters == null || ownedParameters.length == 0)
			{
				return false;
			}
			
			var i			:int				= 0;
			var found		:Boolean			= false;
			var parameter	:UmlModelParameter	= null;
			
			for (i = 0; i < ownedParameters.length && !found; i++)
			{
				parameter = ownedParameters[i] as UmlModelParameter;
				if (parameter.direction == UmlModelParameterDirectionKind.$return)
				{
					found			= true;
					resultParameter	= parameter;
				}
			}
			
			return found;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public override function get xml():XML
		{
			_xml =	<umlFunction 
						id				= {uid} 
						name			= {name} 
						visibility		= {visibility.toString()} 
						type			= {type.toString()} />;
			
			
			// ajout de l'xml des paramètres 
			if (ownedElements && ownedElements.length > 0)
			{
				var parametersXml:XML = <umlParameters />;
				for (var i:int = 0; i < ownedElements.length; i++)
				{
					//trace(_allNodes[i]);
					var parametre:UmlModelParameter = UmlModelParameter(ownedElements[i]);
					parametersXml.appendChild(parametre.xml);
				}
				_xml.appendChild(parametersXml);
			}
			
			return _xml;
		}
		
		/**
		 * see UML specs to define ocnstraints for this 
		 */
		public function get isOrdered():Boolean
		{
			return false;
		}
		
		/**
		 * see UML specs to define ocnstraints for this 
		 */
		public function get isUnique():Boolean
		{
			return false;
		}
		
		/**
		 * see UML specs to define ocnstraints for this 
		 */
		public function get lower():int
		{
			return 0;
		}
		
		/**
		 * see UML specs to define ocnstraints for this 
		 */
		public function get upper():Number
		{
			return Infinity;
		}
		
		public function get isQuery():Boolean
		{
			return false;
		}
		
		public function set $class(aClass:UmlModelClass):void
		{
			_class = aClass;
		}
		public function get $class():UmlModelClass
		{
			return _class;
		}
		
		//subsetting 
		//from NamedElement
		override public function get $namespace():IUmlModelNamespace
		{
			if ($class != null)
			{
				return $class;
			}
			else if ($interface != null)
			{
				return $interface;
			}
			
			return super.$namespace;
		}
		
		//subsetting
		//from Feature
		override public function get featuringClassifiers():Array
		{
			var elements:Array = new Array();
			
			if (super.featuringClassifiers != null)
			{
				elements = elements.concat(super.featuringClassifiers);
			}
			
			if ($class != null)
			{
				elements.push($class);
			}
			
			if ($interface != null)
			{
				elements.push($interface);
			}
			
			return elements;
		}
		
		/**
		 * {ordered} 
		 * Specifies the parameters owned by this Operation. 
		 * Redefines BehavioralFeature::ownedParameters.
		 */
		public override function get ownedParameters():Array
		{
			return super.ownedParameters;
		}
		
		
		
		//subsetting 
		//from BehavioralFeature 
		override public function get ownedRules():Array
		{
			var elements:Array = new Array();
			
			if (bodyCondition != null)
			{
				elements = elements.concat(bodyCondition);
			}
			
			if (postConditions != null)
			{
				elements = elements.concat(postConditions);
			}
			
			if (preConditions != null)
			{
				elements = elements.concat(preConditions);
			}
			
			return super.ownedRules.concat(elements);
		}
		
		/**
		 * see UML specs to define ocnstraints for this 
		 */
		public function get bodyCondition():UmlModelConstraint
		{
			if (isQuery)
			{
				return _bodyCondition;
			}
			
			return null;
		}
		
		public function get postConditions():Array
		{
			return null;
		}
		
		public function get preConditions():Array
		{
			return null;
		}
		
		/**
		 * 
		 * @return a set of UmlModelType
		 */
		public override function get raisedExceptions():Array
		{
			return super.raisedExceptions;
		}
		
		//subsetting
		//from Feature
		override public function get redefinedElements():Array
		{
			var elements:Array = [];
			
			if (super.redefinedElements != null)
			{
				elements = elements.concat(super.redefinedElements);
			}
			
			if (redefinedOperations != null)
			{
				elements = elements.concat(redefinedOperations);
			}
			
			return elements;
		}
		
		public function get redefinedOperations():Array
		{
			return redefinedElements;
		}
		
		//subsetting 
		//from Feature 
		override public function get redefinitionContexts():Array
		{
			var elements:Array = [];
			
			if (super.redefinitionContexts != null)
			{
				elements = elements.concat(super.redefinitionContexts);
			}
			
			if ($class != null)
			{
				elements.push($class);
			}
			
			if ($interface != null)
			{
				elements.push($interface);
			}
			
			return elements;
		}
		
		/**
		 * see UML specs to define ocnstraints for this 
		 */
//		public function get type():IUmlModelType
//		{
//			return _type;
//			
//			// contraintes des specs Uml à la con :@
////			var returnParameter:UmlModelParameter = null;
////			
////			if (!hasReturnParameter(returnParameter))
////			{
////				return UmlControler.getInstance().getTypeByName("void", false);
////			}
////			
////			return returnParameter.type;
//		}
//		public function set type(value:IUmlModelType):void
//		{
//			_type = value;
//		}
		
		public function set $interface(anInterface:UmlModelInterface):void
		{
			_interface = anInterface;
		}
		public function get $interface():UmlModelInterface
		{
			return _interface;
		}
		
		public override function isConsistentWith(
							redefinableElement:IUmlModelRedefinableElement):Boolean
		{
			return false;
		}
		
		public function returnResult():Array
		{
			var params			:Array				= new Array();
			var returnParameter	:UmlModelParameter	= null;
			
			if (hasReturnParameter(returnParameter))
			{
				params.push(returnParameter);
			}
			
			return params;
		}
		
	}
	
}
