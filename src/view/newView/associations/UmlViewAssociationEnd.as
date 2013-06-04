package view.newView.associations
{
	
	import com.greensock.TweenMax;
	import com.greensock.easing.Strong;
	
	import controler.UmlControler;
	import controler.UmlSelectionControler;
	import controler.UmlValidationControler;
	import controler.enums.UmlViewBorderPosition;
	import controler.events.UmlEvent;
	import controler.events.UmlViewEvent;
	
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.ui.Keyboard;
	import flash.utils.getTimer;
	
	import model.IUmlModelElement;
	import model.IUmlModelFeature;
	import model.IUmlModelMultiplicityElement;
	import model.UmlModelValueSpecification;
	
	import mx.containers.Canvas;
	import mx.events.FlexEvent;
	
	import view.core.UmlViewEditableField;
	import view.newView.UmlViewElement;
	import view.newView.UmlViewField;
	
	/**
	 * 
	 * @author kamal
	 * 
	 */
	public class UmlViewAssociationEnd extends UmlViewElement
	{
		
		//TODO : implement the constraints fields.
		
		protected var _nameField			:UmlViewEditableField	= null;
		protected var _multiplicityField	:UmlViewEditableField	= null;
		
		protected var _position				:uint			= 1;
		protected var _margin				:Number			= 5;
		
		protected var _backgroundTemoin		:Canvas			= null;
		
		//TODO: parentAssociation
		protected var _ownerAssociation		:UmlViewAssociation = null;
		
		
		
		protected var _regExpZeroStar		:RegExp			= /0\.\.\*/;
		protected var _regExpOneOne			:RegExp			= /1\.\.1/;
		protected var _regExpOneStar		:RegExp			= /1\.\.\*/;
		protected var _regExpZeroOne		:RegExp			= /0\.\.1/;
		protected var _regExpDecimal		:RegExp			= /\d+/;
		protected var _regExpDecimalStar	:RegExp			= /\d+\.\.\*/;
		protected var _regExpDecimalDecimal	:RegExp			= /\d+\.\.\d+/;
		
		
		protected var _regExpSplit			:RegExp			= /\s*\.\.\s*/;
		
		
		
		private var _isRestrictChanged		:Boolean		= false;
		
		
		
		/**
		 * 
		 * @param p_modelElement
		 * @param p_uid
		 * 
		 */
		public function UmlViewAssociationEnd(
									p_modelElement		:IUmlModelElement, 
									p_uid				:String, 
									parentAssociation	:UmlViewAssociation)
		{
			super(p_modelElement, p_uid);
			
			_isKeyboardAllowed				= true;
			_isSuperDragAllowed				= false;
			_isClipboardOperationsAllowed	= true;
			
			_background						= null;
			
			if (parentAssociation != null)
			{
				_ownerAssociation = parentAssociation
			}
		}
		
		public override function dispose():void
		{
			super.dispose();
		}
		
		protected override function getDragRectangle():Rectangle
		{
			return null;
		}
		
		protected override function createChildren():void
		{
			createNameField();
			createMultiplicityField();
			
			super.createChildren();
			
			//createBackgroundTemoin();
			
			//remove the uml's native background.
			if (_background != null && _background.parent != null)
			{
				_background.parent.removeChild(_background);
				_background = null;
			}
		}
		
		protected function createBackgroundTemoin():void
		{
			_backgroundTemoin = new Canvas();
			_backgroundTemoin.setStyle("backgroundColor", 0xFF5500);
			_backgroundTemoin.setStyle("backgroundAlpha", 1);
			addChildAt(_backgroundTemoin, 0);
		}
		
		protected function createNameField():void
		{
			_nameField = new UmlViewEditableField(getFormattedName());
			_nameField.restrict = "[a-z,éèçàù ,A-Z,0-9]";
			_nameField.deactivate();
			addChild(_nameField);
		}
		
		protected function createMultiplicityField():void
		{
			_multiplicityField	= new UmlViewEditableField(getMultiplicity());
			_multiplicityField.restrict = "[0-9]*";
			_multiplicityField.deactivate();
			addChild(_multiplicityField);
		}
		
		public override function requestEdit():void
		{
			if (_isSelected)
			{
				if (_nameField != null && _nameField.isSelected())
				{
					_nameField.activate();
				}
				else if (_multiplicityField != null && _multiplicityField.isSelected())
				{
					_multiplicityField.activate();
				}
			}
		}
		
		protected override function updateContent():void
		{
			//rien, parce qu'il est déjà édité.
		}
		
		protected override function onEdited(event:UmlEvent):void
		{
			super.onEdited(event);
		}
		
		protected override function onDeselected(event:UmlEvent):void
		{
			super.onDeselected(event);
			
			_nameField.deactivate();
			_multiplicityField.deactivate();
		}
		
		protected override function onCreationComplete(event:FlexEvent):void
		{
			//rien, pour qu'il n'y ait pas de glowFilter
		}
		
		public function setPosition(position:uint):void
		{
			var finalMeasuredWidth	:Number = 0;
			var finalMeasuredHeight	:Number = 0;
			
			if( _position != position )
			{
				_position = position;
				
				switch (_position)
				{
					case UmlViewBorderPosition.TOP:
					case UmlViewBorderPosition.BOTTOM:
						
						finalMeasuredWidth	=	_nameField.width + 
												_multiplicityField.width + 
												4 * _margin;
						
						finalMeasuredHeight	=	UmlViewField.DEFAULT_FIELD_HEIGHT + 
												2 * _margin;
					break;
					case UmlViewBorderPosition.RIGHT:
					case UmlViewBorderPosition.LEFT:
						
						finalMeasuredWidth	=	Math.max(_nameField.width, _multiplicityField.width) +  
												2 * _margin;
						
						finalMeasuredHeight	=	2 * UmlViewField.DEFAULT_FIELD_HEIGHT + 
												4 * _margin;
					break;
					default: return;
				}
				
				if (_backgroundTemoin != null)
				{
					_backgroundTemoin.width		= finalMeasuredWidth;
					_backgroundTemoin.height	= finalMeasuredHeight;
				}
				
				invalidateDisplayList();
			}
		}
		
		protected override function initListeners():void
		{
			super.initListeners();
			
			if (_nameField != null)
			{
				_nameField.addEventListener(UmlViewEvent.ACTIVATED,		onNameFieldActivated);
				_nameField.addEventListener(UmlViewEvent.DEACTIVATED,	onNameFieldDeactivated);
				_nameField.addEventListener(MouseEvent.MOUSE_DOWN,		onFieldsMouseDown);
			}
			
			if (_multiplicityField != null)
			{
				_multiplicityField.addEventListener(UmlViewEvent.ACTIVATED,		onMultiplicityFieldActivated);
				_multiplicityField.addEventListener(UmlViewEvent.DEACTIVATED,	onMultiplicityFieldDeactivated);
				_multiplicityField.addEventListener(MouseEvent.MOUSE_DOWN,		onFieldsMouseDown);
			}
		}
		
		protected function onFieldsMouseDown(event:MouseEvent):void
		{
			UmlSelectionControler.getInstance().deselectElement(this);
		}
		
		protected function onNameFieldActivated(event:UmlViewEvent):void
		{
			if (_nameField != null)
			{
				_nameField.addEventListener(UmlViewEvent.DONE,		onNameFieldDone);
				_nameField.addEventListener(UmlViewEvent.CANCEL,	onNameFieldCancel);
			}
			
			if (_multiplicityField != null)
			{
				_multiplicityField.deactivate();
			}
		}
		
		protected function onNameFieldDeactivated(event:UmlViewEvent):void
		{
			if (_nameField != null)
			{
				_nameField.removeEventListener(UmlViewEvent.DONE,	onNameFieldDone);
				_nameField.removeEventListener(UmlViewEvent.CANCEL,	onNameFieldCancel);
			}
		}
		
		protected function onNameFieldDone(e:UmlViewEvent):void
		{
			setFocus();
			_nameField.deactivate();
			UmlSelectionControler.getInstance().deselectElement(this);
			
			
			
			
			
			//update the modelElement
			UmlControler.getInstance().editAssociationEnd
			(
				modelFeature.uid, 
				_nameField.text, 
				getVisibility(), 
				modelFeature.type.name, 
				modelFeature.isNavigable(), 
				getMultiplicityArray()
			);
		}
		
		protected function onNameFieldCancel(e:UmlViewEvent):void
		{
			setFocus();
			_nameField.deactivate();
			UmlSelectionControler.getInstance().deselectElement(this);
		}
		
		protected function onMultiplicityFieldActivated(event:UmlViewEvent):void
		{
			if (_multiplicityField != null)
			{
				_multiplicityField.addEventListener(UmlViewEvent.DONE,		onMultiplicityFieldDone);
				_multiplicityField.addEventListener(UmlViewEvent.CANCEL,	onMultiplicityFieldCancel);
				_multiplicityField.addEventListener(Event.CHANGE,			onMultiplicityTextChange);
			}
			
			if (_nameField != null)
			{
				_nameField.deactivate();
			}
		}
		
		protected function onMultiplicityFieldDeactivated(event:UmlViewEvent):void
		{
			if (_multiplicityField != null)
			{
				_multiplicityField.removeEventListener(UmlViewEvent.DONE,	onMultiplicityFieldDone);
				_multiplicityField.removeEventListener(UmlViewEvent.CANCEL,	onMultiplicityFieldCancel);
				_multiplicityField.removeEventListener(Event.CHANGE,		onMultiplicityTextChange);
			}
		}
		
		protected function onMultiplicityFieldDone(event:UmlViewEvent):void
		{
			setFocus();
			_multiplicityField.deactivate();
		}
		
		protected function onMultiplicityFieldCancel(event:UmlViewEvent):void
		{
			setFocus();
			_multiplicityField.deactivate();
		}
		
		protected function onMultiplicityTextChange(event:Event):void
		{
			if (!_isRestrictChanged)
			{
				_multiplicityField.restrict = "[0-9]..*";
				_isRestrictChanged = true;
			}
			
			if (_multiplicityField.text == "")
			{
				_multiplicityField.restrict = "[0-9]*";
				_isRestrictChanged = false;
			}
		}
		
		protected function getMultiplicityArray():Array
		{
			return null;
		}
		
		protected override function getFormattedName():String
		{
			var formattedContent:String = "";
			
			formattedContent = getVisibilitySymbol() + modelFeature.name; 
			
			return formattedContent;
		}
		
		protected override function layoutChildren(p_width:Number, p_height:Number):void
		{
			var finalBackgroundX	:Number = 0;
			var finalBackgroundY	:Number = 0;
			
			var finalNameX			:Number = 0;
			var finalNameY			:Number = 0;
			
			var finalMultiplicityX	:Number = 0;
			var finalMultiplicityY	:Number = 0;
			
			switch (_position)
			{
				case UmlViewBorderPosition.TOP:
				
					finalBackgroundX	= -(_nameField.width + 2 * _margin);
					finalBackgroundY	= -(_nameField.height + 2 * _margin);
					
					finalNameX			= -_nameField.width - _margin;
					finalNameY			= -(_nameField.height + _margin);
					
					finalMultiplicityX	= _margin;
					finalMultiplicityY	= -(_multiplicityField.height + _margin);
					
				break;
				case UmlViewBorderPosition.BOTTOM:
					
					finalBackgroundX	= -(_nameField.width + 2 * _margin);
					finalBackgroundY	= 0;
					
					finalNameX			= -_nameField.width - _margin;
					finalNameY			= _margin;
					
					finalMultiplicityX	= _margin;
					finalMultiplicityY	= _margin;
					
				break;
				case UmlViewBorderPosition.LEFT:
					
					finalBackgroundX	= p_width - _nameField.width - 2 * _margin;
					finalBackgroundY	= p_height - _nameField.height - 2 * _margin;
					
					finalNameX			= p_width - _nameField.width - _margin;
					finalNameY			= p_height - _nameField.height - _margin;//_margin;
					
					finalMultiplicityX	= p_width - _multiplicityField.width - _margin;
					finalMultiplicityY	= _margin;//p_height - _multiplicityField.height - _margin;
					
				break;
				case UmlViewBorderPosition.RIGHT:
					
					finalBackgroundX	= 0;
					finalBackgroundY	= p_height - _nameField.height - 2 * _margin;
					
					finalNameX			= _margin;
					finalNameY			= p_height - _nameField.height - _margin;
					
					finalMultiplicityX	= _margin;
					finalMultiplicityY	= _margin;
					
				break;
				default: return;
			}
			
			if (_backgroundTemoin != null)
			{
				if (_backgroundTemoin.x != finalBackgroundX || 
					_backgroundTemoin.y != finalBackgroundY)
				{
					_backgroundTemoin.x = finalBackgroundX;
					_backgroundTemoin.y = finalBackgroundY;
				}
			}
			
			if (_nameField.x != finalNameX || 
				_nameField.y != finalNameY)
			{
				TweenMax.to
				(
					_nameField,
					0.3,
					{
						x		: finalNameX, 
						y		: finalNameY, 
						ease	: Strong.easeOut
					}
				);
			}
			
			if (_multiplicityField.x != finalMultiplicityX || 
				_multiplicityField.y != finalMultiplicityY)
			{
				TweenMax.to
				(
					_multiplicityField,
					0.3,
					{
						x		: finalMultiplicityX, 
						y		: finalMultiplicityY, 
						ease	: Strong.easeOut
					}
				);
			}
		}
		
		public function get modelMultiplicityElement():IUmlModelMultiplicityElement
		{
			if (modelElement != null && modelElement is IUmlModelMultiplicityElement)
			{
				return modelElement as IUmlModelMultiplicityElement;
			}
			
			return null;
		}
		
		public function get modelFeature():IUmlModelFeature
		{
			if (modelElement != null && modelElement is IUmlModelFeature)
			{
				return modelElement as IUmlModelFeature;
			}
			
			return null;
		}
		
		public function getMultiplicity():String
		{
			return modelMultiplicityElement.toMultiplicityString();
		}
		
		public function isNavigable():Boolean
		{
			return modelFeature.isNavigable();
		}
		
	}
	
}
