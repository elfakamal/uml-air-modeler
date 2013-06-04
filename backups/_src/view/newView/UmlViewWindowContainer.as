package view.newView
{
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	
	import mx.containers.VDividedBox;
	import mx.core.Container;
	import mx.core.ScrollPolicy;
	import mx.events.FlexEvent;
	
	public class UmlViewWindowContainer extends Container
	{
		
		/**
		 * 
		 * necessary components 
		 */
		protected var _holder			:VDividedBox			= null;
		protected var _uiTitle			:UmlViewTitle			= null;
		
		/**
		 * 
		 * 
		 */
		protected var _numWindows		:uint					= 0;
		protected var _isSizeDirty		:Boolean				= true;
		
		
		/**
		 * 
		 * 
		 * 
		 */
		public function UmlViewWindowContainer()
		{
			super();
			
			initListeners();
		}
		
		
		/******************************
		 * 
		 * overriden functions 
		 * 
		 */
		
		/**
		 * 
		 * 
		 */
		protected override function createChildren():void
		{
			super.createChildren();
			
			_uiTitle		= new UmlViewHorizontalTitle("Diagram Arbo");
			initTitleListeners();
			_uiTitle.setCloseAllowed(false);
			_uiTitle.setCollapseAllowed(false);
			addChild(_uiTitle);
			
			_holder						= new VDividedBox();
			_holder.resizeToContent		= true;
			
			addChild(_holder);
		}
		
		/**
		 * 
		 * @param child
		 * @return 
		 * 
		 */
		public override function addChild(child:DisplayObject):DisplayObject
		{
			if (_holder != null && child is UmlViewWindow)
			{
				_numWindows++;
				child.addEventListener(FlexEvent.UPDATE_COMPLETE, onWindowUpdateComplete);
				return _holder.addChild(child);
			}
			return super.addChild(child);
		}
		
		/**
		 * 
		 */
		private var computedHeight:Number = 0;
		
		/**
		 * 
		 * 
		 */
		protected override function measure():void
		{
			super.measure();
			
			if (_isSizeDirty)
			{
				if (_numWindows > 0)
				{
					measuredHeight		= measuredMinHeight		= UmlViewWindow.MIN_HEIGHT * _numWindows;// + _uiTitle.height;
				}
				else if (_numWindows > 2)
				{
					if (parent) measuredHeight = parent.height;
				}
				else
				{
					measuredHeight		= measuredMinHeight		= UmlViewWindow.MIN_HEIGHT;
				}
				_isSizeDirty = false;
			}
			measuredWidth		= measuredMinWidth		= UmlViewWindow.MIN_WIDTH;
			
			computedHeight = Math.max(computedHeight, measuredHeight);
			
			measuredHeight = measuredMinHeight = computedHeight + _uiTitle.height;
		}
		
		/**
		 * 
		 * 
		 */
		protected override function commitProperties():void
		{
			super.commitProperties();
			
			verticalScrollPolicy				= ScrollPolicy.OFF;
			horizontalScrollPolicy				= ScrollPolicy.OFF;
			
			_holder.verticalScrollPolicy		= ScrollPolicy.OFF;
			_holder.horizontalScrollPolicy		= ScrollPolicy.OFF;
		}
		
		/**
		 * 
		 * @param unscaledWidth
		 * @param unscaledHeight
		 * 
		 */
		protected override function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			//trace ("unscaledHeight " + unscaledHeight);
			
			layoutChildren(unscaledWidth, unscaledHeight);
			paintBackground(unscaledWidth, unscaledHeight);
		}
		
		
		/******************************
		 * 
		 * regular functions 
		 * 
		 */
		
		protected function onWindowUpdateComplete(e:FlexEvent):void
		{
			_isSizeDirty = true;
			
			if (_numWindows > 2)
			{
				if (parent)
				{
					this.x = parent.width - width;
					this.y = 0;
					percentHeight = 100;
				}
				_isSizeDirty = false;
			}
			invalidateSize();
			invalidateDisplayList();
		}
		
		/**
		 * 
		 * @param p_width
		 * @param p_height
		 * 
		 */
		protected function layoutChildren(p_width:Number, p_height:Number):void
		{
			_uiTitle.move(0, 0);
			_uiTitle.setActualSize(p_width, UmlViewTitle.TITLE_HEIGHT);
			
			_holder.x			= 0;
			_holder.y			= _uiTitle.height;
			_holder.width		= p_width;
			_holder.height		= p_height - _uiTitle.height;
			
		}
		
		protected function initListeners():void
		{
			addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
		}
		
		protected function initTitleListeners():void
		{
			_uiTitle.addEventListener(MouseEvent.MOUSE_DOWN,		onTitleMouseDown);
			_uiTitle.addEventListener(MouseEvent.MOUSE_MOVE,		onTitleMouseMove);
			_uiTitle.addEventListener(MouseEvent.MOUSE_UP,			onTitleMouseUp);
		}
		
		protected function onTitleMouseDown(e:MouseEvent):void
		{
			this.startDrag();
		}
		
		protected function onTitleMouseMove(e:MouseEvent):void
		{
			e.updateAfterEvent();
		}
		
		protected function onTitleMouseUp(e:MouseEvent):void
		{
			this.stopDrag();
		}
		
		/**
		 * 
		 * 
		 */
		protected function onCreationComplete(e:FlexEvent):void
		{
			_isSizeDirty = true;
			
			invalidateSize();
			invalidateDisplayList();
		}
		
		/**
		 * 
		 * @param p_width
		 * @param p_height
		 * 
		 */
		protected function paintBackground(p_width:Number, p_height:Number):void
		{
			graphics.beginFill(0xFF5500, 1);
			graphics.drawRect(0, 0, p_width, p_height)
			graphics.endFill();
		}
		
	}
	
}
