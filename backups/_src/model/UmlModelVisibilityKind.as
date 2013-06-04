package model
{
	
	import flash.errors.IllegalOperationError;
	import flash.html.script.Package;
	
	/**
	 * decorated actionScript class that behave like an enumeration.
	 * 
	 * @author kamal
	 * 
	 */
	public final class UmlModelVisibilityKind
	{
		
		/**
		 * 
		 */
		private static const PUBLIC				:String			= "public";
		private static const PRIVATE			:String			= "private";
		private static const PROTECTED			:String			= "protected";
		private static const PACKAGE			:String			= "package";
		
		private static var _creationAllowed 	:Boolean		= false;
		
		private static var _publicInstance		:UmlModelVisibilityKind = null;
		private static var _privateInstance		:UmlModelVisibilityKind = null;
		private static var _protectedInstance	:UmlModelVisibilityKind = null;
		private static var _packageInstance		:UmlModelVisibilityKind = null;
		
		/**
		 * bussines members
		 */
		private var _visibilityName			:String					= "";
		
		/**
		 * 
		 * 
		 */
		public function UmlModelVisibilityKind()
		{
			if (!_creationAllowed)
			{
				throw new IllegalOperationError("this class is abstract");
			}
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		private static function getNewInstance():UmlModelVisibilityKind
		{
			_creationAllowed = true;
			var _instance:UmlModelVisibilityKind = new UmlModelVisibilityKind();
			_creationAllowed = false;
			return _instance;
		}
		
		/**
		 * 
		 * @param name
		 * 
		 */
		private function set visibilityName(name:String):void
		{
			_visibilityName = name;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public static function get $public():UmlModelVisibilityKind
		{
			if (_publicInstance != null)
			{
				return _publicInstance;
			}
			
			_publicInstance	= getNewInstance();
			_publicInstance.visibilityName = PUBLIC;
			return _publicInstance;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public static function get $private():UmlModelVisibilityKind
		{
			if (_privateInstance!= null)
			{
				return _privateInstance;
			}
			
			_privateInstance = getNewInstance();
			_privateInstance.visibilityName = PRIVATE;
			return _privateInstance;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public static function get $protected():UmlModelVisibilityKind
		{
			if (_protectedInstance!= null)
			{
				return _protectedInstance;
			}
			
			_protectedInstance = getNewInstance();
			_protectedInstance.visibilityName = PROTECTED;
			return _protectedInstance;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public static function get $package():UmlModelVisibilityKind
		{
			if (_packageInstance!= null)
			{
				return _packageInstance;
			}
			
			_packageInstance = getNewInstance();
			_packageInstance.visibilityName = PACKAGE;
			return _packageInstance;
		}
		
		public static function bestVisibility(visibilities:Array):UmlModelVisibilityKind
		{
			if (visibilities.indexOf($package) >= 0)
			{
				return null;
			}
			
			if (visibilities.indexOf($protected) >= 0)
			{
				return null;
			}
			
			if (visibilities.indexOf($public) >= 0)
			{
				return $public;
			}
			else if (visibilities.indexOf($private) >= 0)
			{
				return $private;
			}
			
			return null;
		}
		
		/**
		 * this function gives the appropriate visibility kind for the string 
		 * passed in parameters
		 */
		public static function getVisibilityByName(visibilityName:String):UmlModelVisibilityKind
		{
			switch (true)
			{
				case (visibilityName == PUBLIC) : 
					return UmlModelVisibilityKind.$public;
					break;
				
				case (visibilityName == PRIVATE) : 
					return UmlModelVisibilityKind.$private;
					break;
				
				case (visibilityName == PROTECTED) : 
					return UmlModelVisibilityKind.$protected;
					break;
				
				case (visibilityName == PACKAGE) : 
					return UmlModelVisibilityKind.$package;
					break;
				
				default : 
					// rien
					throw new IllegalOperationError ("invalid visibility");
			}
		}
		
		public function toString():String 
		{
			return _visibilityName;
		}
		
	}
	
}
