package view.newView
{
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.containers.HBox;
	import mx.controls.Image;
	import mx.controls.Label;
	import mx.controls.Spacer;
	import mx.core.ScrollPolicy;
	
	/**
	 * 
	 * @author neiio
	 * 
	 */	
	public class AioViewContextMenuItem extends HBox
	{
		
		/**
		 * 
		 */
		public static const ITEM_HEIGHT			:Number			= 18;
		public static const ICON_SIZE			:Number			= 18;
		public static const SUBMENU_ARROW_SIZE	:Number			= 18;
		
		public static var s_leftMargin			:Number			= 5;
		public static var s_rightMargin			:Number			= 5;
		
		private var m_content					:String			= "";
		private var m_contentLabel				:Label			= null;
		
		private var m_iconUrl					:String			= "";
		private var m_iconLoader				:Image			= null;
		
		
		public function AioViewContextMenuItem(
											content			:String, 
											iconUrl			:String	= "", 
											subMenuItems	:Array	= null)
		{
			super();
			
			m_content	= content;
			m_iconUrl	= iconUrl;
			
			horizontalScrollPolicy	= ScrollPolicy.OFF;
			verticalScrollPolicy	= ScrollPolicy.OFF;
			
			setStyle("horizontalGap", 1);
			setStyle("backgroundColor", 0x3C3C3C);
			
			setStyle("paddingLeft", s_leftMargin);
			setStyle("paddingRight", s_rightMargin);
			
			percentWidth = 100;
		}
		
		public function dispose():void
		{
			
		}
		
		public function setText(text:String):void
		{
			m_content			= text;
			m_contentLabel.text	= m_content;
		}
		public function getText():String
		{
			return m_content;
		}
		
		public function getIconUrl():String
		{
			return m_iconUrl;
		}
		
		protected override function createChildren():void
		{
			super.createChildren();
			
			if (m_iconUrl != "")
			{
				m_iconLoader			= new Image();
//				var request:URLRequest	= new URLRequest(m_iconUrl);
//				m_iconLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onIconLoaderComplete);
				m_iconLoader.load(m_iconUrl);
				super.addChild(m_iconLoader);
			}
			else
			{
				var spacer:Spacer = new Spacer();
				spacer.width	= ICON_SIZE;
				spacer.height	= ICON_SIZE;
				super.addChild(spacer);
			}
			
			m_contentLabel			= new Label();
			m_contentLabel.text		= m_content;
			m_contentLabel.height	= ITEM_HEIGHT;
			
			super.addChild(m_contentLabel);
			
			initListeners();
		}
		
		private function initListeners():void
		{
			addEventListener(MouseEvent.CLICK,			onClick);
			addEventListener(MouseEvent.MOUSE_DOWN,		onMouseDown);
			addEventListener(MouseEvent.MOUSE_OVER,		onMouseOver);
			addEventListener(MouseEvent.MOUSE_OUT,		onMouseOut);
		}
		
		private function onIconLoaderComplete(e:Event):void
		{
			super.addChild(m_iconLoader);
			
			m_iconLoader.width		= ICON_SIZE;
			m_iconLoader.height		= ICON_SIZE;
		}
		
		public override function addChild(child:DisplayObject):DisplayObject
		{
			return null;
		}
		
		protected override function measure():void
		{
			super.measure();
			
			measuredWidth	= measuredMinWidth	= ICON_SIZE + s_leftMargin + s_rightMargin + 
									m_contentLabel.getExplicitOrMeasuredWidth() + SUBMENU_ARROW_SIZE;
			
			measuredHeight	= measuredMinHeight	= ITEM_HEIGHT;
		}
		
		protected function onClick(e:MouseEvent):void
		{
			e.stopPropagation();
		}
		
		protected function onMouseDown(e:MouseEvent):void
		{
			e.stopPropagation();
		}
		
		protected function onMouseOver(e:MouseEvent):void
		{
			setStyle("backgroundColor", 0x222222);
		}
		
		protected function onMouseOut(e:MouseEvent):void
		{
			setStyle("backgroundColor", 0x3C3C3C);
		}
		
	}
	
}
