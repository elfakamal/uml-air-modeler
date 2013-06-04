package view.newView.associations
{
	
	import com.greensock.TweenMax;
	import com.greensock.easing.Strong;
	
	import controler.events.UmlViewEvent;
	
	import flash.events.KeyboardEvent;
	import flash.geom.Rectangle;
	
	import model.IUmlModelElement;
	import model.IUmlModelFeature;
	import model.IUmlModelMultiplicityElement;
	
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
		
		public static const TOP				:uint			= 1;
		public static const RIGHT			:uint			= 2;
		public static const BOTTOM			:uint			= 3;
		public static const LEFT			:uint			= 4;
		
		//TODO : implement the constraints fields.
		
		protected var _nameField			:UmlViewEditableField	= null;
		protected var _multiplicityField	:UmlViewEditableField	= null;
		
		protected var _position				:uint			= 1;
		protected var _margin				:Number			= 5;
		
		protected var _backgroundCanvas		:Canvas			= null;
		
		//TODO: parentAssociation
		protected var _ownerAssociation		:UmlViewAssociation = null;
		
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
			
			_isSuperDragAllowed = true;
			
			_nameField			= new UmlViewEditableField(getFormattedName());
			_multiplicityField	= new UmlViewEditableField(getMultiplicity());
			_background			= null;
			
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
			super.createChildren();
			
			if (_backgroundCanvas == null)
			{
				//TODO complete the fucking stuff
				_backgroundCanvas = new Canvas();
				_backgroundCanvas.setStyle("backgroundColor", 0xFF5500);
				_backgroundCanvas.setStyle("backgroundAlpha", 0);
				addChild(_backgroundCanvas);
			}
			
			if (_nameField != null)
			{
				_nameField.deactivate();
				addChild(_nameField);
			}
			
			if (_multiplicityField != null)
			{
				_multiplicityField.deactivate();
				addChild(_multiplicityField);
			}
		}
		
		protected override function onCreationComplete(event:FlexEvent):void
		{
			//rien, pour qu'il y ait pas de glowFilter
		}
		
		public function setPosition(position:uint):void
		{
			var finalMeasuredWidth	:Number = 0;
			var finalMeasuredHeight	:Number = 0;
			
			_position = position;
			
			switch (_position)
			{
				case TOP:
				case BOTTOM:
					
					finalMeasuredWidth	=	_nameField.width + 
											_multiplicityField.width + 
											4 * _margin;
					
					finalMeasuredHeight	=	UmlViewField.DEFAULT_FIELD_HEIGHT + 
											2 * _margin;
				break;
				case RIGHT:
				case LEFT:
					
					finalMeasuredWidth	=	Math.max(_nameField.width, _multiplicityField.width) +  
											2 * _margin;
					
					finalMeasuredHeight	=	2 * UmlViewField.DEFAULT_FIELD_HEIGHT + 
											4 * _margin;
				break;
				default: return;
			}
			
			_backgroundCanvas.width		= finalMeasuredWidth;
			_backgroundCanvas.height	= finalMeasuredHeight;
		}
		
		protected override function initListeners():void
		{
			super.initListeners();
			
			if (_nameField != null)
			{
				_nameField.addEventListener(UmlViewEvent.ACTIVATED,		onNameFieldActivated);
				_nameField.addEventListener(UmlViewEvent.DEACTIVATED,	onNameFieldDeactivated);
			}
			
			if (_multiplicityField != null)
			{
				_multiplicityField.addEventListener(UmlViewEvent.ACTIVATED,		onMultiplicityFieldActivated);
				_multiplicityField.addEventListener(UmlViewEvent.DEACTIVATED,	onMultiplicityFieldDeactivated);
			}
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
				case TOP:
				
					finalBackgroundX	= -(_nameField.width + 2 * _margin);
					finalBackgroundY	= -(_nameField.height + 2 * _margin);
					
					finalNameX			= -_nameField.width - _margin;
					finalNameY			= -(_nameField.height + _margin);
					
					finalMultiplicityX	= _margin;
					finalMultiplicityY	= -(_multiplicityField.height + _margin);
					
				break;
				case BOTTOM:
					
					finalBackgroundX	= -(_nameField.width + 2 * _margin);
					finalBackgroundY	= 0;
					
					finalNameX			= -_nameField.width - _margin;
					finalNameY			= _margin;
					
					finalMultiplicityX	= _margin;
					finalMultiplicityY	= _margin;
					
				break;
				case LEFT:
					
					finalBackgroundX	= p_width - _nameField.width - 2 * _margin;
					finalBackgroundY	= p_height - _nameField.height - 2 * _margin;
					
					finalNameX			= p_width - _nameField.width - _margin;
					finalNameY			= p_height - _nameField.height - _margin;//_margin;
					
					finalMultiplicityX	= p_width - _multiplicityField.width - _margin;
					finalMultiplicityY	= _margin;//p_height - _multiplicityField.height - _margin;
					
				break;
				case RIGHT:
					
					finalBackgroundX	= 0;
					finalBackgroundY	= p_height - _nameField.height - 2 * _margin;
					
					finalNameX			= _margin;
					finalNameY			= p_height - _nameField.height - _margin;
					
					finalMultiplicityX	= _margin;
					finalMultiplicityY	= _margin;
					
				break;
				default: return;
			}
			
			if (_backgroundCanvas.x != finalBackgroundX || 
				_backgroundCanvas.y != finalBackgroundY)
			{
				_backgroundCanvas.x = finalBackgroundX;
				_backgroundCanvas.y = finalBackgroundY;
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
		
		protected function onNameFieldActivated(event:UmlViewEvent):void
		{
			if (_nameField != null)
			{
				_nameField.addEventListener(UmlViewEvent.DONE,		onNameFieldDone);
				_nameField.addEventListener(UmlViewEvent.CANCEL,	onNameFieldCancel);
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
			
		}
		
		protected function onNameFieldCancel(e:UmlViewEvent):void
		{
			
		}
		
		protected function onMultiplicityFieldActivated(event:UmlViewEvent):void
		{
			if (_multiplicityField != null)
			{
				_multiplicityField.addEventListener(UmlViewEvent.DONE,		onMultiplicityFieldDone);
				_multiplicityField.addEventListener(UmlViewEvent.CANCEL,	onMultiplicityFieldCancel);
			}
		}
		
		protected function onMultiplicityFieldDeactivated(event:UmlViewEvent):void
		{
			if (_multiplicityField != null)
			{
				_multiplicityField.removeEventListener(UmlViewEvent.DONE,	onMultiplicityFieldDone);
				_multiplicityField.removeEventListener(UmlViewEvent.CANCEL,	onMultiplicityFieldCancel);
			}
		}
		
		protected function onMultiplicityFieldDone(event:UmlViewEvent):void
		{
			
		}
		
		protected function onMultiplicityFieldCancel(event:UmlViewEvent):void
		{
			
		}
		
		protected override function getFormattedName():String
		{
			var formattedContent:String = "";
			
			formattedContent = getVisibilitySymbol() + modelFeature.name; 
			
			return formattedContent;
		}
		
		protected override function keyDownHandler(event:KeyboardEvent):void
		{
			super.keyDownHandler(event);
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
