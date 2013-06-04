package view.newView
{
	import controler.UmlViewControler;
	import controler.events.UmlEvent;
	
	import flash.display.DisplayObject;
	import flash.display.GradientType;
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	
	import model.IUmlModelElement;
	import model.IUmlModelFeature;
	import model.IUmlModelTypedElement;
	import model.UmlModel;
	
	import mx.containers.HBox;
	import mx.controls.Label;
	import mx.core.ScrollPolicy;
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	import mx.events.ResizeEvent;
	
	import view.core.UmlAlert;
	import view.panels.UmlViewFieldForm;
	
	/**
	 * 
	 * @author kamal
	 * 
	 */
	public class UmlViewField extends UmlViewElement
	{
		
		/**
		 * 
		 */
		public static const PUBLIC		:uint = 1;
		public static const PROTECTED	:uint = 2;
		public static const PACKAGE		:uint = 3;
		public static const PRIVATE		:uint = 4;
		
		/**
		 * 
		 */
		public static const PUBLIC_CHILD_ICON_COLOR		:Array = [0x00CC00, 0x005500];
		public static const PROTECTED_CHILD_ICON_COLOR	:Array = [0xCCCC00, 0x555500];
		public static const PACKAGE_CHILD_ICON_COLOR	:Array = [0xCC00CC, 0x550055];
		public static const PRIVATE_CHILD_ICON_COLOR	:Array = [0xCC0000, 0x550000];
		
		public static const DEFAULT_FIELD_HEIGHT		:Number = 18;
		
		public static const ICON_WIDTH	:Number	= DEFAULT_FIELD_HEIGHT / 2;
		public static const ICON_HEIGHT	:Number	= DEFAULT_FIELD_HEIGHT / 2;
		
		/**
		 * 
		 */
		protected var _backgroundColor	:Number			= 0xFFFFFF;
		protected var _backgroundAlpha	:Number			= 0.0;
		
		/**
		 * 
		 */
		protected var _holder			:HBox			= null;
		protected var _icon				:Sprite			= null;
		protected var _nameLabel		:Label			= null;
		
		protected var _isContentDirty	:Boolean		= false;
		protected var _actualVisibility	:uint			= PUBLIC;
		protected var _actualIconColor	:Array			= null;
		
		protected var _fitToParentSize	:Boolean		= true;
		protected var _fitToContentSize	:Boolean		= false;
		
		protected var _isIconDirty		:Boolean		= true;
		
		protected var _isIconAllowed	:Boolean		= true;
		
		/**
		 * 
		 * @param xml
		 * @param parentUID
		 * 
		 */
		public function UmlViewField(modelElement:IUmlModelElement, parentUID:String)
		{
			super(modelElement, parentUID);
			
			_actualIconColor						= PUBLIC_CHILD_ICON_COLOR;
			_isStopMouseEventPropagationAllowed		= true;
			_isSuperDragAllowed						= false;
		}
		
		/*******************************************************************************************
		 * 
		 * overriden functions 
		 * 
		 ******************************************************************************************/
		
		protected override function initListeners():void
		{
			super.initListeners();
			
			if (parent != null)
			{
				(parent as UIComponent).addEventListener(ResizeEvent.RESIZE, onParentResize);
			}
		}
		
		protected override function createChildren():void
		{
			super.createChildren();
			
			_holder				= new HBox();
			_nameLabel			= new Label();
			
			if (_isIconAllowed)
			{
				_icon = new Sprite();
				super.addChild(_icon);
			}
			
			super.addChild(_holder);
			
			_holder.addChild(_nameLabel);
			_holder.horizontalScrollPolicy	= ScrollPolicy.OFF;
			_holder.verticalScrollPolicy	= ScrollPolicy.OFF;
			
			updateContent();
		}
		
		public override function addChild(child:DisplayObject):DisplayObject
		{
			return null;
		}
		
		protected override function measure():void
		{
			super.measure();
			
			if (parent != null && _fitToParentSize)
			{
				measuredWidth	= measuredMinWidth	= parent.width;
			}
			else if (parent != null && _fitToContentSize)
			{
				if (_holder != null && _nameLabel != null)
				{
					measuredWidth	= measuredMinWidth	= _holder.x + _nameLabel.width;
				}
				else
				{
					measuredWidth	= measuredMinWidth	= UmlViewElement.UML_MIN_SIZE;
				}
			}
			else
			{
				measuredWidth	= measuredMinWidth	= UmlViewElement.UML_MIN_SIZE;
			}
			
			measuredHeight	= measuredMinHeight	= DEFAULT_FIELD_HEIGHT;
		}
		
		protected override function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			if (_isIconAllowed && _isIconDirty)
			{
				paintIcon(unscaledHeight);
				_isIconDirty = false;
			}
		}
		
		protected override function layoutChildren(p_width:Number, p_height:Number):void
		{
			super.layoutChildren(p_width, p_height);
			
			if (_holder != null)
			{
				if (_icon != null && _isIconAllowed)
				{
					_icon.x			= ICON_WIDTH / 2;
					_icon.y			= ICON_HEIGHT / 2;
					
					_holder.x		= _icon.x + _icon.width + ICON_WIDTH / 2;
				}
				else
				{
					_holder.x		= 0;
				}
				
				_holder.y		= 0;
				_holder.width	= p_width - _holder.x;
				_holder.height	= p_height;
			}
		}
		
		protected override function paint(p_width:Number, p_height:Number):void
		{
			super.paint(p_width, p_height);
			
			if (_background != null)
			{
				with (_background.graphics)
				{
					clear();
					beginFill(_backgroundColor, _backgroundAlpha);
					drawRect(0, 0, p_width, p_height);
					endFill();
				}
			}
		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public override function setSelected(value:Boolean):void
		{
			super.setSelected(value);
			
			if (_isSelected)
			{
				showSelectionColor();
			}
			else
			{
				hideSelectionColor();
			}
		}
		
		/**
		 * 
		 * 
		 */
		public override function showSelectionColor():void
		{
			_backgroundAlpha = 0.1;
			_backgroundColor = 0xFFFFFF;
			invalidateDisplayList();
		}
		
		/**
		 * 
		 * 
		 */
		public override function hideSelectionColor():void
		{
			_backgroundAlpha = 0.0;
			_backgroundColor = 0x000000;
			invalidateDisplayList();
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
			
		}
		
		protected override function onMouseDown(e:MouseEvent):void
		{
			super.onMouseDown(e);
		}
		
		/*******************************************************************************************
		 * 
		 * regular functions 
		 * 
		 ******************************************************************************************/
		
		/**
		 * 
		 * 
		 */
		public override function requestEdit():void
		{
			super.requestEdit();
			
			var fieldForm:UmlViewFieldForm = new UmlViewFieldForm();
			fieldForm.addEventListener(UmlEvent.VIEW_FIELD_FORM_READY,	onViewFieldFormReady);
			fieldForm.addEventListener(UmlEvent.UML_ACTION_CANCELED,	onUmlActionCanceled);
			
			var umlAlert:UmlAlert = new UmlAlert(fieldForm);
			umlAlert.show();
			fieldForm.setFeature(this);
		}
		
		public function removeListeners():void
		{
			
		}
		
		/**
		 * 
		 * @param p_xml
		 * 
		 */
		protected override function updateContent():void
		{
			super.updateContent();
			
			if (_nameLabel != null)
			{
				_nameLabel.text = getFormattedName();
			}
			
			if (getVisibility() == "public")
			{
				setGraphicVisibility(PUBLIC);
			}
			else if (getVisibility() == "private")
			{
				setGraphicVisibility(PRIVATE);
			}
			else if (getVisibility() == "protected")
			{
				setGraphicVisibility(PROTECTED);
			}
			else if (getVisibility() == "package")
			{
				setGraphicVisibility(PACKAGE);
			}
		}
		
		/**
		 * 
		 * override in subclasses
		 */
		protected override function getFormattedName():String
		{
			return "";
		}
		
		/**
		 * 
		 * @param visibility
		 * 
		 */
		public function setGraphicVisibility(visibility:uint):void
		{
			if (visibility > 0 && visibility <= 4)
			{
				_actualVisibility = visibility;
				
				switch (visibility)
				{
					case PUBLIC :
						setPublic();
					break;
					case PROTECTED :
						setProtected();
					break;
					case PACKAGE :
						setPackage();
					break;
					case PRIVATE :
						setPrivate();
					break;
				}
			}
		}
		
		public function setPublic():void
		{
			_actualVisibility	= PUBLIC;
			_actualIconColor	= PUBLIC_CHILD_ICON_COLOR;
			_isIconDirty		= true;
			invalidateDisplayList();
		}
		
		public function setProtected():void
		{
			_actualVisibility	= PROTECTED;
			_actualIconColor	= PROTECTED_CHILD_ICON_COLOR
			_isIconDirty		= true;
			invalidateDisplayList();
		}
		
		public function setPackage():void
		{
			_actualVisibility	= PACKAGE;
			_actualIconColor	= PACKAGE_CHILD_ICON_COLOR;
			_isIconDirty		= true;
			invalidateDisplayList();
		}
		
		public function setPrivate():void
		{
			_actualVisibility	= PRIVATE;
			_actualIconColor	= PRIVATE_CHILD_ICON_COLOR;
			_isIconDirty		= true;
			invalidateDisplayList();
		}
		
		/**
		 * 
		 * @param p_height
		 * 
		 */
		protected function paintIcon(p_height:Number):void
		{
			if (_icon == null || !_isIconAllowed)
			{
				return;
			}
			
			var matrix:Matrix = new Matrix();
			
			with (_icon.graphics)
			{
				clear();
				
				matrix.createGradientBox
				(
					ICON_WIDTH, 
					ICON_HEIGHT, 
					UmlViewControler.toRadians(45)
				);
				
				beginGradientFill
				(
					GradientType.LINEAR, 
					_actualIconColor, 
					[1, 1], [0, 255],
					matrix
				);
				drawRoundRect(0, 0, ICON_WIDTH, ICON_HEIGHT, 1, 1);
				endFill();
			}
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
		
		public function getType():String
		{
			if (_modelElement is IUmlModelTypedElement)
			{
				return (_modelElement as IUmlModelTypedElement).type.toString();
			}
			
			return "";
		}
		
		public function isStatic():Boolean
		{
			var modelFeature		:IUmlModelFeature	= null;
			var isFeatureStatic		:Boolean			= false;
			
			if (modelElement is IUmlModelFeature)
			{
				modelFeature	= modelElement as IUmlModelFeature;
				isFeatureStatic	= modelFeature.isStatic;
			}
			
			return isFeatureStatic;
		}
		
		/*******************************************************************************************
		 * 
		 * business callback functions 
		 * 
		 ******************************************************************************************/
		
		protected function onUmlActionCanceled(e:UmlEvent):void
		{
			UmlModel.getInstance().removeEventListener(UmlEvent.ELEMENT_EDITED, onEdited);
		}
		
		protected function onViewFieldFormReady(e:UmlEvent):void
		{
			
		}
		
		/*******************************************************************************************
		 * 
		 * callback functions 
		 * 
		 ******************************************************************************************/
		
		protected function onParentResize(e:ResizeEvent):void
		{
			if (parent != null)
			{
				this.width = parent.width;
			}
		}
		
	}
	
}
