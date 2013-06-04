package controler.commands
{
	import controler.namespaces.commander;
	
	/**
	 * 
	 * @author kamal
	 * 
	 */
	public interface ICommand
	{
		
		/**
		 * 
		 * 
		 */
		function execute():void;
		
		function toString():String;
		
	}
	
}
