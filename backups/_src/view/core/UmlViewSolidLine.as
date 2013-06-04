package view.core
{
	
	import com.greensock.TweenMax;
	
	import controler.UmlViewControler;
	
	import flash.display.GradientType;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	import mx.collections.ArrayCollection;
	import mx.core.Application;
	import mx.core.UIComponent;
	
	import view.newView.associations.UmlViewAssociation;
	
	/**
	 * 
	 * @author kamal
	 * 
	 */
	public class UmlViewSolidLine extends UIComponent
	{
		
		public static const HORIZONTAL		:uint			= 1;
		public static const VERTICAL		:uint			= 2;
		
		/**
		 * 
		 */
		public static const MAX_LINE_TICKNESS			:Number		= 5;
		public static const MIN_LINE_TICKNESS			:Number		= .1;
		public static const DEFAULT_LINE_TICKNESS		:Number		= 5;
		
		public static const DEFAULT_LINE_COLOR			:uint		= 0xFFFFFF;
		
		/**
		 * 
		 */		
		public static const MAX_LINE_POINTS				:uint		= 3;
		
		
		/**
		 * this array contains the point's graphic handlers.
		 */
		protected var _pointHandlers		:ArrayCollection		= null;
		
		protected var _pointHandlerAlphaTweeningTime	:Number		= 1;
		protected var _movedPointHandlerPoint			:Point		= null;
		protected var _movedPointHandler	:UIComponent			= null;
		
		protected var _movedSide			:UIComponent			= null;
		
		
		/**
		 * this is the array that is supposed to contain association's cuts.
		 * 
		 * like this : 
		 * ---------+
		 * 			|
		 * 			|
		 * 			|
		 * 			+------------
		 */
		protected var _points				:ArrayCollection		= null;
		
		protected var _sides				:Array					= null;
		
		/**
		 * all links 
		 */
		protected var _links				:ArrayCollection		= null;
		
		/**
		 * link's backgrounds
		 */
		protected var _backgrounds			:ArrayCollection		= null;
		protected var _dividedLinkIndex		:int					= -1;
		
		/**
		 * 
		 */
		protected var _arrow				:Sprite					= null;
		
		protected var _isSelected			:Boolean				= false
		
		/**
		 * accessories
		 */
		protected var _lineColor			:uint		= DEFAULT_LINE_COLOR;
		protected var _lineTickness			:Number		= DEFAULT_LINE_TICKNESS;
		
		protected var _lineGlowColor		:Number		= 0xFF5500;
		protected var _lineGlowBlurX		:Number		= 2;
		protected var _lineGlowBlurY		:Number		= 2;
		protected var _lineGlowStrength		:Number		= 2;
		protected var _lineGlowQuality		:uint		= 5;
		
		
		/**
		 * 
		 */
		public function UmlViewSolidLine()
		{
			super();
			
			doubleClickEnabled = true;
			
			initListeners();
			
			// this filter is the default for all the subClasses
			filters = 
			[
				new GlowFilter
				(
					0xFFFFFF, 
					1, 
					_lineGlowBlurX, 
					_lineGlowBlurY, 
					_lineGlowStrength, 
					_lineGlowQuality
				)
			];
			
		}
		
		protected function initListeners():void
		{
			
		}
		
		protected function initPointHandlerListsners(pointHandler:UIComponent):void
		{
			pointHandler.addEventListener(MouseEvent.MOUSE_DOWN,	onPointHandlerMouseDown);
			pointHandler.addEventListener(MouseEvent.DOUBLE_CLICK,	onPointHandlerDoubleClick);
			pointHandler.addEventListener(MouseEvent.MOUSE_OVER,	onPointHandlerMouseOver);
			pointHandler.addEventListener(MouseEvent.MOUSE_OUT,		onPointHandlerMouseOut);
		}
		
		protected function removePointHandlerListsners(pointHandler:UIComponent):void
		{
			pointHandler.removeEventListener(MouseEvent.MOUSE_DOWN,		onPointHandlerMouseDown);
			pointHandler.removeEventListener(MouseEvent.DOUBLE_CLICK,	onPointHandlerDoubleClick);
			pointHandler.removeEventListener(MouseEvent.MOUSE_OVER,		onPointHandlerMouseOver);
			pointHandler.removeEventListener(MouseEvent.MOUSE_OUT,		onPointHandlerMouseOut);
		}
		
		public function setSides(sides:Array):void
		{
			var i		:int			= 0;
			var side	:UIComponent	= null;
			
			if (sides != null && sides.length == 2)
			{
				_sides = sides;
				
				for (i = 0; i < _sides.length; i++)
				{
					side = _sides[i] as UIComponent;
					initSideListeners(side);
				}
				
				update();
			}
		}
		
		protected function initSideListeners(side:UIComponent):void
		{
			if (side != null)
			{
				side.addEventListener(MouseEvent.MOUSE_DOWN, onSideMouseDown);
			}
		}
		
		protected function removeSideListeners(side:UIComponent):void
		{
			if (side != null)
			{
				side.removeEventListener(MouseEvent.MOUSE_DOWN, onSideMouseDown);
			}
		}
		
		protected function onSideMouseDown(event:MouseEvent):void
		{
			var side:UIComponent = event.currentTarget as UIComponent;
			
			_movedSide = side;
			
			if (side != null && side.parent != null)
			{
				side.parent.addEventListener(MouseEvent.MOUSE_MOVE,	onSideMouseMove);
				side.parent.addEventListener(MouseEvent.MOUSE_UP,	onSideMouseUp);
			}
		}
		
		protected function onSideMouseMove(event:MouseEvent):void
		{
			update();
			event.updateAfterEvent();
		}
		
		protected function onSideMouseUp(event:MouseEvent):void
		{
			var side:UIComponent = event.currentTarget as UIComponent;
			
			if (side != null && side.parent != null)
			{
				side.parent.removeEventListener(MouseEvent.MOUSE_MOVE,	onSideMouseMove);
				side.parent.removeEventListener(MouseEvent.MOUSE_UP,	onSideMouseUp);
			}
			
			_movedSide = null;
		}
		
		private function update():void
		{
			var side1					:UIComponent	= null;
			var side2					:UIComponent	= null;
			var movedPointHandlerIndex	:int			= -1;
			var direction				:int			= 0;
			
			if (_movedPointHandler != null)
			{
				movedPointHandlerIndex = _pointHandlers.getItemIndex(_movedPointHandler);
			}
			
			if (_sides != null && _sides.length == 2)
			{
				side1 = _sides[0];
				side2 = _sides[1];
				
				if (side1 != null && side1.parent != null)
				{
					if (isThereAPoint() && 
						movedPointHandlerIndex == 1 && 
						movedPointHandlerIndex >= _pointHandlers.length - 2)
					{
						renderLine(-1);
						renderLine(1);
					}
					else
					{
						if (movedPointHandlerIndex == 1)
						{
							direction = -1;
						}
						else if (movedPointHandlerIndex >= _pointHandlers.length - 2)
						{
							direction = 1;
						}
						
						if (direction == 0)
						{
							if (_movedSide == null)
							{
								_movedSide = side2;
							}
						}
						
						renderLine(direction);
					}
				}
			}
		}
		
		protected function renderLine(renderDirection:int=0):void
		{
			// side 1
			var A1		:Point	= new Point();
			var B1		:Point	= new Point();
			var C1		:Point	= new Point();
			var D1		:Point	= new Point();
			
			// side 2
			var A2		:Point	= new Point();
			var B2		:Point	= new Point();
			var C2		:Point	= new Point();
			var D2		:Point	= new Point();
			
			var movedPointHandlerIndex	:int	= -1;
			var movedSideIndex			:int	= -1;
			var firstIndex				:int	= -1;
			var lastIndex				:int	= -1;
			
			if (_movedPointHandler != null || renderDirection != 0)
			{
				movedPointHandlerIndex = _pointHandlers.getItemIndex(_movedPointHandler);
				
				if (movedPointHandlerIndex < 0 && renderDirection == 0)
				{
					return;
				}
				
				if (movedPointHandlerIndex == 1 ||  
					movedPointHandlerIndex >= _pointHandlers.length - 2 || 
					renderDirection != 0)
				{
					if (renderDirection < 0)
					{
						initRectangleCorners(_sides[0], A1, B1, C1, D1, true);
						initRectangleCorners(_pointHandlers[1], A2, B2, C2, D2, true);
						
						firstIndex	= 0;
						lastIndex	= 1;
					}
					else if (renderDirection > 0)
					{
						initRectangleCorners(_pointHandlers[_points.length - 2], A1, B1, C1, D1, true);
						initRectangleCorners(_sides[_sides.length - 1], A2, B2, C2, D2, true);
						
						firstIndex	= _points.length - 2;
						lastIndex	= _points.length - 1;
					}
				}
			}
			else
			{
				if (_movedSide != null)
				{
					movedSideIndex	= _sides.indexOf(_movedSide);
					
					if (movedSideIndex == 0)
					{
						firstIndex	= movedSideIndex;
						lastIndex	= movedSideIndex + 1;
						
						initRectangleCorners(_sides[firstIndex], A1, B1, C1, D1, true);
						
						if (isThereAPoint())
						{
							initRectangleCorners(_pointHandlers[lastIndex], A2, B2, C2, D2, true);
						}
						else
						{
							initRectangleCorners(_sides[lastIndex], A2, B2, C2, D2, true);
						}
					}
					else if (movedSideIndex == _sides.length - 1)
					{
						if (isThereAPoint())
						{
							initRectangleCorners
							(
								_pointHandlers[_points.length - 2], 
								A1, B1, C1, D1, 
								true
							);
						}
						else
						{
							initRectangleCorners(_sides[movedSideIndex - 1], A1, B1, C1, D1, true);
						}
						
						initRectangleCorners(_sides[movedSideIndex], A2, B2, C2, D2, true);
						
						firstIndex	= _points.length - 2;
						lastIndex	= _points.length - 1;
					}
				}
			}
			
			// test the step 1 cases : 
			// A1 & C2, B1 & D2, C1 & A2, D1 & B2
			var isLeftTop		:Boolean	= A1.x >= C2.x && A1.y >= C2.y;
			var isRightTop		:Boolean	= B1.x <= D2.x && B1.y >= D2.y;
			var isRightBottom	:Boolean	= C1.x <= A2.x && C1.y <= A2.y;
			var isLeftBottom	:Boolean	= D1.x >= B2.x && D1.y <= B2.y;
			
			if (isLeftTop)
			{
				updatePointAt(A1.x, A1.y, firstIndex);
				updatePointAt(C2.x, C2.y, lastIndex);
			}
			else if (isRightTop)
			{
				updatePointAt(B1.x, B1.y, firstIndex);
				updatePointAt(D2.x, D2.y, lastIndex);
			}
			else if (isRightBottom)
			{
				updatePointAt(C1.x, C1.y, firstIndex);
				updatePointAt(A2.x, A2.y, lastIndex);
			}
			else if (isLeftBottom)
			{
				updatePointAt(D1.x, D1.y, firstIndex);
				updatePointAt(B2.x, B2.y, lastIndex);
			}
			else
			{
				var isLeft			:Boolean		= A1.x > B2.x;
				var isTop			:Boolean		= A1.y > D2.y;
				var isRight			:Boolean		= B1.x < A2.x;
				var isBottom		:Boolean		= D1.y < A2.y;
				
				var left1			:Number			= 0;
				var top1			:Number			= 0;
				var right1			:Number			= 0;
				var bottom1			:Number			= 0;
				
				var left2			:Number			= 0;
				var top2			:Number			= 0;
				var right2			:Number			= 0;
				var bottom2			:Number			= 0;
				
				var zoneLeft		:Number			= 0;
				var zoneTop			:Number			= 0;
				var zoneRight		:Number			= 0;
				var zoneBottom		:Number			= 0;
				
				if (isLeft)
				{
					top1			= A1.y;
					bottom1			= D1.y;
					
					top2			= B2.y;
					bottom2			= C2.y;
					
					zoneTop			= (top1 >= top2)		? top1		: top2;
					zoneBottom		= (bottom1 <= bottom2)	? bottom1	: bottom2;
					
					updatePointAt(A1.x, zoneTop + (zoneBottom - zoneTop) / 2, firstIndex);
					updatePointAt(B2.x, zoneTop + (zoneBottom - zoneTop) / 2, lastIndex);
				}
				else if (isTop)
				{
					left1			= A1.x;
					right1			= B1.x;
					
					left2			= D2.x;
					right2			= C2.x;
					
					zoneLeft		= (left1 >= left2)		? left1		: left2;
					zoneRight		= (right1 <= right2)	? right1	: right2;
					
					updatePointAt(zoneLeft + (zoneRight - zoneLeft) / 2, A1.y, firstIndex);
					updatePointAt(zoneLeft + (zoneRight - zoneLeft) / 2, D2.y, lastIndex);
				}
				else if (isRight)
				{
					top1			= B1.y;
					bottom1			= C1.y;
					
					top2			= A2.y;
					bottom2			= D2.y;
					
					zoneTop			= (top1 >= top2)		? top1		: top2;
					zoneBottom		= (bottom1 <= bottom2)	? bottom1	: bottom2;
					
					updatePointAt(B1.x, zoneTop + (zoneBottom - zoneTop) / 2, firstIndex);
					updatePointAt(A2.x, zoneTop + (zoneBottom - zoneTop) / 2, lastIndex);
				}
				else if (isBottom)
				{
					left1			= D1.x;
					right1			= C1.x;
					
					left2			= A2.x;
					right2			= B2.x;
					
					zoneLeft		= (left1 >= left2)		? left1		: left2;
					zoneRight		= (right1 <= right2)	? right1	: right2;
					
					updatePointAt(zoneLeft + (zoneRight - zoneLeft) / 2, D1.y, firstIndex);
					updatePointAt(zoneLeft + (zoneRight - zoneLeft) / 2, A2.y, lastIndex);
				}
			}
		}
		
		protected function initRectangleCorners(
									component:UIComponent, 
									A:Point, B:Point, C:Point, D:Point, 
									isComponentSwapped:Boolean = false):void
		{
			if (component	== null || 
				A			== null || 
				B			== null || 
				C			== null || 
				D			== null)
			{
				return;
			}
			
			var parentPoint:Point = new Point();
			
			if (isComponentSwapped)
			{
				if (component.parent != null)
				{
					parentPoint.x = component.parent.x;
					parentPoint.y = component.parent.y;
				}
			}
			
			A.x = parentPoint.x + component.x;
			A.y = parentPoint.y + component.y;
			
			B.x = parentPoint.x + component.x + component.width;
			B.y = parentPoint.y + component.y;
			
			C.x = parentPoint.x + component.x + component.width;
			C.y = parentPoint.y + component.y + component.height;
			
			D.x = parentPoint.x + component.x;
			D.y = parentPoint.y + component.y + component.height;
		}
		
		/**
		 * adds a link to this line
		 */
		protected function addLink():Sprite
		{
			var link		:Sprite = new Sprite();
			var background	:Sprite = new Sprite();
			
			if (_links == null)
			{
				_links = new ArrayCollection();
			}
			
			if (_backgrounds == null)
			{
				_backgrounds = new ArrayCollection();
			}
			
			background.alpha = 0.0;
			
			link.addEventListener(MouseEvent.DOUBLE_CLICK,			onLinkDoubleClick);
			background.addEventListener(MouseEvent.DOUBLE_CLICK,	onLinkDoubleClick);
			
			background.addEventListener(MouseEvent.MOUSE_OVER,	onBackgroundMouseOver);
			background.addEventListener(MouseEvent.MOUSE_OUT,	onBackgroundMouseOut);
			
			if (_dividedLinkIndex < 0)
			{
				_links.addItem(link);
				_backgrounds.addItem(background);
			}
			else if (_dividedLinkIndex >= 0)
			{
				_links.addItemAt(link, _dividedLinkIndex);
				_backgrounds.addItemAt(background, _dividedLinkIndex);
			}
			
			this.addChildAt(background, 0);
			
			return this.addChild(link) as Sprite;
		}
		
		protected function addPoint(x:Number, y:Number, isDoubleClicked:Boolean=false):void
		{
			var index			:int			= 0;
			var pointHandler	:UIComponent	= null;
			
			if( _links != null && isDoubleClicked )
			{
				addLink();
			}
			
			pointHandler = createPointHandler(x, y);
			internalAddPoint(x, y, pointHandler);
			addChild(pointHandler);
		}
		
		/**
		 * this function adds a point to the points list
		 * between the first & last points
		 * 
		 * but it must adds it at the good index.
		 * 
		 * it return the new point's index. 
		 */
		protected function internalAddPoint(x:Number, y:Number, pointHandler:UIComponent):int
		{
			var point:Point = new Point(x, y);
			
			if (_points == null)
			{
				_points			= new ArrayCollection();
				_pointHandlers	= new ArrayCollection();
			}
			
			if (_points.length == 2)
			{
				_points.addItemAt(point, 1);
				_pointHandlers.addItemAt(pointHandler, 1);
			}
			else
			{
				_points.addItemAt(point, _dividedLinkIndex + 1);
				_pointHandlers.addItemAt(pointHandler, _dividedLinkIndex + 1);
			}
			
			pointHandler.x = point.x;
			pointHandler.y = point.y;
			
			return _points.getItemIndex(point);
		}
		
		/**
		 * TODO : gros refacto pour migrer les pointHandlers vers la UmlViewSolidLine.
		 * ça permettra d'alléger la UmlViewAssociation.
		 */		
		protected function createPointHandler(x:Number=0, y:Number=0):UIComponent
		{
			var pointHandler	:UIComponent	= new UIComponent();
			var matrix			:Matrix			= new Matrix();
			var px				:int			= 0;
			var py				:int			= 0;
			
			initPointHandlerListsners(pointHandler);
			
			pointHandler.doubleClickEnabled = true;
			
			with (pointHandler.graphics)
			{
				clear();
				
				matrix.createGradientBox(10, 10, UmlViewControler.toRadians(45));
				beginGradientFill
				(
					GradientType.LINEAR, 
					[0xFFFFFF, 0xDDDDDD], 
					[1, 1], [0, 255],
					matrix
				);
				drawCircle(0, 0, 4);
				endFill();
				
				lineStyle(0.1, 0xAAAAAA, 1);
				drawCircle(0, 0, 4);
			}
			
			return pointHandler;
		}
		
		protected function onPointHandlerMouseDown(e:MouseEvent):void
		{
			_movedPointHandler = e.currentTarget as UIComponent;
			_movedPointHandler.startDrag();
			
			Application.application.addEventListener(MouseEvent.MOUSE_MOVE,	onPointHandlerMouseMove);
			Application.application.addEventListener(MouseEvent.MOUSE_UP,	onPointHandlerMouseUp);
			
			_movedPointHandler.x = mouseX;
			_movedPointHandler.y = mouseY;
			
			_movedPointHandlerPoint = new Point(_movedPointHandler.x, _movedPointHandler.y);
			
			if (_movedPointHandlerPoint.x != 0 && _movedPointHandlerPoint.y != 0)
			{
				updatePointAt
				(
					_movedPointHandlerPoint.x, 
					_movedPointHandlerPoint.y, 
					_pointHandlers.getItemIndex(_movedPointHandler)
				);
				
				update();
			}
			
			e.stopPropagation();
		}
		
		protected function onPointHandlerMouseMove(e:MouseEvent):void
		{
			var movedPointHandlerIndex:int = -1;
			
			_movedPointHandlerPoint.x = _movedPointHandler.x;
			_movedPointHandlerPoint.y = _movedPointHandler.y;
			
			movedPointHandlerIndex = _pointHandlers.getItemIndex(_movedPointHandler);
			
			
			if (_movedPointHandlerPoint.x != 0 && 
				_movedPointHandlerPoint.y != 0 && 
				movedPointHandlerIndex > 0 && 
				movedPointHandlerIndex < _pointHandlers.length - 1)
			{
				updatePointAt
				(
					_movedPointHandlerPoint.x, 
					_movedPointHandlerPoint.y, 
					_pointHandlers.getItemIndex(_movedPointHandler)
				);
				
				update();
			}
			
			e.updateAfterEvent();
		}
		
		protected function onPointHandlerMouseUp(e:MouseEvent):void
		{
			_movedPointHandler.stopDrag();
			
			Application.application.removeEventListener(MouseEvent.MOUSE_MOVE,	onPointHandlerMouseMove);
			Application.application.removeEventListener(MouseEvent.MOUSE_UP,	onPointHandlerMouseUp);
			
			_movedPointHandlerPoint.x = _movedPointHandler.x;
			_movedPointHandlerPoint.y = _movedPointHandler.y;
			
			if (_movedPointHandlerPoint.x != 0 && _movedPointHandlerPoint.y != 0)
			{
				updatePointAt
				(
					_movedPointHandlerPoint.x, 
					_movedPointHandlerPoint.y, 
					_pointHandlers.getItemIndex(_movedPointHandler)
				);
				
				update();
			}
			
			_movedPointHandler = null;
		}
		
		protected function isSelected():Boolean
		{
			return _isSelected;
		}
		
		protected function onPointHandlerMouseOver(e:MouseEvent):void
		{
			if (!isSelected())
			{
				var targetPointHandler:UIComponent = e.target as UIComponent;
				tweenPointHandlerAlpha
				(
					targetPointHandler, 
					targetPointHandler.alpha, 
					1.0, 
					_pointHandlerAlphaTweeningTime
				);
			}
		}
		
		protected function onPointHandlerMouseOut(e:MouseEvent):void
		{
			if (!isSelected())
			{
				var targetPointHandler:UIComponent = e.target as UIComponent;
				tweenPointHandlerAlpha
				(
					targetPointHandler, 
					targetPointHandler.alpha, 
					0.0, 
					_pointHandlerAlphaTweeningTime
				);
			}
		}
		
		protected function onPointHandlerDoubleClick(e:MouseEvent):void
		{
			update();
			removePointHandlerAt(_pointHandlers.getItemIndex(e.target));
		}
		
		protected function updatePointAt(x:Number, y:Number, index:int):void
		{
			if (index < 0 || index >= _points.length)
			{
				return;
			}
			
			_points.setItemAt(new Point(x, y), index);
			draw();
		}
		
		protected function updatePointHandlerPosition(point:Point, index:int):void
		{
			var pointHandler:UIComponent = null;
			
			if (index < 0 || index >= _pointHandlers.length)
			{
				return;
			}
			
			pointHandler = _pointHandlers.getItemAt(index) as UIComponent;
			
			if (pointHandler != null)
			{
				pointHandler.x	= point.x;
				pointHandler.y	= point.y;
			}
		}
		
		protected function removePointAt(index:int):void
		{
			if (index >= 1 && index < _points.length - 1)
			{
				delete _points.removeItemAt(index);
				delete this.removeChild(_links.removeItemAt(0) as Sprite);
				delete this.removeChild(_backgrounds.removeItemAt(0) as Sprite);
				draw();
			}
		}
		
		protected function removePointHandlerAt(index:int):void
		{
			var pointHandler:UIComponent = null;
			
			if (index >= 1 && index < _pointHandlers.length - 1)
			{
				pointHandler = _pointHandlers.getItemAt(index) as UIComponent;
				
				if (pointHandler != null)
				{
					removePointHandlerListsners(pointHandler);
					_pointHandlers.removeItemAt(index);
					removePointAt(index);
					
					if (pointHandler.parent != null)
					{
						pointHandler.parent.removeChild(pointHandler);
					}
				}
			}
		}
		
		protected function removeAllPoints():void
		{
			if (_points == null)
			{
				return;
			}
			
			for (var i:int = 0; i < _points.length; i++)
			{
				delete _points.removeItemAt(i);
				
				if (_links != null		&& _backgrounds != null && 
					_links.length > 0	&& _backgrounds.length > 0)
				{
					delete this.removeChild(_links.removeItemAt(0) as Sprite);
					delete this.removeChild(_backgrounds.removeItemAt(0) as Sprite);
				}
			}
		}
		
		protected function removeAllPointHandlers():void
		{
			for (var i:int = _pointHandlers.length - 1; i >= 0; i--)
			{
				removePointHandlerAt(i);
			}
		}
		
		public function dispose():void
		{
			removeAllPoints();
			removeAllPointHandlers();
			
			if (_sides != null && _sides.length > 0)
			{
				while (_sides.length > 0)
				{
					removeSideListeners(_sides[0] as UIComponent);
					delete _sides.pop();
				}
				
				_sides = null;
			}
			
			_movedPointHandlerPoint	= null;
			
			_pointHandlers	= null;
			_points			= null;
			_links			= null;
			_backgrounds	= null;
			_arrow			= null;
		}
		
		protected function onLinkDoubleClick(event:MouseEvent):void
		{
			var dividedLink:Sprite = event.currentTarget as Sprite;
			_dividedLinkIndex = getDividedLinkIndex(dividedLink);
			addPoint(mouseX, mouseY, true);
			event.stopPropagation();
		}
		
		protected function getDividedLinkIndex(link:Sprite):int
		{
			var linkIndex		:int = _links.getItemIndex(link);
			var backgroundIndex	:int = _backgrounds.getItemIndex(link);
			
			if (linkIndex >= 0)
			{
				return linkIndex;
			}
			else
			{
				return backgroundIndex;
			}
		}
		
		protected function onBackgroundMouseOver(e:MouseEvent):void
		{
			if (parent != null && parent is UmlViewAssociation)
			{
				if (!(parent as UmlViewAssociation).isSelected())
				{
					selectLine();
				}
			}
		}
		
		protected function onBackgroundMouseOut(e:MouseEvent):void
		{
			if (parent != null && parent is UmlViewAssociation)
			{
				if (!(parent as UmlViewAssociation).isSelected())
				{
					deselectLine();
				}
			}
		}
		
		public function selectLine():void
		{
			var pointHandler:UIComponent = null;
			var i:int = 0;
			
			_isSelected = true;
			tweenLineGlowFilter(1.0);
			
			if (_pointHandlers != null && _pointHandlers.length > 0)
			{
				for (i = 0; i < _pointHandlers.length; i++)
				{
					pointHandler = _pointHandlers.getItemAt(i) as UIComponent;
					
					tweenPointHandlerAlpha
					(
						pointHandler, 
						pointHandler.alpha, 
						1.0, 
						_pointHandlerAlphaTweeningTime
					);
				}
			}
		}
		
		public function deselectLine():void
		{
			var pointHandler	:UIComponent	= null;
			var i				:int			= 0;
			
			_isSelected = false;
			tweenLineGlowFilter(0.5);
			
			if (_pointHandlers != null && _pointHandlers.length > 0)
			{
				for (i = 0; i < _pointHandlers.length; i++)
				{
					pointHandler = _pointHandlers[i] as UIComponent;
					
					tweenPointHandlerAlpha
					(
						pointHandler, 
						pointHandler.alpha, 
						0.0, 
						_pointHandlerAlphaTweeningTime
					);
				}
			}
		}
		
		/**
		 * 
		 * @param endAlpha
		 * 
		 */
		protected function tweenLineGlowFilter(endAlpha:Number):void
		{
			TweenMax.to
			(
				this, 
				1, 
				{
					glowFilter : 
					{
						color		: 0xFFFFFF, 
						alpha		: endAlpha, 
						blurX		: _lineGlowBlurX, 
						blurY		: _lineGlowBlurY, 
						strength	: _lineGlowStrength, 
						quality		: _lineGlowQuality 
					}
				}
			);
		}
		
		/**
		 * 
		 * @param pointHandler
		 * @param startAlpha
		 * @param endAlpha
		 * @param tweeningTime
		 * 
		 */
		protected function tweenPointHandlerAlpha(
									pointHandler	:UIComponent, 
									startAlpha		:Number, 
									endAlpha		:Number, 
									tweeningTime	:Number):void
		{
			pointHandler.alpha = startAlpha;
			TweenMax.to
			(
				pointHandler, 
				tweeningTime, 
				{
					alpha		: endAlpha
				}
			);
		}
		
		/**
		 * the global draw function, it draws all the links in the line.
		 */
		protected function draw():void
		{
			if (_points != null && _links != null && _points.length > 0)
			{
				for (var i:uint = 0; i < _links.length; i++)
				{
					drawLine
					(
						_links.getItemAt(i) as Sprite, 
						_points.getItemAt(i) as Point, 
						_points.getItemAt(i + 1) as Point
					);
				}
			}
		}
		
		protected function drawLine(link:Sprite, point1:Point, point2:Point):void
		{
			var background:Sprite = null;
			
			if (link != null && point1 != null && point2 != null)
			{
				with (link.graphics)
				{
					clear();
					lineStyle(_lineTickness, _lineColor);
					moveTo(point1.x, point1.y);
					lineTo(point2.x, point2.y);
				}
				
				background = _backgrounds.getItemAt(_links.getItemIndex(link)) as Sprite;
				
				if (background != null)
				{
					with (background.graphics)
					{
						clear();
						lineStyle(10, 0x000000, 1.0);
						moveTo(point1.x, point1.y);
						lineTo(point2.x, point2.y);
					}
				}
			}
		}
		
		private function getLineDistance():Number
		{
			var totalDistance	:Number	= 0;
			var distance		:Number	= 0;
			var i				:int	= 0;
			
			for (i = 0; i < _points.length - 1; i++)
			{
				distance = Point.distance
				(
					(_points[i] as Point), 
					(_points[i + 1] as Point)
				);
				
				totalDistance += distance;
			}
			
			return totalDistance;
		}
		
		public function getLineCentralPoint():Point
		{
			var centralPoint		:Point		= null;
			var totalDistance		:Number		= 0;
			var demiDistance		:Number		= 0;
			var currentDistance		:Number		= 0;
			var localDistance		:Number		= 0;
			var currentLink			:Sprite		= null;
			var i					:int		= 0;
			
			totalDistance	= getLineDistance();
			demiDistance	= totalDistance / 2;
			
			if (demiDistance != 0)
			{
				for (i = 0; i < _points.length - 1 && currentLink == null; i++)
				{
					currentDistance += Point.distance
					(
						(_points[i] as Point), 
						(_points[i + 1] as Point)
					);
					
					if (currentDistance > demiDistance)
					{
						currentLink = _links.getItemAt(i) as Sprite;
					}
				}
				
				if (currentLink != null)
				{
					localDistance	= currentDistance - demiDistance;
					centralPoint	= getPointAtDistance(currentLink, localDistance);
				}
			}
			
			return centralPoint;
		}
		
		/**
		 * Théorème de Thalès
		 * 
		 * @param link
		 * @param distance
		 * @return 
		 * 
		 */
		private function getPointAtDistance(link:Sprite, distance:Number):Point
		{
			var finalPoint	:Point	= null;
			
			var finalX		:Number	= 0;
			var finalY		:Number	= 0;
			
			var index		:int	= 0;
			
			var A			:Point	= null;
			var B			:Point	= null;
			var C			:Point	= null;
			var D			:Point	= null;
			
			index = _links.getItemIndex(link);
			
			if (index >= 0 && index < _points.length - 1)
			{
				A	= _points.getItemAt(index + 1) as Point;
				B	= _points.getItemAt(index) as Point;
				C	= new Point(B.x, A.y);
				D	= new Point(A.x, B.y);
				
				finalX = (distance * (C.x - A.x)) / Point.distance(A, B);
				finalY = (distance * (D.y - A.y)) / Point.distance(A, B);
				
				finalPoint	= new Point();
				finalPoint.x	= finalX + A.x;
				finalPoint.y	= finalY + A.y;
			}
			
			return finalPoint;
		}
		
		public function getFirstLinkDirection():uint
		{
			var link		:Sprite	= null;
			var direction	:uint	= 0;
			
			if (_links != null && _links.length > 0)
			{
				link = _links[0];
				
				if (link.width > link.height)
				{
					direction = HORIZONTAL;
				}
				else
				{
					direction = VERTICAL;
				}
			}
			
			return direction;
		}
		
		public function getLastLinkDirection():uint
		{
			var link		:Sprite	= null;
			var direction	:uint	= 0;
			
			if (_links != null && _links.length > 0)
			{
				link = _links[_links.length - 1];
				
				if (link.width > link.height)
				{
					direction = HORIZONTAL;
				}
				else
				{
					direction = VERTICAL;
				}
			}
			
			return direction;
		}
		
		public function getFirstPoint():Point
		{
			if (_points != null && _points.length > 0)
			{
				return _points.getItemAt(0) as Point;
			}
			
			return null;
		}
		public function setFirstPoint(x:Number, y:Number):void
		{
			var point:Point = new Point(x, y);
			
			//si l'ensemble des liens n'est pas créé, on le crée.
			//et on ajoute un lien.
			if (_links == null || _links.length == 0)
			{
				addLink();
			}
			
			//si l'ensemble des points n'est pas créé, on le crée, 
			//et on ajoute un point.
			if (_points == null || _points.length == 0)
			{
				addPoint(x, y);
			}
			
			if (_points != null && _points.length > 0)
			{
				_points.setItemAt(point, 0);
				updatePointHandlerPosition(point, 0);
			}
		}
		
		public function getSecondPoint():Point
		{
			if (_points != null && _points.length > 1)
			{
				return _points.getItemAt(1) as Point;
			}
			return null;
		}
		public function setSecondPoint(x:Number, y:Number):void
		{
			var point:Point = new Point(x, y);
			
			if (_points != null && _points.length > 1)
			{
				_points.setItemAt(point, 1);
				updatePointHandlerPosition(point, 1);
			}
			draw();
		}
		
		public function getBeforeLastPoint():Point
		{
			if (_points != null && _points.length > 1)
			{
				return _points.getItemAt(_points.length - 2) as Point;
			}
			return null;
		}
		public function setBeforeLastPoint(x:Number, y:Number):void
		{
			var point:Point = new Point(x, y);
			
			if (_points != null && _points.length > 1)
			{
				_points.setItemAt(point, _points.length - 2);
				updatePointHandlerPosition(point, _pointHandlers.length - 2);
			}
			//draw();
		}
		
		public function getLastPoint():Point
		{
			if (_points != null && _points.length > 0)
			{
				return _points.getItemAt(_points.length - 1) as Point;
			}
			return null;
		}
		public function setLastPoint(x:Number, y:Number):void
		{
			var point:Point = new Point(x, y);
			
			if (_points != null && _points.length == 1)
			{
				addPoint(x, y);
			}
			
			if (_points != null && _points.length > 1)
			{
				_points.setItemAt(point, _points.length - 1);
				updatePointHandlerPosition(point, _pointHandlers.length - 1);
			}
			
			draw();
		}
		
		public function getLineColor():uint
		{
			return _lineColor;
		}
		public function setLineColor(value:uint):void
		{
			_lineColor = value;
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function setLineTickness(value:Number):void
		{
			if (value < MIN_LINE_TICKNESS)	value	= MIN_LINE_TICKNESS;
			if (value > MAX_LINE_TICKNESS)	value	= MAX_LINE_TICKNESS;
			
			_lineTickness = value;
		}
		public function getLineTickness():Number
		{
			return _lineTickness;
		}
		
		public function isThereAPoint():Boolean
		{
			if (_points != null)
			{
				return _points.length > 2;
			}
			
			return false;
		}
		
	}
	
}
