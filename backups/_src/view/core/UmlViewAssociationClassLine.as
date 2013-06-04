package view.core
{
	
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	
	import view.newView.UmlViewElement;
	import view.newView.associations.UmlViewAssociation;
	import view.umlView.UmlViewAssociationClass;
	
	public class UmlViewAssociationClassLine extends UmlViewElement
	{
		
		/**
		 * 
		 */
		protected var _line							:UmlViewDashedLine			= null;
		
		/**
		 * 
		 */
		private var _parent							:UIComponent				= null;
		
		/**
		 * 
		 * 
		 */
		private var _relativeAssociation			:UmlViewAssociation			= null;
		
		/**
		 * 
		 * 
		 */
		private var _relativeAssociationClass		:UmlViewAssociationClass	= null;
		
		private var _isClassPressed					:Boolean					= false;
		
		
		public override function dispose():void
		{
			_line						= null;
			_parent						= null;
			_relativeAssociation		= null;
			_relativeAssociationClass	= null;
		}
		
		
		/**
		 * 
		 * 
		 */
		public function UmlViewAssociationClassLine(
									parentUID					:String,
									umlParent					:UIComponent, 
									relativeAssociation			:UmlViewAssociation, 
									relativeAssociationClass	:UmlViewAssociationClass)
		{
			super(null, parentUID);
			
			_relativeAssociationClass		= relativeAssociationClass;
			_relativeAssociation			= relativeAssociation;
			_parent							= umlParent;
			_line							= new UmlViewDashedLine();
			
			initListeners();
		}
		
		protected override function initListeners():void
		{
			addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			
			_relativeAssociationClass.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			_relativeAssociationClass.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			_relativeAssociationClass.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}
		
		/**
		 * 
		 * 
		 */
		protected override function onCreationComplete(e:FlexEvent):void
		{
			_line.setLineColor(0xFF6400);
			
			_line.setFirstPoint
			(
				_relativeAssociationClass.x + _relativeAssociationClass.width/2, 
				_relativeAssociationClass.y + _relativeAssociationClass.height/2
			);
			
			_line.setLastPoint
			(
				_relativeAssociation.getAssociationClassPoint().x, 
				_relativeAssociation.getAssociationClassPoint().y
			);
			
			addChild(_line);
			_parent.addChildAt(this, 0);
		}
		
		/**
		 * 
		 * 
		 */
		protected override function onMouseDown(e:MouseEvent):void
		{
			_isClassPressed = true;
		}
		
		/**
		 * 
		 * 
		 */
		protected override function onMouseMove(e:MouseEvent):void
		{
			if (_isClassPressed)
			{
				updateFirstSidePosition();
				e.updateAfterEvent();
			}
		}
		
		/**
		 * 
		 * 
		 */
		protected override function onMouseUp(e:MouseEvent):void
		{
			_isClassPressed = false;
		}
		
		/**
		 * 
		 * 
		 */
		protected function updateFirstSidePosition():void
		{
			// side 1
			var A1		:Point		= new Point();
			var B1		:Point		= new Point();
			var C1		:Point		= new Point();
			var D1		:Point		= new Point();
			
			// side 2
			var A2		:Point		= new Point();
			var B2		:Point		= new Point();
			var C2		:Point		= new Point();
			var D2		:Point		= new Point();
			
			// side 1
			A1.x = _relativeAssociationClass.x;
			A1.y = _relativeAssociationClass.y;
			
			B1.x = _relativeAssociationClass.x + _relativeAssociationClass.width;
			B1.y = _relativeAssociationClass.y;
			
			C1.x = _relativeAssociationClass.x + _relativeAssociationClass.width;
			C1.y = _relativeAssociationClass.y + _relativeAssociationClass.height;
			
			D1.x = _relativeAssociationClass.x;
			D1.y = _relativeAssociationClass.y + _relativeAssociationClass.height;
			
			// second point 
			var second:Point = _relativeAssociation.getAssociationClassPoint();//_line.getSecondPoint();
			A2 = B2 = C2 = D2 = second;
			
			// test the step 1 cases : 
			// A1 & C2, B1 & D2, C1 & A2, D1 & B2
			var isLeftTop			:Boolean		= A2.x <= A1.x && A2.y <= A1.y;
			var isRightTop			:Boolean		= B2.x >= B1.x && B2.y <= B1.y;
			var isRightBottom		:Boolean		= C2.x >= C1.x && C2.y >= C1.y;
			var isLeftBottom		:Boolean		= D2.x <= D1.x && D2.y >= D1.y;
			
			if (isLeftTop)
			{
				_line.setFirstPoint(A1.x, A1.y);
				_line.setSecondPoint(A2.x, A2.y);
			}
			else if (isRightTop)
			{
				_line.setFirstPoint(B1.x, B1.y);
				_line.setSecondPoint(B2.x, B2.y);
			}
			else if (isRightBottom)
			{
				_line.setFirstPoint(C1.x, C1.y);
				_line.setSecondPoint(C2.x, C2.y);
			}
			else if (isLeftBottom)
			{
				_line.setFirstPoint(D1.x, D1.y);
				_line.setSecondPoint(D2.x, D2.y);
			}
			else
			{
				var isLeft			:Boolean		= A1.x > A2.x;
				var isTop			:Boolean		= A1.y > A2.y;
				var isRight			:Boolean		= B1.x < B2.x;
				var isBottom		:Boolean		= D1.y < D2.y;
				
				if (isLeft)
				{
					_line.setFirstPoint(A1.x, A2.y);
					_line.setSecondPoint(A2.x, A2.y);
				}
				else if (isTop)
				{
					_line.setFirstPoint(A2.x, A1.y);
					_line.setSecondPoint(A2.x, A2.y);
				}
				else if (isRight)
				{
					_line.setFirstPoint(B1.x, B2.y);
					_line.setSecondPoint(A2.x, A2.y);
				}
				else if (isBottom)
				{
					_line.setFirstPoint(D2.x, D1.y);
					_line.setSecondPoint(A2.x, A2.y);
				}
				
			}
			
		}
		
		/**
		 * 
		 */
		public function refreshRender():void
		{
			updateFirstSidePosition();
		}
		
	}
	
}
