package view
{
	import controler.UmlControler;
	
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import mx.controls.Button;
	import mx.core.UIComponent;
	import mx.events.FlexEvent;

	public class UmlViewToolItem extends UIComponent
	{
		
		/**
		 * 
		 * 
		 */
		public static const DEFAULT_ITEM_WIDTH				:Number			= 80;
		public static const DEFAULT_ITEM_HEIGHT				:Number			= 80;
		
		/**
		 * 
		 */
		private var _button							:Button			= null;
		
		private var _name							:String			= "";
		
		/**
		 * 
		 */
		private var _isStartDrag					:Boolean		= false;
		
		/**
		 * 
		 */
		private var _initialPoint					:Point			= null;
		
		/**
		 * 
		 */
		private var _imageClass						:Class			= null;
		
		/**
		 * 
		 * 
		 */
		public function UmlViewToolItem(p_name:String)
		{
			super();
			
			_name = p_name;
			
			initListeners();
		}
		
		protected function initListeners():void
		{
			addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		}
		
		/**
		 * 
		 * 
		 */
		protected override function createChildren():void
		{
			super.createChildren();
			
			_button = new Button();
			addChild(_button);
		}
		
		/**
		 * 
		 * 
		 */
		protected function onCreationComplete(e:FlexEvent):void
		{
			_button.width		= DEFAULT_ITEM_WIDTH;
			_button.height		= DEFAULT_ITEM_HEIGHT;
			_button.label		= _name;
		}
		
		/**
		 * 
		 * 
		 */
		protected function onMouseDown(e:MouseEvent):void
		{
			_isStartDrag = true;
			_initialPoint = new Point
			(
				UmlControler.getInstance().getSelectedWorkspace().mouseX,
				UmlControler.getInstance().getSelectedWorkspace().mouseY
			);
			
			addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}
		
		/**
		 * pas besoin
		 */
		protected function onMouseMove(e:MouseEvent):void
		{
			
		}
		
		/**
		 * 
		 * 
		 */
		protected function onMouseUp(e:MouseEvent):void
		{
			_isStartDrag = true;
			removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}
		
		public function clone():UmlViewToolItem
		{
			
			return null;
		}
		
		protected override function measure():void
		{
		      super.measure();
		      
		      measuredHeight	= measuredMinHeight		= DEFAULT_ITEM_HEIGHT;
		      measuredWidth		= measuredMinWidth		= DEFAULT_ITEM_WIDTH;
		}
		
	}
	
}
