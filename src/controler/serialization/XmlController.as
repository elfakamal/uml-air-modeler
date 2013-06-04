package controler.serialization
{
	import flash.errors.IllegalOperationError;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	import model.UmlModelProject;
	
	public class XmlController
	{
		
		private static var _instance			:XmlController		= null;
		private static var _isCreationAllowed	:Boolean			= false;
		
		
		private static var _projectFile			:File				= null;
		private static var _diagramFile			:File				= null;
		
		
		public function XmlController()
		{
			if (!_isCreationAllowed)
			{
				throw new IllegalOperationError("this class is singleton");
			}
		}
		
		public static function getInstance():XmlController
		{
			if (_instance != null)
			{
				return _instance;
			}
			else
			{
				_isCreationAllowed	= true;
				_instance			= new XmlController();
				_isCreationAllowed	= false;
				
				return _instance;
			}
		}
		
		public function saveProject(modelProject:UmlModelProject):void
		{
			if (_projectFile == null)
			{
				_projectFile = new File("C:/Users/kamal/Travaux/Flex/_umlAlakon/UmlAirProject.txt");
			}
			
			//this object will get saved to the file
			var projectXml:Object = modelProject.xml;
			
			var fileStream:FileStream = new FileStream();
			fileStream.open(_projectFile, FileMode.WRITE);
			fileStream.writeObject(projectXml.toString());
			fileStream.close();
		}
		
		public function saveDiagram():void
		{
			
		}
		
	}
	
}
