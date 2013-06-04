package view
{
	
	import flash.events.MouseEvent;
	
	import gs.TweenMax;
	
	import mx.containers.ApplicationControlBar;
	import mx.events.FlexEvent;
	
	public class UmlViewToolBar extends ApplicationControlBar
	{
		
		/**
		 * 
		 */
		public static const TOOL_BAR_HEIGHT		:Number			= 100;
		
		private var _isCollapsed				:Boolean		= false;
		
		private var _timeCollapsing				:Number			= 0.5;
		
		/**
		 * 
		 * 
		 * 
		 */
		public function UmlViewToolBar()
		{
			super();
			
			initListeners();
		}
		
		/**
		 * 
		 * 
		 */
		protected function initListeners():void
		{
			addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			
			addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
		}
		
		/**
		 * 
		 */
		private function onCreationComplete(e:FlexEvent):void
		{
			//filters = [UmlControler.getInstance().getToolBarGlowFilter()];
		}
		
		/**
		 * 
		 */
		protected function onMouseOver(e:MouseEvent):void
		{
			if (e.target == this)
			{
				if (_isCollapsed) open();
			}
			else
			{
				e.stopPropagation();
			}
		}
		
		/**
		 * 
		 */
		protected function onMouseOut(e:MouseEvent):void
		{
			if (e.target == this)
			{
				if (!_isCollapsed) collapse();
			}
			else
			{
				e.stopPropagation();
			}
		}
		
		/**
		 * 
		 * 
		 */
		private function open():void
		{
			TweenMax.to
			(
				this, 
				_timeCollapsing, 
				{
					y				: this.parent.height - this.height, 
					onComplete		: function ():void
					{
						_isCollapsed = false;
					}
				}
			);
		}
		
		/**
		 * 
		 * 
		 */
		public function collapse():void
		{
			TweenMax.to
			(
				this, 
				_timeCollapsing,
				{
					y	: this.y + this.height - 20, 
					onComplete		: function ():void
					{
						_isCollapsed = true;
					}
				}
			);
		}
		
		/**
		 * 
		 * 
		 */
		protected override function createChildren():void
		{
			super.createChildren();
		}
		
		/**
		 * 
		 * 
		 */
		public function addTool(toolItem:UmlViewToolItem):void
		{
			if (!this.contains(toolItem))
			{
				addChild(toolItem);
			}
		}
		
	}
	
}
