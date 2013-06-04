package controler.commands
{
	import controler.namespaces.commander;
	
	import flash.errors.IllegalOperationError;

	public class UmlCommandRedoLast extends UmlCommandUndoRedoAbstract
	{
		
		public function UmlCommandRedoLast()
		{
			super();
		}
		
		public override function execute():void
		{
			var lastCommand:UmlCommandUndoRedoAbstract = null;
			
			if (_redoHistory.length > 0)
			{
				lastCommand = _redoHistory.pop();
				use namespace commander;
				lastCommand.redo();
				
				_undoHistory.push(lastCommand);
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
