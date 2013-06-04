package view.core
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Strong;
	
	import controler.events.UmlViewEvent;
	
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	
	import mx.controls.TextInput;
	import mx.events.FlexEvent;
	import mx.utils.OnDemandEventDispatcher;
	
	
	[Event(name="done",			type="controler.events.UmlViewEvent")]
	[Event(name="cancel",		type="controler.events.UmlViewEvent")]
	[Event(name="created",		type="controler.events.UmlViewEvent")]
	[Event(name="activated",	type="controler.events.UmlViewEvent")]
	[Event(name="deactivated",	type="controler.events.UmlViewEvent")]
	
	
	/**
	 * 
	 * @author kamal
	 * 
	 */
	public class UmlViewEditableField extends TextInput
	{
		
		
		protected var _actualText		:String		= "";
		protected var _isSelected		:Boolean	= false;
		protected var _margin			:Number		= 20;
		
		
		public function UmlViewEditableField(text:String="")
		{
			super();
			
			_actualText = text;
		}
		
		protected override function createChildren():void
		{
			super.createChildren();
			
			text = _actualText;
			
			setStyle("themeColor",		0xFF5500);
			setStyle("disabledColor",	0xFFFFFF);
			setStyle("textAlign",		"center");
			
			initListeners();
		}
		
		protected function initListeners():void
		{
			addEventListener(FlexEvent.CREATION_COMPLETE,	onCreationComplete);
			addEventListener(MouseEvent.CLICK,				onMouseClick);
			addEventListener(KeyboardEvent.KEY_DOWN,		keyDownHandler);
			
			addEventListener(MouseEvent.MOUSE_OVER,			onMouseOver);
			addEventListener(MouseEvent.MOUSE_OUT,			onMouseOut);
		}
		
		private function onMouseOver(event:MouseEvent):void
		{
			if (!_isSelected)
			{
				setStyle("backgroundAlpha", 0.2);
			}
		}
		
		private function onMouseOut(event:MouseEvent):void
		{
			if (!_isSelected)
			{
				setStyle("backgroundAlpha", 0);
			}
		}
		
		protected function validate():void
		{
			var viewEvent:UmlViewEvent = null;
			
			_actualText	= text;
			width		= textWidth + _margin;
			
			viewEvent = new UmlViewEvent(UmlViewEvent.DONE);
			dispatchEvent(viewEvent);
		}
		
		protected function cancel():void
		{
			var viewEvent:UmlViewEvent = null;
			
			text = _actualText;
			viewEvent = new UmlViewEvent(UmlViewEvent.CANCEL);
			dispatchEvent(viewEvent);
		}
		
		protected override function keyDownHandler(event:KeyboardEvent):void
		{
			if (event.keyCode == Keyboard.ENTER)
			{
				validate();
			}
			else if (event.keyCode == Keyboard.ESCAPE)
			{
				cancel();
			}
			
			event.stopPropagation();
		}
		
		private function onFocusOut(event:FocusEvent):void
		{
			//validate();
			
			removeEventListener(FocusEvent.FOCUS_OUT, onFocusOut);
		}
		
		private function onCreationComplete(event:FlexEvent):void
		{
			var viewEvent:UmlViewEvent = null;
			
			width	= textWidth + _margin;
			height	= 18;
			
			viewEvent = new UmlViewEvent(UmlViewEvent.CREATED);
			dispatchEvent(viewEvent);
		}
		
		private function onMouseClick(event:MouseEvent):void
		{
			if (!editable && !_isSelected)
			{
				setStyle("backgroundAlpha", 0.5);
				_isSelected = true;
				addEventListener(FocusEvent.FOCUS_OUT, onFocusOut);
			}
			else
			{
				//quand il est selectionné, il faut stoper la propagation 
				//pour ne pas permettre au parent de le déselectionner.
				event.stopPropagation();
			}
		}
		
		public function activate():void
		{
			var viewEvent:UmlViewEvent = null;
			
			enabled		= true;
			editable	= true;
			
			setStyle("borderStyle", "none");
			setStyle("backgroundAlpha", 0.8);
			setStyle("focusAlpha", 1);
			
			setFocus();
			
			viewEvent = new UmlViewEvent(UmlViewEvent.ACTIVATED);
			dispatchEvent(viewEvent);
		}
		
		public function deactivate():void
		{
			var viewEvent:UmlViewEvent = null;
			
			width		= textWidth + _margin;
			
			enabled		= false;
			editable	= false;
			
			setStyle("borderStyle", "none");
			setStyle("backgroundAlpha", 0.0);
			setStyle("focusAlpha", 0);
			
			_isSelected = false;
			
			viewEvent = new UmlViewEvent(UmlViewEvent.DEACTIVATED);
			dispatchEvent(viewEvent);
		}
		
		public function isSelected():Boolean
		{
			return _isSelected;
		}
		
	}
	
}
