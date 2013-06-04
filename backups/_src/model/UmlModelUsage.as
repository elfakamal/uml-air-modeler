package model
{
	
	/**
	 * A usage is a relationship in which one element requires another element 
	 * (or set of elements) for its full implementation or operation. 
	 * In the metamodel, a Usage is a Dependency in which the client 
	 * requires the presence of the supplier.
	 *  
	 * @author kamal
	 * 
	 */
	internal class UmlModelUsage extends UmlModelDependency
	{
		
		/**
		 * à voir plus tard
		 * 
		 * @param p_uid
		 * 
		 */
		public function UmlModelUsage(p_uid:String)
		{
			super(p_uid);
		}
		
	}
	
}
