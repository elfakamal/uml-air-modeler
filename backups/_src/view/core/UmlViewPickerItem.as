package view.core
{
	import controler.UmlViewControler;
	import controler.events.UmlViewEvent;
	
	import flash.display.DisplayObject;
	import flash.display.GradientType;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	
	import mx.controls.Label;
	import mx.core.UIComponent;
	
	/**
	 * 
	 * @author kamal
	 * 
	 */
	public class UmlViewPickerItem extends UIComponent
	{
		
		public static const DEFAULT_PICKER_ITEM_SIZE	:Number		= 18;
		
		protected var _background		:Sprite		= null;
		protected var _mask				:Sprite		= null;
		protected var _contentLabel		:Label		= null;
		
		protected var _type				:String		= "";
		protected var _actualLabel		:String		= "";
		
		
		/**
		 * 
		 * @param p_label
		 * 
		 */
		public function UmlViewPickerItem(label:String="")
		{
			super();
			
			_actualLabel = label;
			
//			_type = p_type;
//			
//			switch (true)
//			{
//				case (p_type == ADD) :
//					_actualLabel = "+";
//				break;
//				case (p_type == EDIT) :
//					_actualLabel = "..";
//				break;
//				case (p_type == DELETE) :
//					_actualLabel = "-";
//				break;
//				default : 
//					_actualLabel = "";
//			}
		}
		
		/*******************************************************************************************
		 * 
		 * overriden functions 
		 * 
		 ******************************************************************************************/
		
		public override function addChild(child:DisplayObject):DisplayObject
		{
			return null;
		}
		
		protected override function createChildren():void
		{
			super.createChildren();
			
			_background			= new Sprite();
			_mask				= new Sprite();
			_contentLabel		= new Label();
			_contentLabel.text	= _actualLabel;
			
			_contentLabel.setStyle("color", "#FFFFFF");
			_contentLabel.setStyle("fontSize", "10");
			_contentLabel.setStyle("textAlign", "center");
			
//			_contentLabel.cacheAsBitmap		= false;
//			_contentLabel.mask				= _mask;
			
			super.addChild(_background);
			super.addChild(_contentLabel);
			super.addChild(_mask);
			
			initListeners();
		}
		
		/**
		 * 
		 * 
		 */
		protected override function measure():void
		{
			super.measure();
			
			measuredWidth	= measuredMinWidth	= DEFAULT_PICKER_ITEM_SIZE;
			measuredHeight	= measuredMinHeight	= DEFAULT_PICKER_ITEM_SIZE;
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
			layoutChildren(unscaledWidth, unscaledHeight);
			paint(unscaledWidth, unscaledHeight);
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public override function set enabled(value:Boolean):void
		{
			super.enabled = value;
			
			if (_contentLabel != null)
			{
				if (value)
				{
					_contentLabel.setStyle("color", "#FFFFFF");
				}
				else
				{
					_contentLabel.setStyle("color", "#000000");
				}
			}
		}
		
		/*******************************************************************************************
		 * 
		 * regular functions 
		 * 
		 ******************************************************************************************/
		
		protected function initListeners():void
		{
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		}
		
		protected function layoutChildren(p_width:Number, p_height:Number):void
		{
			_background.x	= 0;
			_background.y	= 0;
			
			_contentLabel.width		= DEFAULT_PICKER_ITEM_SIZE;
			_contentLabel.height	= DEFAULT_PICKER_ITEM_SIZE;
			_contentLabel.x			= p_width / 2 - _contentLabel.width / 2;
			_contentLabel.y			= p_height / 2 - _contentLabel.height / 2;
			
			_mask.x			= 0;
			_mask.y			= 0;
		}
		
		protected function paint(p_width:Number, p_height:Number):void
		{
			var matrix:Matrix = new Matrix();
			
			with (_background.graphics)
			{
				clear();
				
				matrix.createGradientBox
				(
					DEFAULT_PICKER_ITEM_SIZE, 
					DEFAULT_PICKER_ITEM_SIZE, 
					UmlViewControler.toRadians(45)
				);
				
				beginGradientFill
				(
					GradientType.LINEAR, 
					[0x222222, 0x000000], 
					[1, 1], [0, 255],
					matrix
				);
				drawRect(0, 0, DEFAULT_PICKER_ITEM_SIZE, DEFAULT_PICKER_ITEM_SIZE);
				endFill();
			}
			
//			with (_mask.graphics)
//			{
//				clear();
//				beginFill(0, 0);
//				drawRect(0, 0, DEFAULT_PICKER_ITEM_SIZE, DEFAULT_PICKER_ITEM_SIZE);
//				endFill();
//			}
		}
		
		/*******************************************************************************************
		 * 
		 * callback functions 
		 * 
		 ******************************************************************************************/
		
		/**
		 * cette fonction dispatche l'événement indiquant qu'on a cliqué sur 
		 * un élément du picker. on stoppe la propagation de l'événement au 
		 * relatedNode pour éviter le drag & drop de celui-ci.
		 * 
		 * @param e
		 * 
		 */		
		protected function onMouseDown(e:MouseEvent):void
		{
			e.stopPropagation();
		}
		
	}
	
}
