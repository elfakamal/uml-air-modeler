package view.newView
{
	
	import controler.UmlViewControler;
	
	import flash.display.DisplayObject;
	import flash.display.GradientType;
	import flash.display.Sprite;
	import flash.filters.DropShadowFilter;
	import flash.geom.Matrix;
	
	import com.greensock.TweenMax;
	
	import mx.containers.Canvas;
	import mx.containers.VBox;
	import mx.core.ScrollPolicy;
	import mx.core.UIComponent;
	import mx.effects.easing.Quintic;
	
	
	public class UmlViewContextMenu extends UIComponent
	{
		
		public static const DEFAULT_SIZE		:Number		= 100;
		public static const RIGHT_MARGIN		:Number		= 20;
		
		protected var _dropShadowFilter	:DropShadowFilter = null
		
		protected var _background		:Sprite		= null;
		protected var _border			:Sprite		= null;
		
		protected var _isBorderAllowed	:Boolean	= false;
		protected var _isLayoutDirty	:Boolean	= true;
		protected var _isSizeDirty		:Boolean	= true;
		
		protected var _numItems			:uint		= 0;
		protected var _itemsHolder		:VBox		= null;
		
		protected var _actualWidth		:Number		= 0;
		protected var _verticalGap		:Number		= 1;
		protected var _padding			:Number		= 5;
		protected var _cornerRadius		:Number		= 2;
		
		protected var _displayTime		:Number		= 0.5;
		protected var _maxItemsWidth	:Number		= 0;
		
		/**
		 * 
		 * 
		 */
		public function UmlViewContextMenu()
		{
			super();
			
			alpha				= 1.0;
			_isBorderAllowed	= true;
			_itemsHolder		= new VBox();
		}
		
		protected override function createChildren():void
		{
			super.createChildren();
			
			_background = new Sprite();
			
			if (_isBorderAllowed)
			{
				_border = new Sprite();
			}
			
			_dropShadowFilter = new DropShadowFilter(2, 45, 0x000000, 1, 2, 2, 1, 5);
			
			_itemsHolder.horizontalScrollPolicy	= ScrollPolicy.OFF;
			_itemsHolder.verticalScrollPolicy	= ScrollPolicy.OFF;
			
			_itemsHolder.setStyle("verticalGap",	_verticalGap);
			_itemsHolder.setStyle("paddingTop",		_padding);
			_itemsHolder.setStyle("paddingBottom",	_padding);
			
			super.addChild(_background);
			super.addChild(_itemsHolder);
			
			if (_isBorderAllowed && _border != null)
			{
				super.addChild(_border);
			}
		}
		
		protected override function childrenCreated():void
		{
			super.childrenCreated();
			
			if (_dropShadowFilter != null)
			{
				filters = [_dropShadowFilter];
			}
		}
		
		public override function addChild(child:DisplayObject):DisplayObject
		{
			return null;
		}
		
		protected override function measure():void
		{
			super.measure();
			
			if (_maxItemsWidth != getMaxItemWidth())
			{
				_maxItemsWidth = getMaxItemWidth();
			}
			
			measuredWidth	= measuredMinWidth	= _maxItemsWidth;
			measuredHeight	= measuredMinHeight	= _numItems * 
						(UmlViewContextMenuItem.DEFAULT_HEIGHT + _verticalGap) - 
						_verticalGap + 2 * _padding;
		}
		
		protected function getMaxItemWidth():Number
		{
			var item	:UIComponent	= null;
			var max		:Number			= 0;
			var i		:int			= 0;
			
			for (i = 0; i < _itemsHolder.numChildren; i++)
			{
				item = _itemsHolder.getChildAt(i) as UIComponent;
				
				if (item != null && item is UmlViewContextMenuItem)
				{
					if (item != null)
					{
						if (item.getExplicitOrMeasuredWidth() > max)
						{
							max = item.getExplicitOrMeasuredWidth();
						}
					}
				}
			}
			
			return max;
		}
		
		protected override function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			layoutChildren(unscaledWidth, unscaledHeight);
			paint(unscaledWidth, unscaledHeight);
		}
		
		protected function layoutChildren(p_width:Number, p_height:Number):void
		{
			_background.x		= 0;
			_background.y		= 0;
			_background.width	= p_width;
			_background.height	= p_height;
			
			if (_isBorderAllowed && _border != null)
			{
				_border.x			= 0;
				_border.y			= 0;
				_border.width		= p_width;
				_border.height		= p_height;
			}
			
			_itemsHolder.x		= 0;
			_itemsHolder.y		= 0;
			_itemsHolder.width	= p_width;
			_itemsHolder.height	= p_height;
		}
		
		protected function paint(p_width:Number, p_height:Number):void
		{
			var matrix:Matrix = new Matrix();
			
			with (_background.graphics)
			{
				clear();
				
				matrix.createGradientBox
				(
					p_width, 
					p_height, 
					UmlViewControler.toRadians(45)
				);
				
				beginGradientFill
				(
					GradientType.LINEAR, 
					[0x222222, 0x000000], 
					[1, 1], [0, 255],
					matrix
				);
				
				//drawRoundRect(0, 0, p_width, p_height, _cornerRadius, _cornerRadius);
				drawRect(0, 0, p_width, p_height);
				endFill();
			}
			
			if (_isBorderAllowed && _border != null)
			{
				with (_border.graphics)
				{
					clear();
					lineStyle(0.1, 0x333333, 1);
					//drawRoundRect(0, 0, p_width, p_height, _cornerRadius, _cornerRadius);
					drawRect(0, 0, p_width, p_height);
				}
			}
		}
		
		/***********************************************************************
		 * 
		 * regular functions 
		 * 
		 **********************************************************************/
		
		/**
		 * 
		 * @param label
		 * @param iconUrl
		 * 
		 */
		public function addItem(
							p_label		:String	= "Unlabeled", 
							p_iconUrl	:String	= "icons/menuItem.png"):UmlViewContextMenuItem
		{
			_numItems++;
			var item:UmlViewContextMenuItem = new UmlViewContextMenuItem(p_label, p_iconUrl);
			_itemsHolder.addChild(item);
			
			return item;
		}
		
		public function addViewItem(item:UmlViewContextMenuItem):Boolean
		{
			var isAdded:Boolean = false;
			
			if (item != null)
			{
				isAdded = (_itemsHolder.addChild(item) != null);
				
				if (isAdded)
				{
					_numItems++;
					_maxItemsWidth = getMaxItemWidth();
				}
			}
			else
			{
				isAdded = false;
			}
			
			return isAdded;
		}
		
		private function addSubMenu(p_label:String, items:Array):void
		{
			_numItems++;
			var item:UmlViewContextMenuItem = new UmlViewContextMenuItem(p_label);
			_itemsHolder.addChild(item);
			
			item.setSubMenu(items);
		}
		
		public function addSeparator():UIComponent
		{
			var separator:UIComponent = createSeparator();
			_itemsHolder.addChild(separator);
			return separator;
		}
		
		private function createSeparator():Canvas
		{
			var separator:Canvas = new Canvas();
			
			separator.setStyle("backgroundColor", 0x111111);
			
			separator.percentWidth	= 100;
			separator.height		= 1;
			
			return separator;
		}
		
		public function removeItem(p_label:String):void
		{
			var item:UmlViewContextMenuItem = null;
			
			for (
					var i:uint = 0;
					
					(i < _numItems) && 
					(item != null) && 
					(item.getContent() != p_label);
					
					i++
				)
			{
				item = _itemsHolder.getChildAt(i) as UmlViewContextMenuItem;
				if (item.getContent() == p_label)
				{
					_itemsHolder.removeChild(item);
					_numItems--;
				}
			}
		}
		
		protected function removeAllItems():void
		{
			_itemsHolder.removeAllChildren();
			
			_numItems		= 0;
			_maxItemsWidth	= 0;
		}
		
		public function show(onCompleteCallback:Function = null):void
		{
			_showContextMenuRequested = true;
			
			TweenMax.to
			(
				this, 
				_displayTime, 
				{
					alpha		: 1.0, 
					ease		: Quintic.easeOut/* , 
					onComplete	: onCompleteCallback */
				}
			);
		}
		
		public function reset():void
		{
			removeAllItems();
		}
		
		private var _showContextMenuRequested		:Boolean = false;
		private var _disposeContextMenuRequested	:Boolean = false;
		
		public function dispose(onCompleteCallback:Function=null):void
		{
			_disposeContextMenuRequested = true;
			
			TweenMax.to
			(
				this, 
				_displayTime, 
				{
					alpha		: 0.0, 
					ease		: Quintic.easeOut, 
					onComplete	: function ():void
					{
						if (parent != null)
						{
							removeAllItems();
							
							if (onCompleteCallback != null && !_showContextMenuRequested)
							{
								onCompleteCallback();
							}
							
							_showContextMenuRequested = false;
						}
					}
				}
			);
		}
		
	}
	
}
