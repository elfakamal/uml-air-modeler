package view.core
{
	import flash.display.DisplayObject;
	import flash.filters.GlowFilter;
	
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	
	import view.newView.UmlViewDiagram;
	import view.newView.UmlViewHorizontalTitle;
	import view.newView.UmlViewTitle;

	/**
	 * 
	 * @author kamal
	 * 
	 */
	public class UmlViewDiagramSelector extends UIComponent
	{
		
		/**
		 * 
		 */
		public static const DEFAULT_SELECTOR_MARGIN				:Number		= 2;
		public static const DEFAULT_SELECTOR_TITLE_HEIGHT		:Number		= 40;
		
		
		/**
		 * 
		 */
		protected var _diagram					:UmlViewDiagram		= null;
		protected var _isContentDirty			:Boolean				= true;
		
		/**
		 * we define this titleHolder as a hbox, cuz we want to add some components
		 * like the menu of diagram's operations ...  
		 */
		protected var _title					:UmlViewHorizontalTitle	= null;
		
		/**
		 * 
		 */
		protected var _background				:UIComponent		= null;
		protected var _lineTickness				:uint				= 1;
		protected var _lineColor				:Number				= 0x222222;
		protected var _selectorMargin			:Number				= 1;
		protected var _titleFillColor			:Number				= 0xFFFFFF;
		
		/**
		 * 
		 * 
		 */
		public function UmlViewDiagramSelector()
		{
			super();
			
			initListeners();
		}
		
		
		/*******************************************************************************************
		 * 
		 * overriden functions 
		 * 
		 ******************************************************************************************/
		
		/**
		 * 
		 * 
		 */
		protected override function createChildren():void
		{
			super.createChildren();
			
			_background		= new UIComponent();
			_title			= new UmlViewHorizontalTitle();
			
			super.addChild(_background);
			super.addChild(_title);
		}
		
		/**
		 * 
		 * @param child
		 * @return 
		 * 
		 */
		public override function addChild(child:DisplayObject):DisplayObject
		{
			return null;
		}
		
		/**
		 * 
		 * 
		 */
		protected override function commitProperties():void
		{
			super.commitProperties();
		}
		
		/**
		 * 
		 * 
		 */
		protected override function measure():void
		{
			super.measure();
			
			if (_isContentDirty && _diagram != null)
			{
				measuredWidth	= measuredMinWidth	= _diagram.width + 2 * DEFAULT_SELECTOR_MARGIN;
				measuredHeight	= measuredMinHeight	= _diagram.height + 2 * DEFAULT_SELECTOR_MARGIN + UmlViewTitle.TITLE_HEIGHT;
			}
		}
		
		/**
		 * 
		 * @param unscaledWidth
		 * @param unscaledHeight
		 * 
		 */
		protected override function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			if (_isContentDirty && _diagram != null)
			{
				// 
				// 
				// 
				var explicitOrMeasuredWidth		:Number = getExplicitOrMeasuredWidth();
				var explicitOrMeasuredHeight	:Number = getExplicitOrMeasuredHeight();
				
				layoutChildren(explicitOrMeasuredWidth, explicitOrMeasuredHeight);
				paintBackground(explicitOrMeasuredWidth, explicitOrMeasuredHeight);
				
				x = _diagram.x - DEFAULT_SELECTOR_MARGIN;
				y = _diagram.y - DEFAULT_SELECTOR_MARGIN - UmlViewTitle.TITLE_HEIGHT;
				
				_isContentDirty = false;
			}
		}
		
		/*******************************************************************************************
		 * 
		 * regular functions 
		 * 
		 ******************************************************************************************/
		
		/**
		 * 
		 * 
		 */
		protected function initListeners():void
		{
			addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
		}
		
		/**
		 * this methohd selects the diagram in parameter.
		 * 
		 * @param diagram
		 * 
		 */
		public function selectDiagram(diagram:UmlViewDiagram):void
		{
			_diagram			= diagram;
			_title.setText(_diagram.name);
			_isContentDirty		= true;
			
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
			_title.x			= 0;
			_title.y			= 0;
			_title.width		= p_width;
			_title.height		= UmlViewTitle.TITLE_HEIGHT;
		}
		
		/**
		 * 
		 * @param p_width
		 * @param p_height
		 * 
		 */
		protected function paintBackground(p_width:Number, p_height:Number):void
		{
			with(_background.graphics)
			{
				clear();
				lineStyle(_lineTickness, _lineColor);
				drawRoundRect(0, 0, p_width, p_height, 5, 5);
			}
		}
		
		
		/*******************************************************************************************
		 * 
		 * callback functions 
		 * 
		 ******************************************************************************************/
		
		protected function onCreationComplete(e:FlexEvent):void
		{
			filters = [new GlowFilter(0x000000, 1, 6, 6, 1, 1)];
		}
		
	}
	
}
