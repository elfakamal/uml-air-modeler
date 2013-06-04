package model
{
	
	/**
	 * 
	 * @author kamal
	 * 
	 */
	internal class UmlModelBehavioredClassifier extends UmlModelClassifier
	{
		
		/**
		 * Subsets Element::ownedElement and Realization::clientDependency
		 */
		protected var _interfaceRalization		:Array		= null;
		
		/**
		 * 
		 * @param p_uid
		 * @param p_name
		 * @param p_visibility
		 * 
		 */
		public function UmlModelBehavioredClassifier(
											p_uid			:String, 
											p_name			:String, 
											p_visibility	:UmlModelVisibilityKind=null)
		{
			super(p_uid, p_name, p_visibility);
		}
		
		public function get interfaceRalization():Array
		{
			return _interfaceRalization;
		}
		public function set interfaceRalization(value:Array):void 
		{
			_interfaceRalization = value;
		}
		
		override public function get ownedElements():Array
		{
			var elements:Array = [];
			
			if (super.ownedElements != null)
			{
				elements = elements.concat(super.ownedElements);
			}
			
			if (interfaceRalization != null)
			{
				elements = elements.concat(interfaceRalization);
			}
			
			return elements;
		}
		
		override public function get clientDependencies():Array
		{
			var elements:Array = [];
			
			if (super.clientDependencies != null)
			{
				elements = elements.concat(super.clientDependencies);
			}
			
			if (interfaceRalization != null)
			{
				elements = elements.concat([interfaceRalization]);
			}
			
			return elements;
		}
		
	}
	
}
