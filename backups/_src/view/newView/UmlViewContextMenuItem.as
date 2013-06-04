package view.newView
{
	import controler.UmlViewControler;
	
	import flash.display.DisplayObject;
	import flash.display.GradientType;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	
	import mx.containers.HBox;
	import mx.controls.Image;
	import mx.controls.Label;
	import mx.core.ScrollPolicy;
	import mx.core.UIComponent;
	import mx.events.FlexEvent;

	/**
	 * 
	 * @author kamal
	 * 
	 */
	public class UmlViewContextMenuItem extends HBox
	{
		
		/**
		 * 
		 */
		public static const DEFAULT_HEIGHT		:Number		= 18;
		public static const DEFAULT_ICON_SIZE	:Number		= 18;
		public static const RIGHT_MARGIN		:Number		= 20;
		
		/**
		 * 
		 */
		private var _background			:Sprite			= null;
		private var _icon				:Image			= null;
		private var _contentLabel		:Label			= null;
		
		private var _highlightColors	:Array			= [0x666666, 0x444444];
		private var _highlightAlpha		:Number			= 0.0;
		
		private var _actualContent		:String			= "";
		private var _actualIconUrl		:String			= "";
		
		private var _isSubMenu			:Boolean		= false;
		private var _subMenuItems		:Array			= null;
		
		/**
		 * 
		 * @param p_label
		 * @param iconUrl
		 * 
		 */
		public function UmlViewContextMenuItem(
									p_label			:String		= "Unlabeled", 
									p_iconUrl		:String		= "" )
		{
			super();
			
			_actualContent	= p_label;
			_actualIconUrl	= p_iconUrl;
			
			setStyle("horizontalGap", 0);
			horizontalScrollPolicy	= ScrollPolicy.OFF;
			verticalScrollPolicy	= ScrollPolicy.OFF;
		}
		
		protected override function createChildren():void
		{
			super.createChildren();
			
			_background		= new Sprite();
			_icon			= new Image();
			_contentLabel	= new Label();
			
			_contentLabel.text = _actualContent;
			
			if (_actualIconUrl != "")
			{
				_icon.source = _actualIconUrl;
			}
			
			super.rawChildren.addChild(_background);
			
			super.addChild(_icon);
			super.addChild(_contentLabel);
			_contentLabel.validateNow();
			
			initListeners();
		}
		
		public override function addChild(child:DisplayObject):DisplayObject
		{
			return null;
		}
		
		protected override function measure():void
		{
			super.measure();
			
			measuredWidth	= measuredMinWidth	= _contentLabel.width + 
												DEFAULT_ICON_SIZE + RIGHT_MARGIN;
			
			measuredHeight	= measuredMinHeight	= DEFAULT_HEIGHT;
		}
		
		protected override function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			layoutChildren(unscaledWidth, unscaledHeight);
			paint(unscaledWidth, unscaledHeight);
		}
		
		/***********************************************************************
		 * 
		 * regular functions 
		 * 
		 **********************************************************************/
		
		private function initListeners():void
		{
			addEventListener(FlexEvent.CREATION_COMPLETE,	onCreationComplete);
			addEventListener(MouseEvent.MOUSE_DOWN,			onMouseDown);
			addEventListener(MouseEvent.MOUSE_OVER,			onMouseOver);
			addEventListener(MouseEvent.MOUSE_OUT,			onMouseOut);
		}
		
		private function layoutChildren(p_width:Number, p_height:Number):void
		{
			_background.x			= 0;
			_background.y			= 0;
			_background.width		= p_width;
			_background.height		= p_height;
			
			_icon.width				= DEFAULT_ICON_SIZE;
			_icon.height			= DEFAULT_ICON_SIZE;
			
			//ne pas faire ça!!!!!!!
			//_contentLabel.width		= p_width - _icon.width;
			_contentLabel.height	= DEFAULT_HEIGHT;
		}
		
		private function paint(p_width:Number, p_height:Number):void
		{
			var matrix:Matrix = new Matrix();
			
			with (_background.graphics)
			{
				clear();
				
				matrix.createGradientBox
				(
					p_width, 
					p_height, 
					UmlViewControler.toRadians(90)
				);
				
				beginGradientFill
				(
					GradientType.LINEAR, 
					_highlightColors, 
					[_highlightAlpha, _highlightAlpha], 
					[0, 255], 
					matrix
				);
				drawRect(0, 0, p_width, p_height);
				endFill();
			}
		}
		
		public function setSubMenu(items:Array):void
		{
			
		}
		
		public function getContent():String
		{
			return _actualContent;
		}
		
		public function isSubMenu():Boolean
		{
			return _isSubMenu;
		}
		
		public function getSubMenuItems():Array
		{
			return _subMenuItems;
		}
		
		/***********************************************************************
		 * 
		 * callback functions 
		 * 
		 **********************************************************************/
		
		private function onCreationComplete(e:FlexEvent):void
		{
			this.percentWidth = 100;
		}
		
		private function onMouseDown(e:MouseEvent):void
		{
			e.stopPropagation();
		}
		
		private function onMouseOver(e:MouseEvent):void
		{
			_highlightAlpha = 0.8;
			invalidateDisplayList();
		}
		
		private function onMouseOut(e:MouseEvent):void
		{
			_highlightAlpha = 0.0;
			invalidateDisplayList();
		}
		
	}
	
}
