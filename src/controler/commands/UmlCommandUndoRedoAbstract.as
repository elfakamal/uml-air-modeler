package controler.commands
{
	import controler.namespaces.commander;
	
	import flash.net.getClassByAlias;
	
	public class UmlCommandUndoRedoAbstract implements ICommand
	{
		
		protected static var _undoHistory	:Vector.<ICommand>	= null;
		protected static var _redoHistory	:Vector.<ICommand>	= null;
		
		
		
		public function UmlCommandUndoRedoAbstract()
		{
			if (_undoHistory == null)
			{
				_undoHistory = new Vector.<ICommand>();
			}
			
			if (_redoHistory == null)
			{
				_redoHistory = new Vector.<ICommand>();
			}
		}
		
		public function execute():void
		{
			_undoHistory.push(this);
			clearRedoHistory();
		}
		
		protected function clearRedoHistory():void
		{
			if (_redoHistory != null)
			{
				while (_redoHistory.length > 0)
				{
					_redoHistory.splice(0, 1);
				}
			}
		}
		
		protected function clearUndoHistory():void
		{
			if (_undoHistory != null)
			{
				while (_undoHistory.length > 0)
				{
					_undoHistory.splice(0, 1);
				}
			}
		}
		
		public function undo():void
		{
			//ABSTRACT method, must be overriden in subclasses
		}
		
		public function redo():void
		{
			//ABSTRACT method, must be overriden in subclasses
		}
		
		protected final function canUndo():Boolean
		{
			if (_undoHistory != null)
			{
				return _undoHistory.length > 0;
			}
			
			return false;
		}
		
		protected final function canRedo():Boolean
		{
			if (_redoHistory != null)
			{
				return _redoHistory.length > 0;
			}
			
			return false;
		}
		
		public static function getUndoHistory():Array
		{
			var history:Array = new Array();
			
			for each (var command:ICommand in _undoHistory)
			{
				history.push(command.toString());
			}
			
			return history;
		}
		
		public static function getRedoHistory():Vector.<ICommand>
		{
			return _redoHistory;
		}
		
		public function toString():String
		{
			return "Command ";
		}
		
	}
	
}
