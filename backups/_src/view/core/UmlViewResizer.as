package view.core
{
	import controler.UmlControler;
	
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import com.greensock.TweenMax;
	import com.greensock.easing.Strong;
	
	import mx.containers.Canvas;
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	
	import view.newView.UmlViewRegularNode;
	
	/**
	 * 
	 * @author kamal
	 * 
	 */
	public class UmlViewResizer extends UIComponent
	{
		
		/**
		 * corners & sodes constants
		 */
		public static const L				:int				= 1;
		public static const T				:int				= 2;
		public static const R				:int				= 3;
		public static const B				:int				= 4;
		
		public static const LT				:int				= 5;
		public static const RT				:int				= 6;
		public static const RB				:int				= 7;
		public static const LB				:int				= 8;
		
		/**
		 * the default size of sides & corners.
		 */
		public static const SIDE_SIZE		:Number				= 5;
		
		/**
		 * the node that we are going to resize.
		 */
		protected var _relatedNode			:UmlViewRegularNode	= null;
		protected var _relatedNodeParent	:UIComponent		= null;
		
		/**
		 * necessary sides & corners for resizing the related node.
		 */
		protected var _lt					:Canvas				= null;
		protected var _rt					:Canvas				= null;
		protected var _rb					:Canvas				= null;
		protected var _lb					:Canvas				= null;
		
		protected var _l					:Canvas				= null;
		protected var _t					:Canvas				= null;
		protected var _r					:Canvas				= null;
		protected var _b					:Canvas				= null;
		
		protected var _leftTopPoint			:Point				= null;
		protected var _rightBottomPoint		:Point				= null;
		
		protected var _resizeHandleSelected	:int				= 0;
		
		protected var _ghost				:Canvas				= null;
		protected var _layoutRectangle		:Rectangle			= null;
		
		/**
		 * 
		 */
		protected var _resizerColor			:Number				= 0xAAAAAA;
		protected var _resizeTime			:Number				= .5;
		protected var _isResizerAdded		:Boolean			= false;
		
		/**
		 * 
		 * @param node
		 * 
		 */
		public function UmlViewResizer(node:UmlViewRegularNode)
		{
			_relatedNode = node;
			_relatedNode.addEventListener(FlexEvent.CREATION_COMPLETE, onRelatedNodeCreationComplete);
		}
		
		/**
		 * 
		 * @param e
		 * 
		 */
		protected function onRelatedNodeCreationComplete(e:FlexEvent):void
		{
			layoutChildren(_relatedNode.getRectangle());
		}
		
		/*******************************************************************************************
		 * 
		 * overriden functions 
		 * 
		 ******************************************************************************************/
		
		protected override function createChildren():void
		{
			super.createChildren();
			
			createSidesAndCorners();
			
			_leftTopPoint		= new Point(_lt.x, _lt.y);
			_rightBottomPoint	= new Point(_rb.x, _rb.y);
			
			_ghost				= new Canvas();
			_ghost.alpha		= .2;
			_ghost.setStyle("backgroundColor", _resizerColor);
			
			_layoutRectangle	= new Rectangle(0, 0, _relatedNode.width, _relatedNode.height);
			
			if (_relatedNode.parent != null)
			{
				_relatedNodeParent = _relatedNode.parent as UIComponent;
			}
		}
		
		protected override function measure():void
		{
			super.measure();
		}
		
		protected override function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
		}
		
		/*******************************************************************************************
		 * 
		 * regular functions 
		 * 
		 ******************************************************************************************/
		
		private function createSidesAndCorners():void
		{
			_lt			= new Canvas();
			_rt			= new Canvas();
			_rb			= new Canvas();
			_lb			= new Canvas();
			
			_l			= new Canvas();
			_t			= new Canvas();
			_r			= new Canvas();
			_b			= new Canvas();
			
			initSide(_lt);
			initSide(_rt);
			initSide(_rb);
			initSide(_lb);
			
			initSide(_l);
			initSide(_r);
			initSide(_t);
			initSide(_b);
		}
		
		private function initSide(_side:Canvas):void
		{
			_side.width			= SIDE_SIZE;
			_side.height		= SIDE_SIZE;
			_side.buttonMode	= true;
			_side.useHandCursor	= true;
			_side.setStyle("backgroundColor", _resizerColor);
			_side.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			addChild(_side);
		}
		
		//////////////////////////////////////////////////////////////////////////////////////////////
		
		protected function onMouseDown(e:MouseEvent):void
		{
			UmlControler.getInstance().getSelectedDiagram().addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			
			_leftTopPoint		= new Point(_relatedNode.x, _relatedNode.y);
			_rightBottomPoint	= new Point(_relatedNode.x + _relatedNode.width, _relatedNode.y + _relatedNode.height);
			
			switch(e.target)
			{
                case _lt:
                    _resizeHandleSelected = LT;
                    break;
                case _rt:
                    _resizeHandleSelected = RT;
                    break;
                case _lb:
                    _resizeHandleSelected = LB;
                    break;
                case _rb:
                    _resizeHandleSelected = RB;
                    break;    
                case _t:
                    _resizeHandleSelected = T;
                    break;
                case _b:
                    _resizeHandleSelected = B;
                    break;
                case _l:
                    _resizeHandleSelected = L;
                    break;
                case _r:
                    _resizeHandleSelected = R;
                    break;
            }
            
			if (!contains(_ghost))
			{
				addChild(_ghost);
			}
			
			TweenMax.to
			(
				_ghost, 
				1, 
				{
					alpha	: .2 
				}
			);
			
			UmlControler.getInstance().getSelectedDiagram().addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			
			e.stopPropagation();
		}
		
		protected function onMouseMove(e:MouseEvent):void
		{
			var relatedNodeMouseX:Number = _relatedNode.parent.mouseX;
			var relatedNodeMouseY:Number = _relatedNode.parent.mouseY;
			
			var relatedNodeMousePoint:Point = new Point(relatedNodeMouseX, relatedNodeMouseY);
			
			var relatedNodePosition:Point = new Point(_relatedNode.x, _relatedNode.y);
			
			var newX			:Number = 0;
			var newY			:Number = 0;
			var newWidth		:Number = 0;
			var newHeight		:Number = 0;
			
			// il faut utiliser _relatedNode.parent.localToGlobal(new Point(relatedNodeMouseX, relatedNodeMouseY))
			// pour avoir les coordonnées globales de tous les sides & corners, 
			// comme ça on saura comment gérer les coordonnées du _relatedNode.
			
			switch(_resizeHandleSelected)
			{
				case L:
					
					newWidth		= _rightBottomPoint.x - relatedNodeMousePoint.x;
					newHeight		= _relatedNode.height;
					
					newX			= relatedNodeMousePoint.x;
					newY			= relatedNodePosition.y; //_relatedNode.y;
					
					break;
				case T:
					
					newWidth		= _relatedNode.width;
					newHeight		= _rightBottomPoint.y - relatedNodeMousePoint.y;
					
					newX			= relatedNodePosition.x; //_relatedNode.x;
					newY			= relatedNodeMousePoint.y;
					
					break;
				case R:
					
					newWidth		= relatedNodeMousePoint.x - _leftTopPoint.x;
					newHeight		= _relatedNode.height;
					
					newX			= _leftTopPoint.x;
					newY			= relatedNodePosition.y;//_relatedNode.y;
					
					break;
				case B:
					
					newWidth		= _relatedNode.width;
					newHeight		= relatedNodeMousePoint.y - _leftTopPoint.y;
					
					newX			= relatedNodePosition.x;//_relatedNode.x;
					newY			= _leftTopPoint.y;
					
					break;
				case LT:
					
					newWidth		= _rightBottomPoint.x - relatedNodeMousePoint.x;
					newHeight		= _rightBottomPoint.y - relatedNodeMousePoint.y;
					
					newX			= relatedNodeMousePoint.x;
					newY			= relatedNodeMousePoint.y;
					
					break;
				case RT:
					
					newWidth		= relatedNodeMousePoint.x - _leftTopPoint.x;
					newHeight		= _rightBottomPoint.y - relatedNodeMousePoint.y;
					
					newX			= _leftTopPoint.x;
					newY			= relatedNodeMousePoint.y;
					
					break;
				case RB:
					
					newWidth		= relatedNodeMousePoint.x - _leftTopPoint.x;
					newHeight		= relatedNodeMousePoint.y - _leftTopPoint.y;
					
					newX			= _leftTopPoint.x;
					newY			= _leftTopPoint.y;
					
					break;
				case LB:
					
					newWidth		= _rightBottomPoint.x - relatedNodeMousePoint.x;
					newHeight		= relatedNodeMousePoint.y - _leftTopPoint.y;
					
					newX			= relatedNodeMousePoint.x;
					newY			= _leftTopPoint.y;
					
					break;
			}
			
			if(newWidth < 0) {
                newX = newX + newWidth;
                newWidth *= -1;
            }
            
            if(newHeight < 0) {
                newY = newY + newHeight;
                newHeight *= -1;
            }
            
			_layoutRectangle.x			= newX - relatedNodePosition.x;
			_layoutRectangle.y			= newY - relatedNodePosition.y;
			_layoutRectangle.width		= newWidth;
			_layoutRectangle.height		= newHeight;
			
			layoutChildren(_layoutRectangle);
			
			e.updateAfterEvent();
		}
		
		protected function onMouseUp(e:MouseEvent):void
		{
			UmlControler.getInstance().getSelectedDiagram().removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			UmlControler.getInstance().getSelectedDiagram().removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			
			resizeRelatedNode();
		}
		
		//////////////////////////////////////////////////////////////////////////////////////////////
		
		protected function resizeRelatedNode():void
		{
			hideResizer();
			
			var finalRectangle:Rectangle = null;
			finalRectangle = new Rectangle
			(
				_relatedNode.x + _ghost.x, 
				_relatedNode.y + _ghost.y, 
				_ghost.width, 
				_ghost.height
			);
			
			TweenMax.to
			(
				_relatedNode, 
				_resizeTime, 
				{
					x				: finalRectangle.x, 
					y				: finalRectangle.y, 
					width			: finalRectangle.width, 
					height			: finalRectangle.height, 
					
					ease			: Strong.easeOut, 
					onUpdate		: function ():void
					{
						layoutChildren(_relatedNode.getRectangle())
						
						_ghost.x		= 0;
						_ghost.y		= 0;
						_ghost.width	= _relatedNode.width;
						_ghost.height	= _relatedNode.height;
					}, 
					onComplete		: function ():void
					{
						if (contains(_ghost))
						{
							removeChild(_ghost);
						}
						if (_relatedNode.isSelected())
						{
							showResizer();
						}
					}
				}
			);
			
			TweenMax.to
			(
				this, 
				_resizeTime, 
				{
					x		: 0, 
					y		: 0, 
					
					ease	: Strong.easeOut
				}
			);
			
			TweenMax.to
			(
				_ghost, 
				_resizeTime, 
				{
					alpha		: 0, 
					ease		: Strong.easeOut
				}
			);
		}
		
		//////////////////////////////////////////////////////////////////////////////////////////////
		
		private function layoutChildren(rect:Rectangle):void
		{
			_ghost.x			= rect.x;
			_ghost.y			= rect.y;
			_ghost.width		= rect.width;
			_ghost.height		= rect.height;
			
			// corners
			_lt.x = rect.x - SIDE_SIZE;
			_lt.y = rect.y - SIDE_SIZE;
			
			_rt.x = rect.x + rect.width;
			_rt.y = rect.y - SIDE_SIZE;
			
			_rb.x = rect.x + rect.width;
			_rb.y = rect.y + rect.height;
			
			_lb.x = rect.x - SIDE_SIZE;
			_lb.y = rect.y + rect.height;
			
			// sides
			_l.x = rect.x - SIDE_SIZE;
			_l.y = rect.y + (rect.height - SIDE_SIZE)/2;
			
			_t.x = rect.x + (rect.width - SIDE_SIZE)/2;
			_t.y = rect.y - SIDE_SIZE;
			
			_r.x = rect.x + rect.width;
			_r.y = rect.y + (rect.height - SIDE_SIZE)/2;
			
			_b.x = rect.x + (rect.width - SIDE_SIZE)/2;
			_b.y = rect.y + rect.height;
		}
		
		private function updatePositions(rect:Rectangle):void
		{
			_lt.move(rect.x - _lt.width/2, rect.y - _lt.height/2);
			_rt.move(rect.x + rect.width - _rt.width/2, rect.y - _lt.height/2);
			_lb.move(rect.x - _lb.width/2, rect.y + rect.height - _lt.height/2);
			_rb.move(rect.x + rect.width - _lb.width/2, rect.y + rect.height - _lt.height/2);
			
			_t.move(rect.x + rect.width/2 - _t.width/2, rect.y - _t.height/2);
			_b.move(rect.x + rect.width/2 - _b.width/2, rect.y + rect.height - _b.height/2);
			_l.move(rect.x - _l.width/2, rect.y + rect.height/2 - _l.height/2);
			_r.move(rect.x + rect.width - _r.width/2, rect.y + rect.height/2 - _r.height/2);
			
			_ghost.x			= rect.x;
			_ghost.y			= rect.y;
			_ghost.width		= rect.width;
			_ghost.height		= rect.height;
		}
		
		public function showResizer():void
		{
			if (!contains(_ghost))
			{
				layoutChildren(_relatedNode.getRectangle());
			}
			
			_lt.visible			= true;
			_rt.visible			= true;
			_rb.visible			= true;
			_lb.visible			= true;
			
			_l.visible			= true;
			_t.visible			= true;
			_r.visible			= true;
			_b.visible			= true;
		}
		
		public function hideResizer():void
		{
			_lt.visible			= false;
			_rt.visible			= false;
			_rb.visible			= false;
			_lb.visible			= false;
			
			_l.visible			= false;
			_t.visible			= false;
			_r.visible			= false;
			_b.visible			= false;
		}
		
//		public function __swapToSelector__():void
//		{
//			if (_b.parent is UmlViewDiagram_Deprecated)
//			{
//				var fromParent:UmlViewDiagram_Deprecated = _b.parent as UmlViewDiagram_Deprecated;
//				var toParent:UmlViewSelector = fromParent.getSelector();
//				
//				toParent.addChild(fromParent.removeChild(_lt));
//				toParent.addChild(fromParent.removeChild(_rt));
//				toParent.addChild(fromParent.removeChild(_rb));
//				toParent.addChild(fromParent.removeChild(_lb));
//				
//				toParent.addChild(fromParent.removeChild(_l));
//				toParent.addChild(fromParent.removeChild(_t));
//				toParent.addChild(fromParent.removeChild(_r));
//				toParent.addChild(fromParent.removeChild(_b));
//			}
//		}
//		
//		public function __swapToDiagram():void
//		{
//			if (_b.parent is UmlViewSelector)
//			{
//				var fromParent:UmlViewSelector = _b.parent as UmlViewSelector;
//				var toParent:UmlViewDiagram_Deprecated = fromParent.parent as UmlViewDiagram_Deprecated;
//				
//				toParent.addChild(fromParent.removeChild(_lt));
//				toParent.addChild(fromParent.removeChild(_rt));
//				toParent.addChild(fromParent.removeChild(_rb));
//				toParent.addChild(fromParent.removeChild(_lb));
//				
//				toParent.addChild(fromParent.removeChild(_l));
//				toParent.addChild(fromParent.removeChild(_t));
//				toParent.addChild(fromParent.removeChild(_r));
//				toParent.addChild(fromParent.removeChild(_b));
//				
//				if (_layoutRectangle != null)
//				{
//					_layoutRectangle.x			= _relatedNode.x;
//					_layoutRectangle.y			= _relatedNode.y;
//					_layoutRectangle.width		= _relatedNode.width;
//					_layoutRectangle.height		= _relatedNode.height;
//				}
//				else
//				{
//					_layoutRectangle = new Rectangle
//					(
//						_relatedNode.x, 
//						_relatedNode.y, 
//						_relatedNode.width, 
//						_relatedNode.height
//					);
//				}
//				layoutChildren(_layoutRectangle);
//			}
//		}
		
		public function addResizer():void
		{
			// pas besoin pour l'instant
			// mais ça servira pour l'optimisation.
			
			if (!_isResizerAdded)
			{
				addChild(_lt);
				addChild(_rt);
				addChild(_rb);
				addChild(_lb);
				
				addChild(_l);
				addChild(_t);
				addChild(_r);
				addChild(_b);
				
				if (_layoutRectangle != null)
				{
					_layoutRectangle.x			= _relatedNode.x;
					_layoutRectangle.y			= _relatedNode.y;
					_layoutRectangle.width		= _relatedNode.width;
					_layoutRectangle.height		= _relatedNode.height;
				}
				else
				{
					_layoutRectangle = new Rectangle
					(
						_relatedNode.x, 
						_relatedNode.y, 
						_relatedNode.width, 
						_relatedNode.height
					);
				}
				
				layoutChildren(_layoutRectangle);
				
				_isResizerAdded = true;
			}
		}
		
		public function removeResizer():void
		{
			// pareil
			
			if (_isResizerAdded)
			{
				_relatedNode.parent.removeChild(_lt);
				_relatedNode.parent.removeChild(_rt);
				_relatedNode.parent.removeChild(_rb);
				_relatedNode.parent.removeChild(_lb);
				
				_relatedNode.parent.removeChild(_l);
				_relatedNode.parent.removeChild(_t);
				_relatedNode.parent.removeChild(_r);
				_relatedNode.parent.removeChild(_b);
				
				_isResizerAdded = false;
			}
		}
		
		public function destroyResizer():void
		{
			// OPTIMISATION : tout est bien qui fini bien ;)
			
			_lt				= null;
			_rt				= null;
			_rb				= null;
			_lb				= null;
			
			_l				= null;
			_t				= null;
			_r				= null;
			_b				= null;
			
			_ghost			= null;
			
			_isResizerAdded	= false;
		}
		
		public function setRelatedNodeParent(p_parent:UIComponent):void
		{
			if (_relatedNodeParent == null && p_parent != null)
			{
				_relatedNodeParent = p_parent;
			}
		}
		
	}
	
}
