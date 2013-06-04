package view.newView
{
	
	import com.greensock.TweenMax;
	import com.greensock.easing.Quint;
	
	import controler.UmlLayoutControler;
	import controler.UmlViewControler;
	
	import flash.display.DisplayObject;
	import flash.display.GradientType;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.BitmapFilterType;
	import flash.filters.DropShadowFilter;
	import flash.filters.GradientGlowFilter;
	import flash.geom.Matrix;
	import flash.utils.Timer;
	
	import mx.containers.HBox;
	import mx.core.Container;
	import mx.core.ScrollPolicy;
	import mx.effects.easing.Quintic;
	import mx.events.FlexEvent;
	import mx.events.FlexNativeWindowBoundsEvent;
	
	/**
	 * 
	 * @author kamal
	 * 
	 */
	public class UmlViewToolBar extends Container
	{
		
		/**
		 * 
		 */
		public static const TOOL_BAR_HEIGHT				:Number			= 80;
		public static const TOOL_BAR_TITLE_HEIGHT		:Number			= 20;
		
		/**
		 * 
		 * 
		 */
		protected var _holder					:HBox		= null;
		protected var _numTools					:uint						= 0;
		
		/**
		 * animation & easing
		 * 
		 */
		private var _isCollapsed				:Boolean					= true;
		private var _timeCollapsing				:Number						= 1;
		private var _easingFunction				:Function					= null;
		
		/**
		 * position of the bar
		 * 
		 */
		private var _isPositionDirty			:Boolean					= true;
		private var _newX						:Number						= 0;
		private var _newY						:Number						= 0;
		
		/**
		 * title component
		 * 
		 */
		private var _uiTitle					:UmlViewHorizontalTitle		= null;
		
		/**
		 * filters & effects
		 * 
		 */
		private var _isGradientDirty			:Boolean			= true;
		
		private var _topLineSprite				:Sprite				= null;
		
		private var _leftGradientSprite			:Sprite				= null;
		private var _leftGradientWidth			:Number				= 50;
		
		private var _rightGradientSprite		:Sprite				= null;
		private var _rightGradientWidth			:Number				= 50;
		
		protected var _maxChildHeight			:Number				= 0;
		protected var _isSizeDirty				:Boolean			= true;
		
		protected var _actualX					:Number				= 0;
		
		protected var _temporaryTweenerObject	:Object				= null;
		protected var _isMouseOverSide			:Boolean			= false;
		
		/**
		 * it's calculated ... 
		 */
		protected var _scrollingTime			:Number				= 1;
		protected var _scrollingTimer			:Timer				= null;
		protected var _isScrollAllowed			:Boolean			= false;
		protected var _mouseOverSide			:Sprite				= null;
		
		
		/**
		 * 
		 * 
		 */
		public function UmlViewToolBar()
		{
			super();
			
			_holder							= new HBox();
			_holder.verticalScrollPolicy	= ScrollPolicy.OFF;
			
			_easingFunction					= Quintic.easeOut;
			
			// cette propriété est responsable de l'opacité du background, mais elle cause un petit
			// effet non voulu lors du début du collapse, il faut qu'elle reste tel quelle.
			//opaqueBackground = true;
			
			_scrollingTimer			= new Timer(1);
			_scrollingTimer.addEventListener(TimerEvent.TIMER, onScrollingTimer);
			
			initListeners();
		}
		
		/***********************************************************************
		 * 
		 * overriden functions 
		 * 
		 **********************************************************************/
		
		/**
		 * 
		 * 
		 */
		protected override function createChildren():void
		{
			super.createChildren();
			
			_topLineSprite				= new Sprite();
			_leftGradientSprite			= new Sprite();
			_rightGradientSprite		= new Sprite();
			
			this.rawChildren.addChild(_topLineSprite);
			this.rawChildren.addChild(_leftGradientSprite);
			this.rawChildren.addChild(_rightGradientSprite);
			
			initTitleComponent();
			
			addChildAt(_holder, numChildren - 1);
			
			initSidesListeners();
		}
		
		/**
		 * 
		 * @param child
		 * @return 
		 * 
		 */
		public override function addChild(child:DisplayObject):DisplayObject
		{
			if (child is UmlViewToolItem)
			{
				if (child.height > _maxChildHeight)
				{
					_maxChildHeight		= child.height;
					_isSizeDirty		= true;
				}
				
				child.addEventListener(MouseEvent.MOUSE_OVER,		onMouseOver);
				child.addEventListener(MouseEvent.MOUSE_OUT,		onMouseOut);
				
				_numTools++;
				
				if (_numTools <= 10)
				{
					_scrollingTime = 1;
				}
				else
				{
					_scrollingTime = _numTools / 10;
				}
				
				return _holder.addChild(child);
			}
			return super.addChild(child);
		}
		
		/**
		 * 
		 * 
		 */
		protected override function commitProperties():void
		{
			verticalScrollPolicy			= ScrollPolicy.OFF;
			horizontalScrollPolicy			= ScrollPolicy.OFF;
			
			_holder.setStyle("horizontalGap", "10");
		}
		
		/**
		 * 
		 * 
		 */
		protected override function measure():void
		{
			if (_isSizeDirty)
			{
				if (_maxChildHeight > 0) _holder.height = _maxChildHeight;
				_isSizeDirty = false;
			}
			
			measuredWidth		= measuredMinWidth		= unscaledWidth;
			measuredHeight		= measuredMinHeight		= _uiTitle.height + _holder.height + 5;
		}
		
		/**
		 * 
		 * @param unscaledWidth
		 * @param unscaledHeight
		 * 
		 */
		protected override function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			this.percentWidth		= 100;
			
			_uiTitle.move(0, 0)
			_uiTitle.setActualSize(unscaledWidth, TOOL_BAR_TITLE_HEIGHT);
			
			_holder.x					= _actualX;
			_holder.y					= _uiTitle.height + 5;
			
			_holder.width = _numTools * 
							((_holder.getChildAt(0) as UmlViewToolItem).getExplicitOrMeasuredWidth() + 
							Number(_holder.getStyle("horizontalGap"))) + 
							Number(_holder.getStyle("horizontalGap"));
			
			_holder.height				= TOOL_BAR_HEIGHT;
			
			if (_isPositionDirty)
			{
				invalidatePosition();
			}
			
			if (_isGradientDirty)
			{
				paint();
			}
		}
		
		/***********************************************************************
		 * 
		 * regular functions 
		 * 
		 **********************************************************************/
		
		/**
		 * 
		 * 
		 */
		protected function initListeners():void
		{
			addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			
			UmlLayoutControler.getInstance().addNativeResizeEventListener(onWindowResize);
			
			addEventListener(Event.ADDED_TO_STAGE,		onAddedToStage);
			
			addEventListener(MouseEvent.MOUSE_DOWN,		onMouseDown);
			
			addEventListener(MouseEvent.MOUSE_OVER,		onMouseOver);
			addEventListener(MouseEvent.MOUSE_OUT,		onMouseOut);
		}
		
		private function onAddedToStage(event:Event):void
		{
			if (parent != null)
			{
				_newY = parent.height - 20;
			}
		}
		
		/**
		 * 
		 * initialisation du title de la fenêtre
		 */
		private function initTitleComponent():void
		{
			_uiTitle = new UmlViewHorizontalTitle("ToolBar");
			
			_uiTitle.setDropShadowEnabled(true);
			_uiTitle.setCollapseAllowed(false);
			_uiTitle.setCloseAllowed(false);
			
			addChild(_uiTitle);
		}
		
		/**
		 * ajoute un item à l'applicationControlBar utilisé pour contenir les toolItems.
		 * 
		 * @param toolItem
		 * 
		 */
		public function addTool(toolItem:UmlViewToolItem):void
		{
			if (!this.contains(toolItem))
			{
				addChild(toolItem);
			}
		}
		
		/**
		 * 
		 * 
		 */
		private function invalidatePosition():void
		{
			UmlLayoutControler.getInstance().setTweenMaxTweening(true);
			
			TweenMax.to
			(
				this, 
				_timeCollapsing, 
				{
					y				: _newY, 
					ease			: _easingFunction,
					onComplete		: function ():void
					{
						_isPositionDirty = false;
						UmlLayoutControler.getInstance().setTweenMaxTweening(false);
					}
				}
			);
		}
		
		/**
		 * 
		 * 
		 */
		public function open():void
		{
			if (parent)
			{
				_newX				= 0;
				_newY				= this.parent.height - this.height;
				
				_easingFunction		= Quintic.easeOut;
				_timeCollapsing		= 1;
				
				_isPositionDirty	= true;
				_isCollapsed		= false;
				
				invalidateDisplayList();
			}
		}
		
		/**
		 * 
		 * 
		 */
		public function collapse():void
		{
			if (parent)
			{
				_newX				= 0;
				_newY				= this.parent.height - 20;
				
				_easingFunction		= Quintic.easeInOut;
				_timeCollapsing		= 1;
				
				_isPositionDirty	= true;
				_isCollapsed		= true;
				
				invalidateDisplayList();
			}
		}
		
		/**
		 * 
		 * 
		 */
		protected function initSidesListeners():void
		{
			_leftGradientSprite.addEventListener(MouseEvent.MOUSE_OVER,	onSideMouseOver);
			_leftGradientSprite.addEventListener(MouseEvent.MOUSE_OUT,	onSideMouseOut);
			
			_rightGradientSprite.addEventListener(MouseEvent.MOUSE_OVER,	onSideMouseOver);
			_rightGradientSprite.addEventListener(MouseEvent.MOUSE_OUT,		onSideMouseOut);
		}
		
		/**
		 * 
		 * 
		 */
		private function initGradients():void
		{
			var _topLineMatrix:Matrix = new Matrix();
			_topLineMatrix.createGradientBox(unscaledWidth, .1, 0, 0, 0);
			
			_topLineSprite.graphics.clear();
			_topLineSprite.graphics.lineStyle(.1, 0);
			_topLineSprite.graphics.lineGradientStyle
			(
				GradientType.LINEAR, 
				[0x000000, 0xFFFFFF, 0x000000], 
				[0, 1, 0], 
				[0, 128, 255], 
				_topLineMatrix
			);
			_topLineSprite.graphics.drawRect(0, 0, unscaledWidth, 0.1);
			
			var leftGradientBoxMatrix:Matrix = new Matrix();
			leftGradientBoxMatrix.createGradientBox(_leftGradientWidth, unscaledHeight, 0, 0, 0);
			
			_leftGradientSprite.graphics.clear();
			_leftGradientSprite.graphics.beginGradientFill
			(
				GradientType.LINEAR, 
				[0x000000, 0x000000], 
				[0.6, 0], 
				null, 
				leftGradientBoxMatrix
			);
			_leftGradientSprite.graphics.drawRect(0, 0, _leftGradientWidth, unscaledHeight);
			
			var rightGradientBoxMatrix:Matrix = new Matrix();
			rightGradientBoxMatrix.createGradientBox(_rightGradientWidth, unscaledHeight, 0, 0, 0);
			
			_rightGradientSprite.graphics.clear();
			_rightGradientSprite.graphics.beginGradientFill
			(
				GradientType.LINEAR, 
				[0x000000, 0x000000], 
				[0, 0.6], 
				null, 
				leftGradientBoxMatrix
			);
			_rightGradientSprite.graphics.drawRect(0, 0, _rightGradientWidth, unscaledHeight);
		}
		
		private function paint():void
		{
			initGradients();
			
			graphics.clear();
			graphics.beginFill(0x000000, 1);
			graphics.drawRoundRect(0, 0, unscaledWidth, unscaledHeight, 5, 5);
			graphics.endFill();
			
			_topLineSprite.x			= 0
			_topLineSprite.y			= 0
			
			_leftGradientSprite.x		= 0;
			_leftGradientSprite.y		= 0;
			
			_rightGradientSprite.x		= unscaledWidth - _rightGradientWidth;
			_rightGradientSprite.y		= 0;
			
			_isGradientDirty = false;
		}
		
		/**
		 * direction 	1	: x++ 
		 * direction 	-1	: x-- 
		 * 
		 * @param direction 
		 */
		protected function tweenedDecalage(direction:int):void
		{
			UmlViewControler.getInstance().killTweenOnObject(_temporaryTweenerObject);
			
			_temporaryTweenerObject = {_x : _actualX};
			
			TweenMax.to
			(
				_temporaryTweenerObject, 
				2 * _scrollingTime, 
				{
					_x			: _actualX + 100 * direction, 
					ease		: Quint.easeOut, 
					onUpdate	: function ():void
					{
						_holder.x = _actualX = _temporaryTweenerObject._x;
					}
				}
			);
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function isCollapsed():Boolean
		{
			return _isCollapsed;
		}
		
		/***********************************************************************
		 * 
		 * callback functions 
		 * 
		 **********************************************************************/
		
		/**
		 * 
		 * 
		 */
		private function onClick(e:MouseEvent):void
		{
			
		}
		
		/**
		 * 
		 * @param e
		 * 
		 */
		private function onWindowResize(e:FlexNativeWindowBoundsEvent):void
		{
			if (parent && parent.height > 0)
			{
				_newY = parent.height - UmlViewTitle.TITLE_HEIGHT;
				_isPositionDirty = true;
			}
			
			if (_topLineSprite.width < unscaledWidth)
			{
				_isGradientDirty = true;
			}
			
			invalidateDisplayList();
		}
		
		/**
		 * 
		 * 
		 */
		private function onCreationComplete(e:FlexEvent):void
		{
			// Define a gradient glow. 
			var gradientGlow:GradientGlowFilter = new GradientGlowFilter();
			gradientGlow.distance = 0;
			gradientGlow.angle = 45;
			gradientGlow.colors = [0x000000, 0x000000];
			gradientGlow.alphas = [1, 0];
			gradientGlow.ratios = [0, 255];
			gradientGlow.blurX = 60;
			gradientGlow.blurY = 80;
			gradientGlow.strength = 1;
			gradientGlow.quality = BitmapFilterQuality.HIGH;
			gradientGlow.type = BitmapFilterType.INNER;
			
			var dropShadow:DropShadowFilter = new DropShadowFilter(5, -90, 0x000000, 1, 4, 4, 1, 10);
			filters = [gradientGlow, dropShadow];
			
			_isGradientDirty = true;
			invalidateDisplayList();
		}
		
		protected function onMouseDown(e:MouseEvent):void
		{
			
		}
		
		/**
		 * 
		 * 
		 */
		protected function onMouseOver(e:MouseEvent):void
		{
			if (_isCollapsed) open();
		}
		
		/**
		 * 
		 * 
		 */
		protected function onMouseOut(e:MouseEvent):void
		{
			if (!_isCollapsed)
			{
				var case1:Boolean = (e.target == this && !(e.relatedObject is UmlViewToolItem));
				var case2:Boolean = (e.target is UmlViewToolItem && e.relatedObject != this);
				var case3:Boolean = e.relatedObject == null || 
									e.relatedObject is UmlViewDiagram || 
									e.relatedObject is UmlViewDiagramContainer;
				
				if (case1 || case2 || case3)
				{
					 collapse();
				}
			}
		}
		
		/**
		 * 
		 * @param e
		 * 
		 */
		protected function onScrollingTimer(e:TimerEvent):void
		{
			if (_isMouseOverSide && _mouseOverSide != null)
			{
				if (_mouseOverSide == _leftGradientSprite)
				{
					if (_holder.x < _leftGradientSprite.x + _leftGradientSprite.width)
					{
						_holder.x = _actualX = _holder.x + _scrollingTime * 2;
					}
					else
					{
						_scrollingTimer.stop();
						_scrollingTimer.reset();
						if (_isScrollAllowed)
						{
							tweenedDecalage(1);
						}
					}
				}
				else if (_mouseOverSide == _rightGradientSprite)
				{
					if (_holder.x > unscaledWidth - _holder.width - _rightGradientSprite.width)
					{
						_holder.x = _actualX = _holder.x - _scrollingTime * 2;
					}
					else
					{
						_scrollingTimer.stop();
						_scrollingTimer.reset();
						if (_isScrollAllowed)
						{
							tweenedDecalage(-1);
						}
					}
				}
				e.updateAfterEvent();
			}
			
			if ((_holder.x < _leftGradientSprite.x + _leftGradientSprite.width) ||
				(_holder.x >  unscaledWidth - _holder.width - _rightGradientSprite.width))
			{
				_isScrollAllowed = true;
			}
		}
		
		/**
		 * 
		 * @param e
		 * 
		 */
		protected function onSideMouseOver(e:MouseEvent):void
		{
			UmlViewControler.getInstance().killTweenOnObject(_temporaryTweenerObject);
			
			_isMouseOverSide		= true;
			_mouseOverSide			= e.target as Sprite;
			_isScrollAllowed		= false;
			
			_scrollingTimer.start();
		}
		
		/**
		 * 
		 * @param e
		 * 
		 */
		protected function onSideMouseOut(e:MouseEvent=null):void
		{
			_isMouseOverSide		= false;
			_mouseOverSide			= null;
			
			_scrollingTimer.stop();
			_scrollingTimer.reset();
			
			if (_holder.x < _leftGradientSprite.width && 
				_holder.x > unscaledWidth - _holder.width - _rightGradientSprite.width)
			{
				if (e.target == _leftGradientSprite)
				{
					tweenedDecalage(1);
				}
				else if (e.target == _rightGradientSprite)
				{
					tweenedDecalage(-1);
				}
			}
		}
		
	}
	
}
