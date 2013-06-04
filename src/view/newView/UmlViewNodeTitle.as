package view.newView
{
	import controler.UmlViewControler;
	
	import flash.display.GradientType;
	import flash.geom.Matrix;
	
	import mx.containers.HBox;
	import mx.controls.Image;
	import mx.controls.Label;
	import mx.core.UIComponent;
	import mx.events.ResizeEvent;

	/**
	 * 
	 * @author kamal
	 * 
	 */
	public class UmlViewNodeTitle extends UIComponent
	{
		
		/**
		 * 
		 */	
		protected var _stereotype		:Label		= null;
		protected var _content			:Label		= null;
		protected var _icon				:Image		= null;
		
		protected var _actualContent	:String		= "";
		protected var _actualStereotype	:String		= "";
		protected var _actualIconUrl	:String		= "";
		
		protected var _isContentDirty	:Boolean	= true;
		
		protected var _contentHolder	:HBox		= null;
		protected var _stereotypeHolder	:HBox		= null;
		
		protected var _fitToParentSize	:Boolean	= true;
		
		protected var _isBackgroundAllowed:Boolean	= false;
		
		
		
		/**
		 * 
		 * @param content
		 * @param iconUrl
		 * @param stereotype
		 * 
		 */
		public function UmlViewNodeTitle(	content		:String	= "Untitled", 
											iconUrl		:String	= "", 
											stereotype	:String	= "")
		{
			super();
			
			_actualContent		= content;
			_actualStereotype	= stereotype;
			
			if (iconUrl != "")
			{
				_actualIconUrl = iconUrl;
			}
			
			_contentHolder	= new HBox();
			_stereotypeHolder = new HBox();
			
			_content		= new Label();
			_stereotype		= new Label();
			_icon			= new Image();
		}
		
		
		/*******************************************************************************************
		 * 
		 * overriden functions 
		 * 
		 ******************************************************************************************/
		
		
		/**
		 * 
		 * 
		 */
		protected override function createChildren():void
		{
			super.createChildren();
			
			_content.text		= _actualContent;
			_stereotype.text	= _actualStereotype;
			
			_content.setStyle("fontWeight", "normal");
			_content.setStyle("verticalAlign", "middle"); 
			_content.setStyle("fontAntiAliasType", "advanced"); 
			_content.setStyle("fontGridFitType", "subpixel");
			_content.setStyle("fontStyle", "normal");
			_content.setStyle("fontWeight", "normal");
			
			_contentHolder.setStyle("horizontalGap", "0");
			
			_contentHolder.addChild(_icon);
			_contentHolder.addChild(_content);
			
			_stereotypeHolder.addChild(_stereotype);
			
			super.addChild(_stereotypeHolder);
			super.addChild(_contentHolder);
			
			initListeners();
		}
		
		/**
		 * 
		 * 
		 */
		protected override function measure():void
		{
			var calculatedWidth:Number = 0;
			var stereotypeHeight:Number = 0;
			var decalage:Number = 1;
			
			measuredWidth = measuredMinWidth = UmlViewElement.UML_MIN_SIZE;
			
			if (_isContentDirty)
			{
				calculatedWidth  = 	_icon.getExplicitOrMeasuredWidth() + 
									_content.getExplicitOrMeasuredWidth() + 
									UmlViewElement.HORIZONTAL_MARGIN;
				
				calculatedWidth = Math.max(calculatedWidth, _stereotype.getExplicitOrMeasuredWidth());
				measuredWidth = measuredMinWidth = calculatedWidth;
				_isContentDirty = false;
			}
			
			if (parent != null && _fitToParentSize && parent.width > 0)
			{
				measuredWidth = measuredMinWidth = parent.width;
			}
			
			if (_actualStereotype != "")
			{
				stereotypeHeight = _stereotype.getExplicitOrMeasuredHeight();
				decalage = 2;
			}
			
			measuredHeight = measuredMinHeight = stereotypeHeight + UmlViewElement.VERTICAL_MARGIN / decalage +
					Math.max(_icon.getExplicitOrMeasuredHeight(), _content.getExplicitOrMeasuredHeight());
		}
		
		/**
		 * 
		 * @param unscaledWidth
		 * @param unscaledHeight
		 * 
		 */
		protected override function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			layoutChildren(getExplicitOrMeasuredWidth(), getExplicitOrMeasuredHeight());
			if (_isBackgroundAllowed)
			{
				paint(getExplicitOrMeasuredWidth(), getExplicitOrMeasuredHeight());
			}
		}
		
		/*******************************************************************************************
		 * 
		 * regular functions 
		 * 
		 ******************************************************************************************/
		
		protected function initListeners():void
		{
			
		}
		
		/**
		 * 
		 * @param p_width
		 * @param p_height
		 * 
		 */
		protected function layoutChildren(p_width:Number, p_height:Number):void
		{
			if (_actualStereotype != "")
			{
				_stereotypeHolder.x			= p_width / 2 - _stereotype.getExplicitOrMeasuredWidth() / 2;
				_stereotypeHolder.y			= UmlViewElement.VERTICAL_MARGIN / 2;
				_stereotypeHolder.width		= _stereotype.getExplicitOrMeasuredWidth();
				_stereotypeHolder.height	= _stereotype.getExplicitOrMeasuredHeight();
			}
			
			_contentHolder.x		= p_width / 2 - _contentHolder.getExplicitOrMeasuredWidth() / 2;
			_contentHolder.y		= UmlViewElement.VERTICAL_MARGIN / 2;
			
			if (_actualStereotype != "")
			{
				_contentHolder.y	= _stereotype.y + _stereotype.getExplicitOrMeasuredHeight();
			}
			
			_contentHolder.width	= _icon.getExplicitOrMeasuredWidth() + _content.getExplicitOrMeasuredWidth();
			_contentHolder.height	= Math.max(_icon.getExplicitOrMeasuredHeight(), _content.getExplicitOrMeasuredHeight());
		}
		
		/**
		 * 
		 * @param p_width
		 * @param p_height
		 * 
		 */
		protected function paint(p_width:Number, p_height:Number):void
		{
			graphics.clear();
			var gradientMatrix:Matrix = new Matrix();
			gradientMatrix.createGradientBox
			(
				p_width, 
				p_height, 
				UmlViewControler.toRadians(90)
			);
			graphics.beginGradientFill
			(
				GradientType.LINEAR, 
				[0x333333, 0x111111], 
				[1, 1], 
				[10, 255], 
				gradientMatrix
			);
			graphics.drawRoundRect(0, 0, p_width, p_height, 2, 2);
			graphics.endFill();
			graphics.lineStyle(1, 0x444444, 1);
			graphics.drawRoundRect(0, 0, p_width, p_height, 2, 2);
		}
		
		/**
		 * 
		 * @param text
		 * 
		 */
		public function setText(text:String):void
		{
			_content.text = _actualContent = text;
			_content.validateNow();
			_isContentDirty = true;
			invalidateSize();
			invalidateDisplayList();
		}
		
		/**
		 * 
		 * @param stereotype
		 * 
		 */
		public function setStereotype(stereotype:String):void
		{
			_stereotype.text = _actualStereotype = stereotype;
			_stereotype.validateNow();
			_isContentDirty = true;
			invalidateSize();
			invalidateDisplayList();
		}
		
		public function isBackGroundAllowed():Boolean
		{
			return _isBackgroundAllowed;
		}
		public function setBackgroundAllowed(permission:Boolean):void
		{
			_isBackgroundAllowed = permission;
			invalidateDisplayList();
		}
		
		public function isFitToParentSize():Boolean
		{
			return _fitToParentSize;
		}
		public function fitToParentSize():void
		{
			_fitToParentSize = true;
			invalidateSize();
		}
		public function doNotFitToParentSize():void
		{
			_fitToParentSize = false;
			invalidateSize();
		}
		
		/*******************************************************************************************
		 * 
		 * callback functions 
		 * 
		 ******************************************************************************************/
		
	}
	
}
