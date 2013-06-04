package view.newView
{
	
	import controler.events.UmlEvent;
	import controler.events.UmlViewEvent;
	
	import flash.display.DisplayObject;
	import flash.display.GradientType;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Matrix;
	
	import mx.containers.Canvas;
	import mx.core.Container;
	import mx.core.ScrollPolicy;
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	import mx.events.ResizeEvent;
	
	/**
	 * 
	 * @author kamal
	 * 
	 */
	public class UmlViewWindow extends Container
	{
		
		public static const MARGIN				:Number				= 5;
		
		public static const MIN_WIDTH			:Number				= 200;
		public static const MAX_WIDTH			:Number				= 400;
		
		public static const MIN_HEIGHT			:Number				= 200;
		public static const MAX_HEIGHT			:Number				= 500;
		
		public static const MAX_COIN_WIDTH		:Number				= 20;
		public static const MAX_COIN_HEIGHT		:Number				= 400;
		
		public static const LEFT_WINDOW			:String				= "left_window";
		public static const RIGHT_WINDOW		:String				= "right_window";
		public static const INDEPENDENT_WINDOW	:String				= "independent_window";
		
		public static const NONE				:uint				= 0;
		public static const OPEN				:uint				= 1;
		public static const COLLAPSE			:uint				= 2;
		public static const CLOSE				:uint				= 3;
		
		/**
		 * necessary components
		 * 
		 */
		protected var _uiTitle					:UmlViewHorizontalTitle			= null;
		protected var _coin						:UIComponent					= null;
		protected var _holder					:Canvas							= null;
		protected var _background				:Sprite							= null;
		
		protected var _content					:UIComponent					= null;
//		protected var _contentMask				:UIComponent					= null;
		protected var _isContentDirty			:Boolean						= true;
		
		protected var _isLayoutDirty			:Boolean						= true;
		
		/**
		 * 
		 * 
		 */
		protected var _currentCoinWidth			:Number							= 20;
		
		/**
		 * 
		 * 
		 */
		protected var _type						:String							= "";
		protected var _isTypeDirty				:Boolean						= false;
		
		/**
		 * 
		 * 
		 */
		protected var _isCollapsed				:Boolean						= false;
		protected var _savedHeight				:Number							= 0;
		protected var _titleCommand				:uint							= 0;
		protected var _isTitleCommandDirty		:Boolean						= false;
		
		
		/**
		 * 
		 * 
		 */
		public function UmlViewWindow()
		{
			super();
			
			_type = RIGHT_WINDOW;
			
			initListeners();
		}
		
		/*******************************************************************************************
		 * 
		 * overriden functions 
		 * 
		 ******************************************************************************************/
		
		protected override function createChildren():void
		{
			super.createChildren();
			
			initBackground();
			initHolder();
			initCoin();
			initTitle();
		}
		
		/**
		 * 
		 * 
		 * 
		 */
		public override function addChild(child:DisplayObject):DisplayObject
		{
			return _holder.addChild(child);
		}
		
		/**
		 * 
		 * 
		 */
		protected override function measure():void
		{
			super.measure();
			
			if (_content != null)
			{
				var contentWidth:Number = _content.getExplicitOrMeasuredWidth();
				var contentHeight:Number = _content.getExplicitOrMeasuredHeight();
				
				measuredWidth		= contentWidth + MARGIN * 2;
				measuredMinWidth	= contentWidth + MARGIN * 2;
				
				measuredHeight		= contentHeight + UmlViewTitle.TITLE_HEIGHT + MARGIN * 2;
				measuredMinHeight	= contentHeight + UmlViewTitle.TITLE_HEIGHT + MARGIN * 2;
			}
			else
			{
				measuredWidth	= measuredMinWidth		= MIN_WIDTH;
				measuredHeight	= measuredMinHeight		= MIN_HEIGHT;
			}
		}
		
		/**
		 * 
		 * 
		 * 
		 * TODO: appliquer une TweenMax sur le height de la window.
		 */
		protected override function commitProperties():void
		{
			super.commitProperties();
			
			/*
			 *
			 * window states handling
			 *
			 *
			 */
			if (_isTitleCommandDirty)
			{
				switch (true)
				{
					case (_titleCommand == OPEN):
						this.height			= _savedHeight;
						_isCollapsed		= false;
					break;
					case (_titleCommand == COLLAPSE):
						_savedHeight		= this.height;
						this.height			= UmlViewTitle.TITLE_HEIGHT;
						_isCollapsed		= true;
					break;
					case (_titleCommand == CLOSE):
						if (parent)
						{
							parent.removeChild(this);
							var viewEvent:UmlViewEvent = new UmlViewEvent(UmlViewEvent.WINDOW_CLOSED);
							dispatchEvent(viewEvent); 
						}
					break;
				}
				_isTitleCommandDirty = false;
			}
			
			verticalScrollPolicy		= ScrollPolicy.OFF;
			horizontalScrollPolicy		= ScrollPolicy.OFF;
			
		}
		
		/**
		 * 
		 * 
		 * 
		 */
		protected override function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
//			paintCoin(unscaledHeight);
//			paintHolderBackground();
			paintBackground(unscaledWidth, unscaledHeight);
			
			if (_isLayoutDirty || _isTypeDirty)
			{
				layoutChildren(unscaledWidth, unscaledHeight);
				
				_isLayoutDirty		= false;
				_isTypeDirty		= false;
			}
		}
		
		/*******************************************************************************************
		 * 
		 * regular functions 
		 * 
		 ******************************************************************************************/
		
		protected function initListeners():void
		{
			addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			addEventListener(ResizeEvent.RESIZE, onResize);
		}
		
		/**
		 * 
		 * @param content
		 * 
		 */
		public function setContent(content:UIComponent):void
		{
			if (_content != null)
			{
				_holder.removeChild(_content);
			}
			
			_content = content;
			
			if (_content != null)
			{
				_holder.addChildAt(_content, 0);
				_content.addEventListener(ResizeEvent.RESIZE,				onContentResize);
				_content.addEventListener(UmlEvent.UML_ACTION_CANCELED,		onViewFieldFormDone);
				_content.addEventListener(UmlEvent.VIEW_FIELD_FORM_READY,	onViewFieldFormDone);
			}
			
			_isLayoutDirty = true;
			
			invalidateSize();
			invalidateDisplayList();
		}
		public function getContent():UIComponent
		{
			return _content;
		}
		
		/**
		 * 
		 * 
		 * 
		 * 
		 */
		protected function layoutChildren(p_width:Number, p_height:Number):void
		{
			if (getType() == RIGHT_WINDOW)
			{
				setRightWindowLayout(p_width, p_height);
			}
			else if (getType() == LEFT_WINDOW)
			{
				setLeftWindowLayout(p_width, p_height);
			}
			else if (getType() == INDEPENDENT_WINDOW)
			{
				setIndependentWindowLayout(p_width, p_height);
			}
		}
		
		protected function initBackground():void
		{
			_background = new Sprite();
			//rawChildren.addChild(_background);
		}
		
		/**
		 * 
		 * 
		 * 
		 */
		protected function initHolder():void
		{
			_holder			= new Canvas();
//			_contentMask	= new UIComponent();
			
			super.addChild(_holder);
//			_holder.rawChildren.addChild(_contentMask);
			_holder.horizontalScrollPolicy	= ScrollPolicy.OFF;
			_holder.verticalScrollPolicy	= ScrollPolicy.OFF;
		}
		
		protected function initCoin():void
		{
			_coin = new UIComponent();
			super.addChild(_coin);
		}
		
		protected function initTitle():void
		{
			_uiTitle = new UmlViewHorizontalTitle("Properties");
			
			_uiTitle.setDropShadowDistance(0);
			_uiTitle.setCollapseEventListener(onCollapse);
			_uiTitle.setCloseEventListener(onClose);
			
			_uiTitle.addEventListener(MouseEvent.MOUSE_DOWN, onTitleMouseDown);
			
			super.addChild(_uiTitle);
		}
		
		/**
		 * 
		 * 
		 * 
		 * 
		 * 
		 */
		protected function setRightWindowLayout(p_width:Number, p_height:Number):void
		{
			_coin.move(0, 0);
			_coin.setActualSize(_currentCoinWidth, p_height);
			
			_uiTitle.move(_coin.x + _currentCoinWidth, _coin.y);
			_uiTitle.setActualSize(p_width - _currentCoinWidth, UmlViewTitle.TITLE_HEIGHT);
			
			_holder.x			= _uiTitle.x;
			_holder.y			= UmlViewTitle.TITLE_HEIGHT;
			_holder.width		= p_width - _currentCoinWidth;
			_holder.height		= p_height - UmlViewTitle.TITLE_HEIGHT;
		}
		
		/**
		 * 
		 * 
		 * 
		 */
		protected function setLeftWindowLayout(p_width:Number, p_height:Number):void
		{
			_uiTitle.move(0, 0);
			_uiTitle.setActualSize(p_width - _currentCoinWidth, UmlViewTitle.TITLE_HEIGHT);
			
			_holder.x			= 0;
			_holder.y			= UmlViewTitle.TITLE_HEIGHT;
			_holder.width		= p_width - _currentCoinWidth;
			_holder.height		= p_height - UmlViewTitle.TITLE_HEIGHT;
			
			_coin.move(p_width - _currentCoinWidth, 0);
			_coin.setActualSize(MAX_COIN_WIDTH, p_height);
		}
		
		/**
		 * 
		 * 
		 * 
		 */
		protected function setIndependentWindowLayout(p_width:Number, p_height:Number):void
		{
			_coin.move(0,0);
			_coin.setActualSize(0,0)
			
			_uiTitle.move(0, 0);
			_uiTitle.setActualSize(p_width, UmlViewTitle.TITLE_HEIGHT);
			
			_holder.x			= MARGIN;
			_holder.y			= UmlViewTitle.TITLE_HEIGHT + MARGIN;
			_holder.width		= p_width;
			_holder.height		= p_height - UmlViewTitle.TITLE_HEIGHT;
		}
		
		
		/**
		 * 
		 * 
		 * 
		 */
		protected function paintCoin__(p_height:Number):void
		{
			var innerMask:Sprite = new Sprite();
			
			with (innerMask.graphics)
			{
				clear();
				beginFill(0, 0);
				drawRoundRect(0, 0, _coin.width, p_height, 4, 4);
				endFill();
			}
			
			var _topLineMatrix:Matrix = new Matrix();
			with (_coin.graphics)
			{
				_topLineMatrix.createGradientBox(_coin.width, p_height, 0, 0, 0);
				
				clear();
				beginGradientFill
				(
					GradientType.LINEAR, 
					[0x444444, 0x333333], 
					[1, 1], 
					[0, 255], 
					_topLineMatrix
				);
				drawRect(0, 0, _coin.width, p_height);
			}
			
			if (!rawChildren.contains(innerMask))
			{
				rawChildren.addChild(innerMask);
			}
			
			_coin.cacheAsBitmap = true;
			_coin.mask = innerMask;
		}
		
		protected function paintBackground(p_width:Number, p_height:Number):void
		{
			with (graphics)
			{
				clear();
				beginFill(0x222222, 1);
				drawRect(0, 0, p_width, p_height);
				endFill();
			}
		}
		
		/**
		 * 
		 * 
		 * 
		 */
		protected function paintHolderBackground():void
		{
			with (_holder.graphics)
			{
				clear();
				beginFill(0x333333, 1);
				drawRect(0, 0, width - _coin.width, height - UmlViewTitle.TITLE_HEIGHT);
				endFill();
				lineStyle(.25, 0x222222, 1);
				drawRoundRect(0, 0, width - _coin.width, height - UmlViewTitle.TITLE_HEIGHT, 2, 2);
			}
		}
		
		/**
		 * 
		 * 
		 * 
		 */
		public function setType(type:String):void
		{
			if (
					type == LEFT_WINDOW || 
					type == RIGHT_WINDOW || 
					type == INDEPENDENT_WINDOW
				)
			{
				_type			= type;
				_isTypeDirty	= true;
				_isLayoutDirty	= true;
				
				invalidateDisplayList();
			}
		}
		
		public function getType():String
		{
			return _type;
		}
		
		/*******************************************************************************************
		 * 
		 * callback functions 
		 * 
		 ******************************************************************************************/
		
		/**
		 * 
		 * 
		 * 
		 */
		protected function onContentUpdateComplete(e:FlexEvent):void
		{
//			trace("update complete");
//			trace(height);
		}
		
		protected function onContentResize(e:ResizeEvent):void
		{
			invalidateSize();
		}
		
		protected function onViewFieldFormDone(e:UmlEvent):void
		{
			_titleCommand			= CLOSE;
			_isTitleCommandDirty	= true;
			invalidateProperties();
		}
		
		protected function onTitleMouseDown(e:MouseEvent):void
		{
			if (
				e.target != _uiTitle.getCollapseButton() && 
				e.target != _uiTitle.getCloseButton())
			{
				_uiTitle.addEventListener(MouseEvent.MOUSE_MOVE,	onTitleMouseMove);
				_uiTitle.addEventListener(MouseEvent.MOUSE_UP,		onTitleMouseUp);
				
				startDrag();
			}
		}
		
		protected function onTitleMouseMove(e:MouseEvent):void
		{
			e.updateAfterEvent();
		}
		
		protected function onTitleMouseUp(e:MouseEvent):void
		{
			_uiTitle.removeEventListener(MouseEvent.MOUSE_MOVE,		onTitleMouseMove);
			_uiTitle.removeEventListener(MouseEvent.MOUSE_UP,		onTitleMouseUp);
			
			stopDrag();
			
			invalidateProperties();
			invalidateSize();
			invalidateDisplayList();
		}
		
		/**
		 * 
		 * 
		 * window state handlers 
		 * 
		 * 
		 */
		protected function onCollapse(e:MouseEvent):void
		{
			if (!_isCollapsed)
			{
				_titleCommand		= COLLAPSE;
			}
			else
			{
				_titleCommand		= OPEN;
			}
			
			_isTitleCommandDirty	= true;
			
			//
			// we must set it as dirty, because of the collapse's consequeces over 
			// the visibility of thecontent. so then we can repaint the holder, 
			// in order to set the content visible. and about performance, 
			// it's not expansive cuz we will just set the new holder's bounds, 
			// and paint its background and not its children.
			// 
			_isLayoutDirty			= true;
			
			invalidateDisplayList();
			invalidateProperties();
			invalidateSize();
		}
		
		/**
		 * 
		 * 
		 * 
		 */
		protected function onClose(e:MouseEvent):void
		{
			_titleCommand			= CLOSE;
			_isTitleCommandDirty	= true;
			invalidateProperties();
		}
		
		protected function onResize(e:ResizeEvent):void
		{
			_isLayoutDirty		= true;
			_isTypeDirty		= true;
			
//			invalidateProperties();
//			invalidateSize();
//			invalidateDisplayList();
		}
		
		protected function onCreationComplete(e:FlexEvent):void
		{
			filters = [new GlowFilter(0x000000, 1, 3, 3, 1, 10)];
			
			if (parent != null)
			{
				this.x = parent.width / 2 - this.width / 2;
				this.y = parent.height / 2 - this.height / 2;
			}
		}
		
	}
	
}
