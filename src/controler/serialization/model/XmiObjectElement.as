package controler.serialization.model
{
	
	internal final class XmiObjectElement extends XmiElement
	{
		
		/**
		 * 
		 */
		private var _containedItems			:Array		= null;
		
		
		public function XmiObjectElement()
		{
			super();
		}
		
		
		public function get containedItems():Array
		{
			return _containedItems;
		}
		public function set containedItems(value:Array):void
		{
			_containedItems = value;
		}

	}
	
}
