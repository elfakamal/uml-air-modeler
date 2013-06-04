package model
{
	
	/**
	 * 
	 * @author kamal
	 * 
	 */
	internal class UmlModelDirectedRelationship extends UmlModelRelationship
	{
		
		/**
		 * 
		 * @param id
		 * 
		 */
		public function UmlModelDirectedRelationship(p_uid:String)
		{
			super(p_uid);
		}
		
		public override function get relatedElements():Array
		{
			var elements:Array = [];
			
			if (super.relatedElements != null)
			{
				elements = elements.concat(super.relatedElements);
			}
			
			if (sources != null)
			{
				elements = elements.concat(sources);
			}
			
			if (targets != null)
			{
				elements = elements.concat(targets);
			}
			
			return elements;
		}
		
		/**
		 * abstract function
		 */
		public function get sources():Array
		{
			return null;
		}
		
		/**
		 * abstract function 
		 */
		public function get targets():Array
		{
			return null;
		}
		
	}
	
}
