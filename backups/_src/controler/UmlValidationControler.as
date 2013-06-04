package controler
{
	import controler.errors.UmlError;
	
	import flash.events.EventDispatcher;

	/**
	 * 
	 * @author kamal
	 * 
	 */
	public class UmlValidationControler extends EventDispatcher
	{
		
		/**
		 * 
		 */
		private static var _instance	:UmlValidationControler		= null;
		
		private static var _errors		:Array						= null;
		private static var _warnings	:Array						= null;
		
		
		/**
		 * 
		 * @param lock
		 * 
		 */
		public function UmlValidationControler(lock:Lock)
		{
			super();
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public static function getInstance():UmlValidationControler
		{
			if(_instance)
			{
				return _instance;
			}
			else
			{
				_instance = new UmlValidationControler(new Lock());
				return _instance;
			}
		}
		
		public static function addError(ressourceUID:String, description:String="unknown error"):UmlError
		{
			if (_errors == null)
			{
				_errors = new Array();
			}
			
			var error:UmlError = new UmlError(ressourceUID, description);
			_errors.push(error);
			return error;
		}
		
		public static function addWarning(ressourceUID:String, description:String="unknown warning"):UmlError
		{
			if (_warnings == null)
			{
				_warnings = new Array();
			}
			
			var warning:UmlError = new UmlError(ressourceUID, description, UmlError.WARNING);
			_warnings.push(warning);
			return warning;
		}
		
		public static function get errors():Array
		{
			return _errors;
		}
		
		public static function get warning():Array
		{
			return _warnings;
		}
		
		// i'll fill those functions later
		
		public function isProjectValid():Boolean
		{
			return true;
		}
		
		public function isDiagramValid():Boolean
		{
			return true;
		}
		
		public function isClassValid():Boolean
		{
			//"^((\\p{Lu}))((\\S)*+)$"
			return true;
		}
		
		public function isChildNodeValid():Boolean
		{
			return true;
		}
		
		public function isAttributeValid():Boolean//name:String, visibility:String, type:String):Boolean
		{
			//"^(([\\p{L}&&[^\\p{Lu}]])(\\S)*+)$"
			return true;
		}
		
		public function isAssociationValid():Boolean//name:String, visibility:String, type:String):Boolean
		{
			return true;
		}
		
		public function isOperationValid():Boolean
		{
			return true;
		}
		
		public function isEnumerationValid():Boolean
		{
			return true;
		}
		
		public function isEnumerationLiteralValid():Boolean
		{
			return true;
		}
		
	}
}


class Lock
{
	public function Lock()
	{
		
	}
}
