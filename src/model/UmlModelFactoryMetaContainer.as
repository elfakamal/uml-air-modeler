package model
{
	import controler.UmlControler;
	
	
	/**
	 * 
	 * @author kamal
	 * 
	 */
	public class UmlModelFactoryMetaContainer
	{
		
		/**
		 * 
		 * @param name
		 * @return 
		 * 
		 */
		public static function createSimpleNode(name:String):IUmlModelElement
		{
			return null;//new UmlModelElement(UmlControler.getInstance().getNewIdentifier(), name, "");
		}
		
		/**
		 * 
		 * @param name
		 * @param location
		 * @return 
		 * 
		 */
		public static function createProject(name:String, location:String):IUmlModelElement
		{
			return new UmlModelProject(UmlControler.getInstance().getNewUniqueIdentifier(), name, location);
		}
		
		/**
		 * 
		 * @param name
		 * @return 
		 * 
		 */
		public static function createDiagram(name:String):IUmlModelElement
		{
			return new UmlModelClassDiagram(UmlControler.getInstance().getNewUniqueIdentifier(), name);
		}
		
		/**
		 * 
		 * @param name
		 * @return 
		 * 
		 */
		public static function createPackage(name:String):IUmlModelElement
		{
			return new UmlModelPackage(UmlControler.getInstance().getNewUniqueIdentifier(), name);
		}
		
	}
	
}
