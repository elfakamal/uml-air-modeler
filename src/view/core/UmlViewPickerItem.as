package view.core
{
	import controler.UmlViewControler;
	
	import flash.display.DisplayObject;
	import flash.display.GradientType;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	
	import mx.containers.Canvas;
	import mx.controls.Image;
	import mx.controls.Label;
	
	/**
	 * 
	 * @author kamal
	 * 
	 */
	public class UmlViewPickerItem extends Canvas
	{
		
		public static const DEFAULT_PICKER_ITEM_SIZE	:Number		= 18;
		
		protected var _background		:Sprite		= null;
		protected var _contentLabel		:Label		= null;
		
		protected var _icon				:Image		= null;
		
		
		protected var _type				:String		= "";
		protected var _name				:String		= "";
		protected var _actualLabel		:String		= "";
		protected var _iconUrl			:String		= "";
		
		
		protected var _relatedClass		:Class		= null;
		
		/**
		 * 
		 * @param p_label
		 * 
		 */
		public function UmlViewPickerItem(	p_label	:String="", 
											iconUrl	:String="", 
											p_name	:String="")
		{
			super();
			
			_iconUrl		= iconUrl;
			_actualLabel	= p_label;
			_name			= p_name;
			
			if (_name != "")
			{
				toolTip = _name;
			}
			
			setStyle("backgroundColor", 0x111111);
			setStyle("backgroundAlpha", 0);
		}
		
		/***********************************************************************
		 * 
		 * overriden functions 
		 * 
		 **********************************************************************/
		
		public override function addChild(child:DisplayObject):DisplayObject
		{
			return null;
		}
		
		protected override function createChildren():void
		{
			super.createChildren();
			
			_background			= new Sprite();
			_contentLabel		= new Label();
			_icon				= new Image();
			
			_contentLabel.text	= _actualLabel;
			
			_contentLabel.setStyle("color", "#FFFFFF");
			_contentLabel.setStyle("fontSize", "10");
			_contentLabel.setStyle("textAlign", "center");
			
			super.rawChildren.addChild(_background);
			super.addChild(_contentLabel);
			super.addChild(_icon);
			
			setIcon(_iconUrl);
			
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
			if( value == true )
			{
				super.enabled = value;
			}
			
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
		
		/***********************************************************************
		 * 
		 * regular functions 
		 * 
		 **********************************************************************/
		
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
			
			_icon.x		= 0;
			_icon.y		= 0;
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
		}
		
		public function setIcon(url:String):void
		{
			_iconUrl = url;
			
			if (_iconUrl != "" && _icon != null)
			{
				_icon.source = _iconUrl;
			}
		}
		
		public function set relatedClass(aClass:Class):void
		{
			_relatedClass = aClass;
		}
		public function get relatedClass():Class
		{
			return _relatedClass;
		}
		
		/***********************************************************************
		 * 
		 * callback functions 
		 * 
		 **********************************************************************/
		
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
