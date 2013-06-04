package view.core
{
	import flash.display.DisplayObject;
	
	import mx.containers.Canvas;
	import mx.controls.Label;
	import mx.core.ScrollPolicy;
	import mx.events.FlexEvent;
	
	public class UmlViewTitle1 extends Canvas
	{
		
		protected var _umlLabel		:Label;
		protected var _umlColor		:uint		= 0xCCCCCC;
		
		public function UmlViewTitle1(umlText:String="Untitled")
		{
			super();
			
			horizontalScrollPolicy			= ScrollPolicy.OFF;
			verticalScrollPolicy			= ScrollPolicy.OFF;
			
			_umlLabel						= new Label();
			_umlLabel.text					= umlText;
			
			super.addChild(_umlLabel);
			
			initListeners();
		}
		
		private function initListeners():void
		{
			addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
		}
		
		private function onCreationComplete(e:FlexEvent):void
		{
			initLabel();
			centerLabel();
		}
		
		private function initLabel():void
		{
			_umlLabel.percentWidth			= 100;
			_umlLabel.styleName				= "ClassTitle";
		}
		
		private function centerLabel():void
		{
			_umlLabel.y = (this.height - _umlLabel.height) / 2;
		}
		
		public override function addChild(child:DisplayObject):DisplayObject
		{
			return null;
		}
		
		public function getText():String
		{
			return _umlLabel.text;
		}
		public function setText(value:String):void
		{
			_umlLabel.text = value;
		}
		
		public function setBackgroundColor(color:uint=0xCCCCCC):void
		{
			_umlColor = color;
			
			graphics.clear();
			graphics.beginFill(_umlColor, 1);
			graphics.drawRect(1, 10, width - 1, height - 1);
			drawRoundRect(1, 1, width - 1, height - 1, 4, [0xDDDDDD, _umlColor], [1, 1], verticalGradientMatrix(1, 1, width - 1, height - 1), null, null);
			graphics.endFill();
		}
		
		protected override function updateDisplayList(w:Number, h:Number):void
		{
			super.updateDisplayList(w, h);
			
			graphics.clear();
			graphics.beginFill(_umlColor, 1);
			graphics.drawRect(1, 10, w - 1, h - 10);
			drawRoundRect(1, 1, w - 1, h - 1, 4, [0xDDDDDD, _umlColor], [1, 1], verticalGradientMatrix(1, 1, w - 1, h - 1), null, null);
			graphics.endFill();
		}
		
	}
}