package model
{
	
	/**
	 * 
	 * @author kamal
	 * 
	 */
	internal class	UmlModelNamedElement 
		extends		UmlModelElement 
		implements	IUmlModelNamedElement 
	{
		
		/**
		 * business members
		 */
		protected var _name					:String						= "";
		protected var _visibility			:UmlModelVisibilityKind		= null;
		
		/**
		 * 
		 * @param id
		 * @param name
		 * @param visibility
		 * 
		 */
		public function UmlModelNamedElement(
								p_uid				:String, 
								p_name				:String, 
								p_visibility		:UmlModelVisibilityKind = null)
		{
			super(p_uid);
			
			_name = p_name;
			
			if (p_visibility == null)
			{
				_visibility = UmlModelVisibilityKind.$public;
			}
			else
			{
				_visibility = p_visibility;
			}
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function get qualifiedName():String
		{
			return "..." + name;
		}
		
		public function get name():String
		{
			return _name;
		}
		public function set name(value:String):void
		{
			_name = value;
		}
		
		public function get visibility():UmlModelVisibilityKind
		{
			return _visibility;
		}
		public function set visibility(value:UmlModelVisibilityKind):void
		{
			_visibility = value;
		}
		
		/**
		 * derived union
		 */
		public function get $namespace():IUmlModelNamespace
		{
			return null;
		}
		
		override public function get owner():IUmlModelElement
		{
			if ($namespace != null)
			{
				return $namespace;
			}
			return super.owner;
		}
		
		public function get clientDependencies():Array
		{
			return null;
		}
		
		public function get separator():String
		{
			return "::";
		}
		
		public function getAllNamespaces():Array // or LinkedList ;-)
		{
			return null;
		}
		
		public function isDistinguishableFrom(
									element			:IUmlModelNamedElement, 
									ns				:IUmlModelNamespace):Boolean
		{
			return false;
		}
		
	}
	
}
