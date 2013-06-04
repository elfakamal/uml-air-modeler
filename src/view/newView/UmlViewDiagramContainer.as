package view.newView
{
	import controler.UmlControler;
	import controler.events.UmlEvent;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	
	import model.UmlModel;
	
	import mx.containers.Canvas;
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	
	import view.core.UmlViewDiagramSelector;
	
	/**
	 * 
	 * @author kamal
	 * 
	 */
	public class UmlViewDiagramContainer extends Canvas
	{
		
		protected var _numDiagrams			:uint						= 0;
		protected var _selectedDiagram		:UmlViewDiagram			= null;
		
		protected var _toolItemHitArea		:Sprite						= null;
		protected var _diagramSelector		:UmlViewDiagramSelector		= null;
		
		protected var __parent				:Canvas						= null;
		
		/**
		 * 
		 */
		protected var _numColumns			:uint						= 3;
		protected var _numRows				:uint						= 3;
		
		protected var distX					:Number						= 0;
		protected var distY					:Number						= 0;
		
		/**
		 * 
		 */
		protected var _horizontalMargin		:Number						= 200;
		protected var _verticalMargin		:Number						= 200;
		
		/**
		 * flags 
		 */
		protected var _isLayoutDirty			:Boolean				= true;
		protected var _isSizeDirty				:Boolean				= true;
		
		protected var _isReadyToDrag			:Boolean				= false;
		
		
		/**
		 * 
		 * 
		 */		
		public function UmlViewDiagramContainer()
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
		 * @param child
		 * @return 
		 * 
		 */
		public override function addChild(child:DisplayObject):DisplayObject
		{
			if (child is UmlViewDiagram)
			{
				//
				//
				if (_numDiagrams == _numRows * _numColumns)
				{
					return null;
				}
				else
				{
					//
					//
					_numDiagrams++;
					
					// ici on peut mettre le flags _isLayoutDirty à true, 
					// et on n'a pas besoin d'appeller invalidateDisplayList() 
					// parce que flex le fait au niveau de la classe Container.
					_isLayoutDirty		= true;
					//_selectedDiagram	= child as UmlViewDiagram2;
					
					return super.addChild(child);
				}
			}
			else if (child is UmlViewDiagramSelector)
			{
				//
				//
				//
				return super.addChild(child);
			}
			return null;
		}
		
		/**
		 * 
		 * 
		 */
		protected override function createChildren():void
		{
			super.createChildren();
			
			_diagramSelector				= new UmlViewDiagramSelector();
			_toolItemHitArea				= new Sprite();
			_toolItemHitArea.mouseEnabled	= false;
			
			rawChildren.addChild(_diagramSelector);
			rawChildren.addChild(_toolItemHitArea);
		}
		
		/**
		 * 
		 * 
		 */
		protected override function measure():void
		{
			if (_numDiagrams > 0)
			{
				if (_isSizeDirty)
				{
					var computedMaxWidth	:Number		= 0;
					var computedMaxHeight	:Number		= 0;
					var maxCols				:uint		= 0;
					var maxRows				:uint		= 0;
					
					for (var i:uint = 0; i < numChildren; i++)
					{
						var child:UIComponent = getChildAt(i) as UIComponent;
						
						computedMaxWidth	= Math.max(computedMaxWidth, child.getExplicitOrMeasuredWidth());
						computedMaxHeight	= Math.max(computedMaxHeight, child.getExplicitOrMeasuredHeight());
						
						maxCols				= Math.max(maxCols, i % _numColumns);
						maxRows				= Math.max(maxRows, i / _numRows);
					}
					
					if (maxCols < _numColumns)	maxCols++;
					if (maxRows < _numRows)		maxRows++;
					
					var finalWidth		:Number = computedMaxWidth * maxCols + _horizontalMargin * (maxCols + 1);
					var finalHeight		:Number = computedMaxHeight * maxRows + _verticalMargin * (maxRows + 1);
					
					measuredWidth	= measuredMinWidth	= finalWidth;
					measuredHeight	= measuredMinHeight	= finalHeight;
					
					_isSizeDirty	= false;
				}
			}
			else if (parent != null)
			{
				measuredWidth	= measuredMinWidth	= parent.width;
				measuredHeight	= measuredMinHeight	= parent.height;
			}
		}
		
		/**
		 * 
		 * 
		 * @param unscaledWidth
		 * @param unscaledHeight
		 * 
		 */
		protected override function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			if (_isLayoutDirty)
			{
				layoutChildren(unscaledWidth, unscaledHeight);
				_isLayoutDirty = false;
			}
			
			paintBackground(unscaledWidth, unscaledHeight);
		}
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected override function keyDownHandler(event:KeyboardEvent):void
		{
			super.keyDownHandler(event);
			//UmlControler.getInstance().handleKeyboardEvent(event);
		}
		
		/*******************************************************************************************
		 * 
		 * regular functions
		 * 
		 ******************************************************************************************/
		
		/**
		 * 
		 * @param diagram
		 * 
		 */
		public function addDiagram(diagram:UmlViewDiagram):void
		{
			addChild(diagram);
			
			_isLayoutDirty = true;
			_isSizeDirty = true;
			
			invalidateDisplayList();
			
			diagram.addEventListener(UmlEvent.ELEMENT_SELECTED, onDiagramSelected);
		}
		
		
		/**
		 * 
		 * @param p_width
		 * @param p_height
		 * 
		 */		
		protected function layoutChildren(p_width:Number, p_height:Number):void
		{
			var k:uint = 0;
			for (var i:uint = 0; i < _numRows; i++)
			{
				for (var j:uint = 0; j < _numColumns && k < numChildren; j++)
				{
					var child:UIComponent = getChildAt(k) as UIComponent;
					if (child is UmlViewDiagram)
					{
						child.x = j * child.width + (j + 1) * _horizontalMargin;
						child.y = i * child.height + (i + 1) * _verticalMargin;
					}
					k++;
				}
			}
		}
		
		/**
		 * 
		 * 
		 */
		protected function initListeners():void
		{
			addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			
			addEventListener(MouseEvent.MOUSE_OVER,		onMouseOver);
			addEventListener(MouseEvent.MOUSE_OUT,		onMouseOut);
			addEventListener(MouseEvent.MOUSE_DOWN,		onMouseDown);
			addEventListener(MouseEvent.MOUSE_MOVE,		onMouseMove);
			addEventListener(MouseEvent.MOUSE_UP,		onMouseUp);
			
			
		}
		
		/**
		 * 
		 * @param p_width
		 * @param p_height
		 * 
		 */
		protected function paintBackground(p_width:Number, p_height:Number):void
		{
			graphics.clear();
			graphics.beginFill(0x333333, 1);
			graphics.drawRect(0, 0, p_width, p_height);
			graphics.endFill();
		}
		
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function getSelectedDiagram():UmlViewDiagram
		{
			return _selectedDiagram;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function getToolItemhitArea():Sprite
		{
			return _toolItemHitArea;
		}
		
		/*******************************************************************************************
		 * 
		 * callback functions
		 * 
		 ******************************************************************************************/
		
		protected function onCreationComplete(e:FlexEvent):void
		{
			_toolItemHitArea.graphics.beginFill(0x33FFFF, .1);
			_toolItemHitArea.graphics.drawRect(0, 0, 100, 100);
			_toolItemHitArea.graphics.endFill();
		}
		
		protected function onDiagramSelected(e:UmlEvent):void
		{
			if (e.getSelectedElement() is UmlViewDiagram)
			{
				var diagram:UmlViewDiagram = e.getSelectedElement() as UmlViewDiagram;
				_selectedDiagram = diagram;
				_diagramSelector.selectDiagram(diagram);
			}
		}
		
		/**
		 * 
		 * @param e
		 * 
		 */		
		protected function onMouseOver(e:MouseEvent):void
		{
//			if (e.target is UmlViewDiagramContainer)
//			{
//				buttonMode = useHandCursor = _isReadyToDrag = true;
//			}
//			else
//			{
//				onMouseOut(e);
//			}
		}
		
		protected function onMouseOut(e:MouseEvent):void
		{
			//buttonMode = useHandCursor = _isReadyToDrag = false;
		}
		
		/**
		 * 
		 * @param e
		 * 
		 */
		protected function onMouseDown(e:MouseEvent):void
		{
			__parent = parent as Canvas;
		
			buttonMode = useHandCursor = _isReadyToDrag = true;
			
			distX = __parent.mouseX;
			distY = __parent.mouseY;
		}
		
		/**
		 * 
		 * @param e
		 * 
		 */
		protected function onMouseMove(e:MouseEvent):void
		{
			if (_isReadyToDrag)
			{
				distX = __parent.mouseX - distX;
				distY = __parent.mouseY - distY;
				
				if (__parent.horizontalScrollBar != null)
				{
					__parent.horizontalScrollPosition -= distX;
				}
				
				if (__parent.verticalScrollBar != null)
				{
					__parent.verticalScrollPosition -= distY;
				}
				
				distX = __parent.mouseX;
				distY = __parent.mouseY;
				
				e.updateAfterEvent();
			}
		}
		
		/**
		 * 
		 * @param e
		 * 
		 */
		protected function onMouseUp(e:MouseEvent):void
		{
			buttonMode = useHandCursor = _isReadyToDrag = false;
		}
		
	}
	
}
