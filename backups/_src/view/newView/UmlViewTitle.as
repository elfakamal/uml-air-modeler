package view.newView
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	
	import mx.containers.Box;
	import mx.controls.Image;
	import mx.controls.Label;
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	
	public class UmlViewTitle extends UIComponent
	{
		
		/**
		 * 
		 * 
		 */
		public static const TITLE_HEIGHT		:Number			= 20;
		
		/**
		 * 
		 * tous les composant nécéssaires pour construire le composant UmlViewTitle.
		 * 
		 */
		protected var _holder						:Box					= null;
		protected var _icon							:Image					= null;
		protected var _iconUrl						:String					= null;
		protected var _label						:Label					= null;
		
		/**
		 * le petit triangle à côté du label du titre
		 */
		protected var _triangle						:UIComponent			= null;
		
		/**
		 * text handling
		 */
		protected var _labelText					:String					= "";
		protected var _isTextDirty					:Boolean				= true;
		
		/**
		 * the background paint tools
		 * (le même que veut damien)
		 * sauf que celui là c'est du vrai de chez vrai :p
		 * l'autre c'est que du photoshop :p
		 */
		protected var _backgound					:UIComponent			= null;
		protected var _backgroundGridSpacing		:uint					= 4;
		protected var _backgroundLineColor			:Number					= 0x444444;
		
		/**
		 * this mask allows us to display only the region wich it cover.
		 * so then, it help us to not show the damn lines qui dépassent 
		 * la frontière du titre, c'est répungant leur trucs.
		 */
		protected var _mask							:Sprite					= null;
		
		/**
		 * 
		 * triangle and label's properties
		 * they are updated directly and flex 
		 * do the job in his set of methods qui 
		 * sont très cool, surtout côté performance.
		 * 
		 */
		protected var _isLabelFilterDirty			:Boolean				= true;
		protected var _triangleFilter				:GlowFilter				= null;
		protected var _labelFilter					:GlowFilter				= null;
		protected var _triangleLineTickness			:Number					= 0.25;
		protected var _triangleLineColor			:Number					= 0xFFFFFF;
		protected var _triangleLineGlowColor		:Number					= 0xFFFFFF;
		
		/**
		 * 
		 * dropShadow properties
		 * 
		 */
		protected var _isDropShadowEnabled			:Boolean				= false;
		protected var _isDropShadowDirty			:Boolean				= true;
		protected var _dropShadow					:DropShadowFilter		= null;
		protected var _dropShadowDistance			:Number					= 20;
		protected var _dropShadowAngle				:Number					= 90;
		
		
		/**
		 * 
		 * 
		 * buttons
		 * 
		 * 
		 */
		protected var _isCollapseAllowed			:Boolean				= true;
		protected var _isCloseAllowed				:Boolean				= true;
		protected var _collapseButton				:UIComponent			= null;
		protected var _closeButton					:UIComponent			= null;
		protected var _isButtonLayoutDirty			:Boolean				= true;
		protected var _isButtonsPermissionDirty		:Boolean				= false;
		
		protected var _collapseCallBack				:Function				= null;
		protected var _closeCallBack				:Function				= null;
		
		protected var _isCollapsed					:Boolean				= false;
		
		/**
		 * buttons colors
		 */
		protected var _collapseButtonColor			:Number					= 0xFFFFFF;
		protected var _closeButtonColor				:Number					= 0xFFFFFF;
		protected var _isButtonsDrawingDirty			:Boolean				= true;
		
		protected var _collapseGlow					:GlowFilter				= null;
		protected var _closeGlow					:GlowFilter				= null;
		
		/**
		 * 
		 * 
		 */
		public function UmlViewTitle(text:String="Untitled", iconUrl:String="")
		{
			super();
			
			_labelText			= text;
			
			_triangleFilter		= new GlowFilter(_triangleLineGlowColor, 1, 6, 6, 2, 1);
			_labelFilter		= new GlowFilter(_triangleLineGlowColor, 1, 6, 6, 1, 10);
			_dropShadow			= new DropShadowFilter(_dropShadowDistance, _dropShadowAngle, 0x000000, 1, 6, 6, 1, 20);
			
			_collapseGlow		= new GlowFilter(_collapseButtonColor, 1, 2, 2, 2, 10);
			_closeGlow			= new GlowFilter(_closeButtonColor, 1, 2, 2, 2, 10);
			
			initListeners();
		}
		
		/**
		 * 
		 * overriden functions
		 * 
		 *
		 * 
		 * 
		 */
		protected override function createChildren():void
		{
			super.createChildren();
			
			initHolder();
			
			_mask = new Sprite();
			
			_backgound			= new UIComponent();
			
			_label				= new Label();
			_label.text			= _labelText;
			_label.filters		= [_triangleFilter];
			
			_triangle			= new UIComponent();
			
			addChild(_mask);
			addChild(_backgound);
			addChild(_holder);
			
			//initIcon();
			
			_holder.addChild(_triangle);
			_holder.addChild(_label);
			
			initButtons();
		}
		
		/**
		 * 
		 * 
		 * 
		 */
		protected override function commitProperties():void
		{
			super.commitProperties();
			
			if (_isTextDirty)
			{
				_label.text		= _labelText;
				_isTextDirty	= false;
			}
			
			if (_isDropShadowDirty)
			{
				_dropShadow.distance	= _dropShadowDistance;
				_dropShadow.angle		= _dropShadowAngle;
				_isDropShadowDirty		= false;
			}
			
			// remove the dropShadow from the filters array, cuz it have been disabled 
			if (!_isDropShadowEnabled)
			{
				var index:int = filters.indexOf(_dropShadow);
				if (index >= 0)
				{
					filters.splice(index, 1);
				}
			}
			
			if (_isButtonsDrawingDirty)
			{
				_collapseGlow.color		= _collapseButtonColor;
				_closeGlow.color		= _closeButtonColor;
				
				paintButtons();
				_isButtonsDrawingDirty = false;
			}
			
			if (_isButtonsPermissionDirty)
			{
				initButtons();
				_isButtonsPermissionDirty = false;
			}
			
			if (_isLabelFilterDirty)
			{
				_labelFilter.color		= _triangleLineGlowColor;
				_isLabelFilterDirty		= false;
			}
			
			_backgound.cacheAsBitmap = false;
			_backgound.mask = _mask;
		}
		
		/**
		 * 
		 * 
		 */
		protected override function measure():void
		{
			super.measure();
		}
		
		/**
		 * 
		 * 
		 * 
		 * 
		 */
		protected override function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			_holder.x				= 0;
			_holder.y				= 0;
			
			_triangle.width			= 10;
			_triangle.height		= 10;
			
			if (_isButtonLayoutDirty)
			{
				layoutButtons(unscaledWidth, unscaledHeight);
			}
			
			paintBackground();
			paintButtons();
		}
		
		//--------------------------
		// regular functions
		//--------------------------
		
		protected function initListeners():void
		{
			addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete)
		}
		
		protected function initHolder():void
		{
			_holder	= new Box();
		}
		
		/**
		 * 
		 * 
		 */
		protected function initIcon():void
		{
			_icon = new Image();
			_icon.load("view/Capture.png");
			_holder.addChild(_icon);
		}
		
		/**
		 * 
		 * 
		 * 
		 */
		protected function initButtons():void
		{
			_collapseButton		= new UIComponent();
			_closeButton		= new UIComponent();
			
			if (_isCollapseAllowed)
			{
				if (_collapseCallBack != null)
				{
					_collapseButton.addEventListener(MouseEvent.CLICK, onCollapseButtonClick);
					_collapseButton.addEventListener(MouseEvent.CLICK, _collapseCallBack);
				}
				
				_collapseButton.width		= 10;
				_collapseButton.height		= 10;
				_collapseButton.addEventListener(MouseEvent.MOUSE_OVER, onButtonMouseOver);
				_collapseButton.addEventListener(MouseEvent.MOUSE_OUT, onButtonMouseOut);
				
				addChild(_collapseButton);
			}
			else if (contains(_collapseButton))
			{
				removeChild(_collapseButton);
			}
			
			if (_isCloseAllowed)
			{
				if (_collapseCallBack != null)
				{
					_closeButton.addEventListener(MouseEvent.CLICK, _closeCallBack);
				}
				
				_closeButton.width		= 10;
				_closeButton.height		= 10;
				_closeButton.addEventListener(MouseEvent.MOUSE_OVER, onButtonMouseOver);
				_closeButton.addEventListener(MouseEvent.MOUSE_OUT, onButtonMouseOut);
				
				addChild(_closeButton);
			}
			else if (contains(_closeButton))
			{
				removeChild(_closeButton);
			}
		}
		
		protected function onCollapseButtonClick(e:MouseEvent):void
		{
			_isCollapsed = !_isCollapsed;
			_isButtonsDrawingDirty = true;
			invalidateProperties();
		}
		
		protected function onButtonMouseOver(e:MouseEvent):void
		{
			if (e.target == _collapseButton)
			{
				_collapseButtonColor = 0xFF6400;
			}
			else
			{
				_closeButtonColor = 0xFF0000;
			}
			_isButtonsDrawingDirty = true;
			invalidateProperties();
		}
		
		protected function onButtonMouseOut(e:MouseEvent):void
		{
			if (e.target == _collapseButton)
			{
				_collapseButtonColor = 0xFFFFFF;
			}
			else
			{
				_closeButtonColor = 0xFFFFFF;
			}
			_isButtonsDrawingDirty = true;
			invalidateProperties();
		}
		
		public function setCollapseEventListener(callback:Function):void
		{
			_collapseCallBack = callback;
		}
		public function setCloseEventListener(callback:Function):void
		{
			_closeCallBack = callback;
		}
		
		/**
		 * 
		 * 
		 * 
		 */
		protected function layoutButtons(p_width:Number, p_height:Number):void
		{
			_closeButton.x			= p_width - _closeButton.width - 5;
			_closeButton.y			= 5;
			
			_collapseButton.x		= _closeButton.x - _collapseButton.width - 5;
			_collapseButton.y		= 5;
		}
		
		/**
		 * 
		 * 
		 */
		protected function onCreationComplete(e:FlexEvent):void
		{
			styleName		= "toolBarTitle";
			
			if (_isDropShadowEnabled)
			{
				filters		= [_dropShadow];
			}
		}
		
		/**
		 * 
		 * 
		 */
		protected function initMask(p_width:Number, p_height:Number):void
		{
			_mask.graphics.clear();
			_mask.graphics.beginFill(0,0);
			_mask.graphics.drawRect(0, 0, p_width, p_height);
			_mask.graphics.endFill();
		}
		
		/**
		 * 
		 * 
		 */
		protected function paintBackground():void
		{
			_backgound.graphics.clear();
			
			_backgound.graphics.beginFill(0x222222, 1);
			_backgound.graphics.drawRect(0, 0, width, height);
			_backgound.graphics.endFill();
		}
		
		
		/**
		 * 
		 * 
		 */
		protected function paintButtons():void
		{
			_collapseButton.filters		= [_collapseGlow];
			_closeButton.filters		= [_closeGlow];
			
			with (_collapseButton.graphics)
			{
				clear();
				beginFill(_collapseButtonColor, .1);
				drawRect(0, 0, 10, 10);
				endFill();
				
				lineStyle(.1, _collapseButtonColor, 1);
				
				// if the window is not collapsed, we must draw all the rectangle 
				// in order to explain to the user that he can open the window
				if (_isCollapsed)
				{
					drawRect(0, 0, 9, 9);
				}
				
				drawRect(0, 7, 9, 2);
			}
			
			with (_closeButton.graphics)
			{
				clear();
				beginFill(0x000000, .1);
				drawRect(-1, -1, 11, 11)
				endFill();
				lineStyle(1, _closeButtonColor, 1);
				moveTo(1, 1);
				lineTo(9, 9);
				moveTo(9, 1);
				lineTo(1, 9);
			}
		}
		
		/**
		 * 
		 * 
		 * 
		 */
		public function setText(text:String):void
		{
			_labelText		= text;
			_isTextDirty	= true;
			invalidateProperties();
		}
		public function getText():String
		{
			return _labelText;
		}
		
		public function setDropShadowEnabled(value:Boolean):void
		{
			_isDropShadowEnabled	= value;
			_isDropShadowDirty		= true;
			invalidateProperties();
		}
		public function isDropShadowEnabled():Boolean
		{
			return _isDropShadowEnabled;
		}
		
		public function setDropShadowDistance(distance:Number):void
		{
			_dropShadowDistance		= distance;
			_isDropShadowDirty		= true;
			invalidateProperties();
		}
		
		public function setDropShadowAngle(angle:Number):void
		{
			_dropShadowAngle		= angle;
			_isDropShadowDirty		= true;
			invalidateProperties();
		}
		
		public function setGlowColor(color:Number):void
		{
			_triangleLineGlowColor	= color;
			_isLabelFilterDirty		= true;
			invalidateProperties();
		}
		
		public function setCollapseAllowed(value:Boolean):void
		{
			_isCollapseAllowed			= value;
			_isButtonsPermissionDirty	= true;
			invalidateProperties();
			invalidateDisplayList();
		}
		public function isCollapseAllowed():Boolean
		{
			return _isCollapseAllowed;
		}
		
		public function setCloseAllowed(value:Boolean):void
		{
			_isCloseAllowed				= value;
			_isButtonsPermissionDirty	= true;
			invalidateProperties();
			invalidateDisplayList();
		}
		public function isCloseAllowed():Boolean
		{
			return _isCloseAllowed;
		}
		
		public function setCollapsed(value:Boolean):void
		{
			_isCollapsed = value;
		}
		public function isCollapsed():Boolean
		{
			return _isCollapsed;
		}
		
		public function getCollapseButton():UIComponent
		{
			return _collapseButton;
		}
		
		public function getCloseButton():UIComponent
		{
			return _closeButton;
		}
		
	}
	
}
