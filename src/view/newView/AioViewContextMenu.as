package view.newView
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Strong;
	
	import controler.UmlViewControler;
	
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	
	import mx.collections.ArrayCollection;
	import mx.containers.Canvas;
	import mx.containers.VBox;
	import mx.core.ScrollPolicy;
	import mx.core.UIComponent;
	
	
	/**
	 * 
	 * @author neiio
	 * 
	 */
	public class AioViewContextMenu extends UIComponent
	{
		
		private static var s_paddingTop			:Number			= 5;
		private static var s_paddingBottom		:Number			= 5;
		
		private static var s_margin				:Number			= 1;
		private static var s_cornerRadius		:Number			= 3;
		
		private static var s_separatorHeight	:Number			= 1;
		
		private static var s_dropShadow		:DropShadowFilter		= null;
		
		private var m_gap					:Number					= 0;
		
		private var m_itemsVBox				:VBox					= null;
		
		private var m_itemsList				:ArrayCollection		= null;
		private var m_separators			:ArrayCollection		= null;
		
		private var m_isDisposeRequested	:Boolean				= false;
		private var m_isShowing				:Boolean				= false;
		private var m_isDisposing			:Boolean				= false;
		
		private var _isShowRequested:Boolean = false;
		
		
		public function AioViewContextMenu()
		{
			super();
			
			m_itemsVBox		= new VBox();
			m_itemsList		= new ArrayCollection();
			m_separators	= new ArrayCollection();
			
			m_itemsVBox.horizontalScrollPolicy	= ScrollPolicy.OFF;
			m_itemsVBox.verticalScrollPolicy	= ScrollPolicy.OFF;
			
			m_itemsVBox.setStyle("verticalGap", m_gap);
			m_itemsVBox.setStyle("backgroundColor", 0x3C3C3C);
			
			m_itemsVBox.setStyle("paddingTop", s_paddingTop);
			m_itemsVBox.setStyle("paddingBottom", s_paddingBottom);
			m_itemsVBox.setStyle("cornerRadius", s_cornerRadius); // marche pas :s
			
			if (s_dropShadow == null)
			{
				s_dropShadow = new DropShadowFilter(2, 45, 0x000000, 1, 4, 4, 1, 5);
			}
			
			filters		= [s_dropShadow];
			alpha		= 0.0;
		}
		
		protected override function createChildren():void
		{
			super.createChildren();
			addChild(m_itemsVBox);
		}
		
		private function initListeners():void
		{
			
		}
		
		public function addItem(item:AioViewContextMenuItem):AioViewContextMenuItem
		{
			if (item == null)
			{
				return null;
			}
			
			m_itemsList.addItem(item);
			item.addEventListener(MouseEvent.CLICK, onItemClick);
			
			m_itemsVBox.addChild(item);
			
			return item;
		}
		
		public function addSeparator():DisplayObject
		{
			var separator:Canvas		= new Canvas();
			separator.percentWidth		= 100;
			separator.height			= s_separatorHeight;
			
			separator.setStyle("backgroundColor", 0xFFFFFF);
			separator.setStyle("backgroundAlpha", 0.1);
			
			m_separators.addItem(separator);
			
			return m_itemsVBox.addChild(separator);
		}
		
		private function onItemClick(e:MouseEvent):void
		{
			//dispose();
			
			UmlViewControler.getInstance().getContextMenuManager().disposeCurrentContextMenu();
		}
		
		protected override function measure():void
		{
			super.measure();
			
			measuredWidth	= measuredMinWidth	=	getMaxItemWidth() + s_margin * 2;
			measuredHeight	= measuredMinHeight	=	m_itemsList.length * 
													(AioViewContextMenuItem.ITEM_HEIGHT + m_gap) - 
													m_gap + s_margin + 
													s_paddingTop + s_paddingBottom + 
													m_separators.length * s_separatorHeight;
		}
		
		protected function getMaxItemWidth():Number
		{
			var max		:Number = 0;
			var item	:AioViewContextMenuItem = null;
			
			for (var i:uint = 0; i < m_itemsList.length; i++)
			{
				item = m_itemsList.getItemAt(i) as AioViewContextMenuItem;
				
				if (item.getExplicitOrMeasuredWidth() > max)
				{
					max = item.getExplicitOrMeasuredWidth();
				}
			}
			
			return max;
		}
		
		protected override function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			m_itemsVBox.x			= s_margin;
			m_itemsVBox.y			= s_margin;
			m_itemsVBox.width		= unscaledWidth - s_margin;
			m_itemsVBox.height		= unscaledHeight - s_margin;
		}
		
		public function show():void
		{
			enabled		= true;
			m_isShowing	= true;
			
			var myTweens:Array = TweenMax.getTweensOf(this);
			var tween:TweenMax = null;
			for (var i:int = 0; i < myTweens.length; i++)
			{
				tween = myTweens[i];
				//tween.clear();
				tween.killVars(this);
			}
			
			TweenMax.to
			(
				this, 
				0.5, 
				{
					alpha		: 0.8, 
					ease		: Strong.easeOut, 
					onComplete	: onShowComplete
				}
			);
		}
		
		private function onShowComplete():void
		{
			m_isShowing = false;
		}
		
		public function dispose(onDisposeCallback:Function=null):void
		{
			enabled					= false;
			m_isDisposeRequested	= true;
			m_isDisposing			= true;
			
			TweenMax.to
			(
				this, 
				0.3, 
				{
					alpha		: 0.0, 
					ease		: Strong.easeOut, 
					onComplete	: function ():void
					{
						m_isDisposing			= false;
						m_isDisposeRequested	= false;
						
						removeAllItems();
						
						if (onDisposeCallback != null && !m_isShowing)
						{
							onDisposeCallback();
						}
					}
				}
			);
		}
		
		public function getItems():ArrayCollection
		{
			return m_itemsList;
		}
		
		public function removeAllItems():void
		{
			m_itemsList.removeAll();
			m_separators.removeAll();
			m_itemsVBox.removeAllChildren();
		}
		
	}
	
}
