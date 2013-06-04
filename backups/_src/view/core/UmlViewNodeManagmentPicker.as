package view.core
{
	import controler.UmlControler;
	import controler.UmlViewControler;
	import controler.events.UmlEvent;
	import controler.events.UmlViewEvent;
	
	import flash.display.GradientType;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Matrix;
	import flash.utils.Timer;
	
	import com.greensock.TweenMax;
	
	import mx.containers.Canvas;
	import mx.core.ScrollPolicy;
	import mx.core.UIComponent;
	import mx.effects.easing.Quintic;
	import mx.events.FlexEvent;
	
	import view.newView.UmlViewContextMenu;
	import view.newView.UmlViewContextMenuItem;
	import view.newView.UmlViewRegularNode;
	import view.umlView.UmlViewClass;
	
	/**
	 * 
	 * @author kamal
	 * 
	 */
	public class UmlViewNodeManagmentPicker extends UIComponent
	{
		
		/**
		 * 
		 */
		public static const PICKER_MAX_WIDTH	:Number		= 20;
		public static const PICKER_MARGIN		:Number		= 10;
		public static const DECORATION_SIZE		:Number		= 2;
		public static const ASSOC_ARROW_SIZE	:Number		= 5;
		
		/**
		 * 
		 */
		protected var _relatedNode			:UmlViewRegularNode	= null;
		protected var _headerBar			:UIComponent		= null;
		protected var _footerBar			:UIComponent		= null;
		protected var _buttonsHolder		:Canvas				= null;
		
		protected var _numButtons			:uint				= 0;
		
		protected var _isCollapsed			:Boolean			= false;
		protected var _collapseTweenTime	:Number				= 0.5;
		protected var _collapseEasing		:Function			= null;
		protected var _isStillOpening		:Boolean			= false;
		protected var _isStillCollapsing	:Boolean			= false;
		protected var _isOpenRequested		:Boolean			= false;
		protected var _isCollapseRequested	:Boolean			= false;
		protected var _isMouseStillOver		:Boolean			= false;
		
		protected var _alphaTimer			:Timer				= null;
		protected var _finalAlpha			:Number				= 0.0;
		
		protected var _numAssociations		:uint				= 0;
		protected var _associationsHolder	:Canvas				= null;
		protected var _associationsArrow	:UIComponent		= null;
		
		protected var _areAssociationsCollapsed	:Boolean		= true;
		protected var _actualAssociationsHeight	:Number			= 0;
		
		
		/**
		 * 
		 * @param relatedNode
		 * 
		 */
		public function UmlViewNodeManagmentPicker()
		{
			super();
			
			_collapseEasing		= Quintic.easeOut;
		}
		
		/*******************************************************************************************
		 * 
		 * overriden functions 
		 * 
		 ******************************************************************************************/
		
		protected override function createChildren():void
		{
			super.createChildren();
			
			_headerBar			= new UIComponent();
			_footerBar			= new UIComponent();
			
			_buttonsHolder		= new Canvas();
			_associationsHolder	= new Canvas();
			
			_associationsArrow	= new UIComponent();
			
			super.addChild(_headerBar);
			super.addChild(_footerBar);
			super.addChild(_buttonsHolder);
			super.addChild(_associationsHolder);
			super.addChild(_associationsArrow);
			
			_buttonsHolder.horizontalScrollPolicy		= ScrollPolicy.OFF;
			_buttonsHolder.verticalScrollPolicy			= ScrollPolicy.OFF;
			
			_associationsHolder.horizontalScrollPolicy	= ScrollPolicy.OFF;
			_associationsHolder.verticalScrollPolicy	= ScrollPolicy.OFF;
			
			if (parent != null && parent is UmlViewRegularNode)
			{
				_relatedNode = parent as UmlViewRegularNode;
				initListeners();
			}
		}
		
		protected override function measure():void
		{
			super.measure();
			
			measuredWidth	= measuredMinWidth	= PICKER_MAX_WIDTH;
			
			var buttonsHolderHeight			:Number = 0;
			var associationsHolderHeight	:Number = 0;
			
			if (_numButtons > 0)
			{
				buttonsHolderHeight = _numButtons * 
									UmlViewPickerItem.DEFAULT_PICKER_ITEM_SIZE;
			}
			
			if (_numAssociations > 0)
			{
				associationsHolderHeight = _numAssociations * 
									UmlViewPickerItem.DEFAULT_PICKER_ITEM_SIZE;
			}
			
			measuredHeight	= measuredMinHeight	=	buttonsHolderHeight + 
													associationsHolderHeight +
													DECORATION_SIZE * 2;
		}
		
		/**
		 * 
		 * @param unscaledWidth
		 * @param unscaledHeight
		 * 
		 */
		protected override function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			layoutChildren(measuredWidth, measuredHeight);
			paint(measuredWidth, measuredHeight);
		}
		
		/*******************************************************************************************
		 * 
		 * regular functions 
		 * 
		 ******************************************************************************************/
		
		protected function initListeners():void
		{
			addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			
			_relatedNode.addEventListener(UmlEvent.NODE_SELECTED,		onRelatedNodeSelected);
			_relatedNode.addEventListener(UmlEvent.NODE_DESELECTED,		onRelatedNodeDeselected);
			
			_relatedNode.addEventListener(MouseEvent.MOUSE_OVER,		onMouseOver);
			_relatedNode.addEventListener(MouseEvent.MOUSE_OUT,			onMouseOut);
			
			_associationsArrow.addEventListener(MouseEvent.MOUSE_DOWN,	onAssociationsArrowMouseDown);
		}
		
		/**
		 * 
		 * @param label
		 * @return 
		 * 
		 */
		public function addTopLevelButton(label:String=""):UmlViewPickerItem
		{
			_numButtons++;
			var pickerItem:UmlViewPickerItem = new UmlViewPickerItem(label);
			_buttonsHolder.addChild(pickerItem);
			invalidateSize();
			return pickerItem;
		}
		
		public function addLowLevelButton(type:String):UmlViewPickerItem
		{
			_numAssociations++;
			var pickerAssociationItem:UmlViewPickerItem = new UmlViewPickerItem(type);
			_associationsHolder.addChild(pickerAssociationItem);
			invalidateSize();
			return pickerAssociationItem;
		}
		
		/**
		 * 
		 * @param p_width
		 * @param p_height
		 * 
		 */
		protected function layoutChildren(p_width:Number, p_height:Number):void
		{
			_headerBar.x			= 0;
			_headerBar.y			= 0;
			_headerBar.width		= p_width;
			_headerBar.height		= DECORATION_SIZE;
			
			_buttonsHolder.width	= UmlViewPickerItem.DEFAULT_PICKER_ITEM_SIZE;
			_buttonsHolder.height	= _numButtons * UmlViewPickerItem.DEFAULT_PICKER_ITEM_SIZE;
			_buttonsHolder.x		= p_width / 2 - _buttonsHolder.width / 2;
			_buttonsHolder.y		= _headerBar.y + _headerBar.height;
			
			for (var i:uint = 0; i < _numButtons; i++)
			{
				var button:UmlViewPickerItem = _buttonsHolder.getChildAt(i) as UmlViewPickerItem;
				button.x = 0;
				button.y = i * UmlViewPickerItem.DEFAULT_PICKER_ITEM_SIZE;
			}
			
			_footerBar.x			= 0;
			_footerBar.y			= _buttonsHolder.y + _buttonsHolder.height;
			_footerBar.width		= p_width;
			_footerBar.height		= DECORATION_SIZE;
			
			_associationsHolder.width	= UmlViewPickerItem.DEFAULT_PICKER_ITEM_SIZE;
			
			// sert à rien puisqu'on le change régulièrement
			//if (!_areAssociationsCollapsed)
			//{
			//	_associationsHolder.height	= _numAssociations * UmlViewPickerItem.DEFAULT_PICKER_ITEM_SIZE;
			//}
			
			_associationsHolder.x		= p_width / 2 - _associationsHolder.width / 2;
			_associationsHolder.y		= _footerBar.y + DECORATION_SIZE;
			
			for (i = 0; i < _numAssociations; i++)
			{
				var assocButton:UmlViewPickerItem = _associationsHolder.getChildAt(i) as UmlViewPickerItem;
				assocButton.x = 0;
				assocButton.y = i * UmlViewPickerItem.DEFAULT_PICKER_ITEM_SIZE;
			}
			
			_associationsArrow.x		= 0;
			_associationsArrow.y		= _associationsHolder.y + _associationsHolder.height;
			_associationsArrow.width	= p_width;
			_associationsArrow.height	= ASSOC_ARROW_SIZE;
		}
		
		protected function paint(p_width:Number, p_height:Number):void
		{
			var headerMatrix:Matrix = new Matrix();
			
			with (_headerBar.graphics)
			{
				clear();
				
				headerMatrix.createGradientBox
				(
					_headerBar.width, 
					_headerBar.height, 
					UmlViewControler.toRadians(45)
				);
				
				beginGradientFill
				(
					GradientType.LINEAR, 
					[0xFF5500, 0xFF2200], 
					[1, 1], [0, 255],
					headerMatrix
				);
				
				drawRect(0, 0, _headerBar.width, _headerBar.height);//, 2, 2);
				endFill();
			}
			
			var footerMatrix:Matrix = new Matrix();
			
			with (_footerBar.graphics)
			{
				clear();
				
				footerMatrix.createGradientBox
				(
					_footerBar.width, 
					_footerBar.height, 
					UmlViewControler.toRadians(45)
				);
				
				beginGradientFill
				(
					GradientType.LINEAR, 
					[0xFF5500, 0xFF2200], 
					[1, 1], [0, 255], 
					footerMatrix
				);
				
				drawRect(0, 0, _footerBar.width, _footerBar.height);//, 2, 2);
				endFill();
			}
			
			var arrowMatrix:Matrix = new Matrix();
			
			with (_associationsArrow.graphics)
			{
				clear();
				
				arrowMatrix.createGradientBox
				(
					_associationsArrow.width, 
					_associationsArrow.height, 
					UmlViewControler.toRadians(45)
				);
				
				beginGradientFill
				(
					GradientType.LINEAR, 
					[0xDD5500, 0xDD2200], 
					[1, 1], [0, 255], 
					arrowMatrix
				);
				
				drawRect(0, 0, _associationsArrow.width, _associationsArrow.height);//, 2, 2);
				endFill();
			}
		}
		
		protected function open():void
		{
			TweenMax.to
			(
				this, 
				_collapseTweenTime, 
				{
					x			: _relatedNode.width + UmlViewResizer.SIDE_SIZE * 2, 
					ease		: _collapseEasing, 
					onUpdate	: function ():void
					{
						_isStillOpening	= true;
					}, 
					onComplete	: function ():void
					{
						_isStillOpening	= false;
						_isCollapsed	= false;
						
						if (_isCollapseRequested && !_isMouseStillOver)
						{
							//collapse();
							decreaseAlpha(false, 2);
						}
					}
				}
			);
			
			increaseAlpha();
		}
		
		protected function collapse():void
		{
			TweenMax.to
			(
				this, 
				_collapseTweenTime, 
				{
					x			: _relatedNode.width - PICKER_MAX_WIDTH, 
					ease		: _collapseEasing, 
					onUpdate	: function ():void
					{
						_isStillCollapsing	= true;
					}, 
					onComplete	: function ():void
					{
						_isStillCollapsing	= false;
						_isCollapsed		= true;
						
						collapseAssociations();
					}
				}
			);
			
			decreaseAlpha();
		}
		
		protected function initAlphaTimer():void
		{
			_alphaTimer = _alphaTimer || new Timer(1, 1);
			
			if (_alphaTimer.running)
			{
				_alphaTimer.stop();
			}
			
			if (!_alphaTimer.hasEventListener(TimerEvent.TIMER_COMPLETE))
			{
				_alphaTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onAlphaTimerComplete);
			}
			_alphaTimer.repeatCount = 1;
		}
		
		protected function increaseAlpha():void
		{
			_finalAlpha = 1.0;
			onAlphaTimerComplete();
		}
		
		protected function decreaseAlpha(hide:Boolean=true, time:uint=0):void
		{
			_finalAlpha = hide ? 0.0 : 0.1;
			
			if (time > 0)
			{
				initAlphaTimer();
				_alphaTimer.delay = time * 1000;
				_alphaTimer.start();
			}
			else
			{
				onAlphaTimerComplete();
			}
		}
		
		protected function onAlphaTimerComplete(e:TimerEvent=null):void
		{
			TweenMax.to
			(
				this, 
				_collapseTweenTime, 
				{
					alpha		: _finalAlpha, 
					ease		: _collapseEasing
				}
			);
		}
		
		protected function openAssociations():void
		{
			TweenMax.to
			(
				_associationsHolder, 
				_collapseTweenTime, 
				{
					height		: _numAssociations * UmlViewPickerItem.DEFAULT_PICKER_ITEM_SIZE, 
					ease		: _collapseEasing, 
					onComplete	: function ():void
					{
						_areAssociationsCollapsed = false;
					}
				}
			);
		}
		
		protected function collapseAssociations():void
		{
			UmlViewControler.getInstance().killTweenOnObject(this);
			TweenMax.to
			(
				_associationsHolder, 
				_collapseTweenTime, 
				{
					height		: 0, 
					ease		: _collapseEasing, 
					onComplete	: function ():void
					{
						_areAssociationsCollapsed = true;
					}
				}
			);
		}
		
		/*******************************************************************************************
		 * 
		 * business functions 
		 * 
		 ******************************************************************************************/
		
		
		
		/*******************************************************************************************
		 * 
		 * business callback functions 
		 * 
		 ******************************************************************************************/
		
		protected function onRelatedNodeSelected(e:UmlEvent):void
		{
			open();
		}
		
		protected function onRelatedNodeDeselected(e:UmlEvent):void
		{
			collapse();
			
//			if (_umlAddActionContextMenu != null)
//			{
//				resetContextMenu();
//			}
		}
		
		/*******************************************************************************************
		 * 
		 * callback functions 
		 * 
		 ******************************************************************************************/
		
		protected function onCreationComplete(e:FlexEvent):void
		{
			open();
			collapseAssociations();
		}
		
		protected function onMouseOver(e:MouseEvent):void
		{
			_isMouseStillOver = true;
			//open();
			if (_relatedNode.isSelected())
			{
				increaseAlpha();
			}
		}
		
		protected function onMouseOut(e:MouseEvent):void
		{
			_isMouseStillOver = false;
			
			if (_relatedNode.isSelected() && !_isStillOpening)
			{
				//collapse();
				decreaseAlpha(false, 2);
				_isCollapseRequested = false;
			}
			else
			{
				_isCollapseRequested = true;
			}
		}
		
		protected function onAssociationsArrowMouseDown(e:MouseEvent):void
		{
			if (_areAssociationsCollapsed)
			{
				openAssociations();
			}
			else
			{
				collapseAssociations();
			}
		}
		
	}
	
}
