package model
{
	import flash.errors.IllegalOperationError;
	
	
	/**
	 * 
	 * @author kamal
	 * 
	 */
	public final class UmlModelAggregationKind
	{
		
		/**
		 * 
		 */
		private static const NONE				:String		= "none";
		private static const SHARED				:String		= "shared";
		private static const COMPOSITE			:String		= "composite";
		
		private static var _creationAllowed		:Boolean	= false;
		
		private var _aggregationKindName		:String		= "";
		
		/**
		 * 
		 * 
		 */
		public function UmlModelAggregationKind()
		{
			if (!_creationAllowed)
			{
				throw new IllegalOperationError("this class is abstract");
			}
		}
		
		
		/**
		 * 
		 * @return 
		 * 
		 */
		private static function getNewInstance():UmlModelAggregationKind
		{
			_creationAllowed = true;
			var _instance:UmlModelAggregationKind = new UmlModelAggregationKind();
			_creationAllowed = false;
			return _instance;
		}
		
		private function set aggregationKindName(value:String):void
		{
			_aggregationKindName = value;
		}
		
		public static function get none():UmlModelAggregationKind
		{
			var aggregationKind:UmlModelAggregationKind = UmlModelAggregationKind.getNewInstance();
			aggregationKind.aggregationKindName = NONE;
			return aggregationKind;
		}
		
		public static function get shared():UmlModelAggregationKind
		{
			var aggregationKind:UmlModelAggregationKind = UmlModelAggregationKind.getNewInstance();
			aggregationKind.aggregationKindName = SHARED;
			return aggregationKind;
		}
		
		public static function get composite():UmlModelAggregationKind
		{
			var aggregationKind:UmlModelAggregationKind = UmlModelAggregationKind.getNewInstance();
			aggregationKind.aggregationKindName = COMPOSITE;
			return aggregationKind;
		}
		
	}
	
}
