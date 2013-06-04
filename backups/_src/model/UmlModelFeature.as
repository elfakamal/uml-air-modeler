package model
{
	
	/**
	 * A feature declares a behavioral or structural characteristic 
	 * of instances of classifiers. 
	 * Feature is an abstract metaclass.
	 * 
	 * @author kamal
	 * 
	 */
	internal class	UmlModelFeature 
		extends		UmlModelNamedElement 
		implements	IUmlModelFeature
	{
		
		protected var _type						:IUmlModelType	= null;
		
		protected var _isStatic					:Boolean		= false;
		
		protected var _redefinedElements		:Array			= null;
		protected var _redefinitionContexts		:Array			= null;
		
		/**
		 * 
		 * @param id
		 * @param name
		 * 
		 */
		public function UmlModelFeature(
								p_uid				:String, 
								p_name				:String, 
								p_visibility		:UmlModelVisibilityKind = null)
		{
			super(p_uid, p_name, p_visibility);
			
			_redefinedElements		= new Array();
			_redefinitionContexts	= new Array();
		}
		
		public function get isStatic():Boolean
		{
			return _isStatic;
		}
		
		/**
		 * this property is a derived union
		 * must be overriden in subclasses
		 */
		public function get featuringClassifiers():Array
		{
			return null;
		}
		
		/**
		 * this is a query, that's why it's a method and not a flex'notation 
		 * property
		 * 
		 * @param value
		 */		
		public function setNavigable(value:Boolean):void
		{
			//override in subclasses
		}
		public function isNavigable():Boolean
		{
			//override in subclasses
			return false;
		}
		
		/***********************************************************************
		 * 
		 * IUmlModelTypedElement functions
		 * 
		 */
		public function set type(value:IUmlModelType):void
		{
			_type = value;
		}
		public function get type():IUmlModelType
		{
			return _type;
		}
		
		/***********************************************************************
		 * 
		 * IUmlModelRedefinableElement functions
		 * 
		 */
		public function get isLeaf():Boolean
		{
			return false;
		}
		
		public function set redefinedElements(value:Array):void 
		{
			_redefinedElements = value;
		}
		public function get redefinedElements():Array
		{
			return _redefinedElements;
		}
		
		public function set redefinitionContexts(value:Array):void 
		{
			_redefinitionContexts = value;
		}
		public function get redefinitionContexts():Array
		{
			return redefinitionContexts;
		}
		
		public function isConsistentWith(redefinee:IUmlModelRedefinableElement):Boolean
		{
			return false;
		}
		
		public function isRedefinitionContextValid(redefined:IUmlModelRedefinableElement):Boolean
		{
			return false;
		}
		
	}
	
}
