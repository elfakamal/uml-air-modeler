package view.core
{
	
	import flash.display.Sprite;
	
	import mx.core.UIComponent;

	public class UmlViewCoolElement extends UIComponent
	{
		
		public static const DEFAULT_SIZE:Number = 200;
		
		protected var _background		:Sprite			= null;
		protected var _border			:Sprite			= null;
		
		/**
		 * lights
		 */		
		protected var _leftLight		:Sprite			= null;
		protected var _topLight			:Sprite			= null;
		protected var _rightLight		:Sprite			= null;
		protected var _bottomLight		:Sprite			= null;
		
		protected var _gridHorizontalSpacing		:Number = 2;
		protected var _gridVerticalSpacing			:Number = 2;
		
		protected var _isPaintingDirty	:Boolean		= true;
		
		
		public function UmlViewCoolElement()
		{
			super();
		}
		
		protected override function createChildren():void
		{
			super.createChildren();
			
			_background		= new Sprite();
			_border			= new Sprite();
			
			_leftLight		= new Sprite();
			_topLight		= new Sprite();
			_rightLight		= new Sprite();
			_bottomLight	= new Sprite();
			
			addChild(_background);
		}
		
		protected override function measure():void
		{
			super.measure();
			
			measuredWidth = measuredMinWidth = DEFAULT_SIZE;
			measuredHeight = measuredMinHeight = DEFAULT_SIZE;
		}
		
		protected override function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			layoutChildren(unscaledWidth, unscaledHeight);
			paint(unscaledWidth, unscaledHeight);
		}
		
		protected function layoutChildren(p_width:Number, p_height:Number):void
		{
			_background.x = 0;
			_background.y = 0;
			
			_border.x = 0;
			_border.y = 0;
			
			_leftLight.x = 0;
			_leftLight.y = 0;
			
			_topLight.x = 0;
			_topLight.y = 0;
			
			_rightLight.x = p_width;
			_rightLight.y = 0;
			
			_bottomLight.x = 0;
			_bottomLight.y = p_height;
		}
		
		protected function paint(p_width:Number, p_height:Number):void
		{
			paintBackground(p_width, p_height);
			paintBorder(p_width, p_height);
			paintLights(p_width, p_height);
		}
		
		protected function paintBackground(p_width:Number, p_height:Number):void
		{
			var level:Number = 0;
			var i:int = 0;
			
			with (_background.graphics)
			{
				clear();
				
				beginFill(0x000000, 1);
				drawRect(0, 0, p_width, p_height);
				endFill();
				
				lineStyle(0.1, 0xFFFFFF, 0.1);
				//drawRoundRect(0, 0, p_width, p_height, 5, 5);
				
				for (i = 0; i < width / _gridVerticalSpacing; i++)
				{
					moveTo(i * _gridVerticalSpacing, 0);
					lineTo(i * _gridVerticalSpacing, height);
				}
				
				for (i = 0; i < height / _gridHorizontalSpacing; i++)
				{
					moveTo(0, i * _gridHorizontalSpacing);
					lineTo(width, i * _gridHorizontalSpacing);
				}
			}
		}
		
		protected function drawPoint(_sprite:Sprite, x:Number, y:Number, size:Number):void
		{
			_sprite.graphics.moveTo(x, y);
			_sprite.graphics.lineTo(x + size, y + size);
		}
		
		protected function paintBorder(p_width:Number, p_height:Number):void
		{
			
		}
		
		protected function paintLights(p_width:Number, p_height:Number):void
		{
			
		}
		
	}
	
}
