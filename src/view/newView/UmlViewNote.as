package view.newView
{
	import controler.UmlViewControler;
	
	import flash.display.DisplayObject;
	import flash.display.GradientType;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	import mx.containers.Canvas;
	import mx.controls.TextArea;
	import mx.events.FlexEvent;
	
	/**
	 * 
	 * @author kamal
	 * 
	 */
	public class UmlViewNote extends UmlViewClassifier
	{
		
		public static const DEFAULT_WIDTH		:Number		= 150;
		public static const DEFAULT_HEIGHT		:Number		= 80;
		
		/**
		 * 
		 */
		protected var _holder			:Canvas		= null;
		protected var _contentText		:TextArea	= null;
		protected var _isContentDirty	:Boolean	= true;
		
		protected var _mask				:Sprite		= null;
		
		protected var _triangleSize		:Number		= 10;
		
		protected var _coin1			:Point		= null;
		protected var _coin2			:Point		= null;
		protected var _coin3			:Point		= null;
		protected var _coin4			:Point		= null;
		protected var _coin5			:Point		= null;
		
		/**
		 * 
		 * @param xml
		 * @param parentUID
		 * 
		 */
		public function UmlViewNote(modelElement:IUmlModelElement, parentUID:String)
		{
			super(modelElement,  parentUID);
			
			_isTitleAllowed	= false;
			
			_holder			= new Canvas();
			_contentText	= new TextArea();
			_mask			= new Sprite();
			
			_coin1			= new Point();
			_coin2			= new Point();
			_coin3			= new Point();
			_coin4			= new Point();
			_coin5			= new Point();
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
			return null;
		}
		
		/**
		 * 
		 * 
		 */
		protected override function createChildren():void
		{
			super.createChildren();
			
			super.addChild(_mask);
			super.addChild(_holder);
			
			_holder.addChild(_contentText);
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
			
			measuredWidth	= measuredMinWidth	= DEFAULT_WIDTH;
			measuredHeight	= measuredMinHeight	= DEFAULT_HEIGHT;
		}
		
		/**
		 * 
		 * @param unscaledWidth
		 * @param unscaledHeight
		 * 
		 */
		protected override function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			_background.cacheAsBitmap	= false;
			_background.mask			= _mask;
		}
		
		/**
		 * 
		 * @param p_width
		 * @param p_height
		 * 
		 */
		protected override function layoutChildren(p_width:Number, p_height:Number):void
		{
			super.layoutChildren(p_width, p_height);
			
			_background.x		= 0;
			_background.y		= 0;
			
			_holder.x			= 0;
			_holder.y			= 0;
			_holder.width		= p_width;
			_holder.height		= p_height;
			
			_contentText.x		= HORIZONTAL_MARGIN;
			_contentText.y		= VERTICAL_MARGIN;
			_contentText.width	= p_width - 2 * HORIZONTAL_MARGIN;
			_contentText.height	= p_height - 2 * VERTICAL_MARGIN;
		}
		
		/**
		 * 
		 * 
		 */
		protected override function initListeners():void
		{
			super.initListeners();
			
			_contentText.addEventListener(MouseEvent.MOUSE_DOWN, onContentTextMouseDown);
		}
		
		/**
		 * 
		 * @param p_width
		 * @param p_height
		 * 
		 */
		protected override function paint(p_width:Number, p_height:Number):void
		{
			super.paint(p_width, p_height);
			
			_coin1.x = _coin1.y = 0;
			_coin2.x = p_width - _triangleSize + 1;
			_coin2.y = 0;
			_coin3.x = p_width + 1;
			_coin3.y = _triangleSize;
			_coin4.x = p_width + 1;
			_coin4.y = p_height + 1;
			_coin5.x = 0;
			_coin5.y = p_height + 1;
			
			_mask.graphics.beginFill(0, 0);
			_mask.graphics.moveTo(_coin1.x, _coin1.y);
			_mask.graphics.lineTo(_coin2.x, _coin2.y);
			_mask.graphics.lineTo(_coin3.x, _coin3.y);
			_mask.graphics.lineTo(_coin4.x, _coin4.y);
			_mask.graphics.lineTo(_coin5.x, _coin5.y);
			_mask.graphics.endFill();
			
			with (_background)
			{
//				graphics.clear();
//				var gradientMatrix:Matrix = new Matrix();
//				gradientMatrix.createGradientBox
//				(
//					p_width, 
//					p_height, 
//					UmlFormsControler.toRadians(90)
//				);
//				graphics.beginGradientFill
//				(
//					GradientType.LINEAR, 
//					[0x333333, 0x111111], 
//					[1, 1], 
//					[10, 255], 
//					gradientMatrix
//				);
//				
//				graphics.drawRoundRect(0, 0, p_width, p_height, 2, 2);
//				graphics.endFill();
//				graphics.lineStyle(1, 0x444444, 1);
//				graphics.drawRoundRect(0, 0, p_width, p_height, 2, 2);
				
				graphics.beginFill(0x555555, 1);
				graphics.moveTo(_coin2.x - 1, _coin2.y);
				graphics.lineTo(_coin3.x - 1, _coin3.y);
				graphics.lineTo(_coin2.x - 1, _coin3.y);
				graphics.moveTo(_coin2.x - 1, _coin3.y);
				graphics.lineTo(_coin3.x - 1, _coin3.y);
				graphics.endFill();
			}
			
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public function setContent(value:String):void
		{
			_contentText.text = value;
		}
		
		
		/*******************************************************************************************
		 * 
		 * overriden callback functions 
		 * 
		 ******************************************************************************************/
		
		/**
		 * 
		 * @param e
		 * 
		 */
		protected override function onCreationComplete(e:FlexEvent):void
		{
			super.onCreationComplete(e);
		}
		
		
		/*******************************************************************************************
		 * 
		 * regular functions 
		 * 
		 ******************************************************************************************/
		
		
		
		/*******************************************************************************************
		 * 
		 * callback functions 
		 * 
		 ******************************************************************************************/
		
		/**
		 * 
		 * @param e
		 * 
		 */
		protected function onContentTextMouseDown(e:MouseEvent):void
		{
			e.stopPropagation();
		}
		
	}
	
}
