package model
{
	import mx.messaging.AbstractConsumer;
	
	/**
	 * 
	 * @author kamal
	 * 
	 */
	internal class	UmlModelGeneralizationSet 
		extends		UmlModelNamedElement 
		implements	IUmlModelPackageableElement
	{
		
		protected var _isCovering			:Boolean				= false;
		protected var _isDisjoint			:Boolean				= false;
		protected var _generalizations		:Array					= null;
		protected var _powerType			:IUmlModelClassifier	= null;
		
		/**
		 * 
		 * @param id
		 * @param name
		 * 
		 */
		public function UmlModelGeneralizationSet(id:String, name:String)
		{
			super(id, name);
		}
		
		public function get packageableElementVisibility():UmlModelVisibilityKind
		{
			return visibility;
		}
		
		public override function get xml():XML
		{
			return null;
		}
		
		public function get isCovering():Boolean
		{
			return _isCovering;
		}
		public function set isCovering(value:Boolean):void 
		{
			_isCovering = value;
		}
		
		public function get isDisjoint():Boolean
		{
			return _isDisjoint;
		}
		public function set isDisjoint(value:Boolean):void 
		{
			_isDisjoint = value;
		}
		
		public function get generalizations():Array
		{
			return _generalizations;
		}
		public function set generalizations(value:Array):void 
		{
			_generalizations = value;
		}
		
		public function get powerType():IUmlModelClassifier
		{
			return _powerType;
		}
		public function set powerType(value:IUmlModelClassifier):void 
		{
			_powerType = value;
		}
		
	}
	
}
