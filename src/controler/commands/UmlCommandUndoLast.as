package controler.commands
{
	import controler.namespaces.commander;
	
	import flash.errors.IllegalOperationError;
	
	public class UmlCommandUndoLast extends UmlCommandUndoRedoAbstract
	{
		
		public function UmlCommandUndoLast()
		{
			super();
		}
		
		public override function execute():void
		{
			var lastCommand:UmlCommandUndoRedoAbstract = null;
			
			if (_undoHistory.length > 0)
			{
				lastCommand = _undoHistory.pop();
				use namespace commander;
				lastCommand.undo();
				
				_redoHistory.push(lastCommand);
			}
		}
		
		public override function undo():void
		{
			throw new IllegalOperationError
			(
				"undo operation is not supported on this command"
			);
		}
		
		public override function redo():void
		{
			throw new IllegalOperationError
			(
				"redo operation is not supported on this command"
			);
		}
		
	}
	
}
