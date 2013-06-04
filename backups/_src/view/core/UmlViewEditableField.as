package view.core
{
	import controler.events.UmlViewEvent;
	
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	
	import com.greensock.TweenMax;
	import com.greensock.easing.Strong;
	
	import mx.controls.TextInput;
	import mx.events.FlexEvent;
	
	
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
			
			restrict = "[a-z,éèçàù ,A-Z,0-9]";
			
			text = _actualText;
			
			setStyle("themeColor",		0xFF5500);
			setStyle("disabledColor",	0xFFFFFF);
			setStyle("textAlign",		"center");
			
			initListeners();
		}
		
		protected function initListeners():void
		{
			addEventListener(FlexEvent.CREATION_COMPLETE,	onCreationComplete);
			addEventListener(MouseEvent.MOUSE_DOWN,			onMouseDown);
			addEventListener(KeyboardEvent.KEY_DOWN,		keyDownHandler);
		}
		
		protected override function keyDownHandler(event:KeyboardEvent):void
		{
			var viewEvent:UmlViewEvent = null;
			
			if (event.keyCode == Keyboard.ENTER)
			{
				_actualText	= text;
				width		= textWidth + _margin;
				
				viewEvent = new UmlViewEvent(UmlViewEvent.DONE);
			}
			else if (event.keyCode == Keyboard.ESCAPE)
			{
				text = _actualText;
				viewEvent = new UmlViewEvent(UmlViewEvent.CANCEL);
			}
			
			if (viewEvent != null)
			{
				dispatchEvent(viewEvent);
			}
			
			event.stopPropagation();
		}
		
		private function onCreationComplete(event:FlexEvent):void
		{
			var viewEvent:UmlViewEvent = null;
			
			width	= textWidth + _margin;
			height	= 18;
			
			viewEvent = new UmlViewEvent(UmlViewEvent.CREATED);
			dispatchEvent(viewEvent);
		}
		
		private function onMouseDown(event:MouseEvent):void
		{
			if (!editable && !_isSelected)
			{
				setStyle("backgroundAlpha", 0.5);
				_isSelected = true;
			}
			else
			{
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
