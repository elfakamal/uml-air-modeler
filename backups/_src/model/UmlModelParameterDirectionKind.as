package model 
{
	import flash.errors.IllegalOperationError;
	
	/**
	 * Parameter direction kind is an enumeration type that defines literals 
	 * used to specify direction of parameters
	 * 
	 * @author EL FARSAOUI Kamal
	 * 
	 */
	public final class UmlModelParameterDirectionKind
	{
		
		/**
		 * 
		 */
		private static const IN					:String			= "in";
		private static const INOUT				:String			= "inout";
		private static const OUT				:String			= "out";
		private static const RETURN				:String			= "return";
		
		private var _direction					:String			= "";
		
		private static var _creationAllowed 	:Boolean		= false;
		
		private static var _inInstance		:UmlModelParameterDirectionKind = null;
		private static var _inOutInstance	:UmlModelParameterDirectionKind = null;
		private static var _outInstance		:UmlModelParameterDirectionKind = null;
		private static var _returnInstance	:UmlModelParameterDirectionKind = null;
		
		
		public function UmlModelParameterDirectionKind() 
		{
			if (!_creationAllowed)
			{
				throw new IllegalOperationError("this class is abstract");
			}
		}
		
		private static function getNewInstance():UmlModelParameterDirectionKind
		{
			_creationAllowed = true;
			var _instance:UmlModelParameterDirectionKind = 
											new UmlModelParameterDirectionKind();
			_creationAllowed = false;
			return _instance;
		}
		
		static public function get $in():UmlModelParameterDirectionKind
		{
			if (_inInstance != null)
			{
				return _inInstance;
			}
			
			_inInstance = getNewInstance();
			_inInstance._direction = IN;
			return _inInstance;
		}
		
		static public function get $inOut():UmlModelParameterDirectionKind
		{
			if (_inOutInstance != null)
			{
				return _inOutInstance;
			}
			
			_inOutInstance = getNewInstance();
			_inOutInstance._direction = INOUT;
			return _inOutInstance;
		}
		
		static public function get $out():UmlModelParameterDirectionKind
		{
			if (_outInstance != null)
			{
				return _outInstance;
			}
			
			_outInstance = getNewInstance();
			_outInstance._direction = OUT;
			return _outInstance;
		}
		
		static public function get $return():UmlModelParameterDirectionKind
		{
			if (_returnInstance != null)
			{
				return _returnInstance;
			}
			
			_returnInstance = getNewInstance();
			_returnInstance._direction = IN;
			return _returnInstance;
		}
		
	}

}