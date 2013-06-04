package view.newView
{
	import controler.UmlLayoutControler;
	import controler.events.UmlViewEvent;
	
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.net.URLRequest;
	
	import com.greensock.TweenMax;
	
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	
	
	/**
	 * 
	 * @author kamal
	 * 
	 */
	public class UmlViewToolItem extends UIComponent
	{
		
		/**
		 * 
		 * 
		 */
		public static const DEFAULT_ITEM_WIDTH				:Number			= 80;
		public static const DEFAULT_ITEM_HEIGHT				:Number			= 80;
		
		public static const DEFAULT_ITEM_ALPHA				:Number			= 0.5;
		
		/**
		 * 
		 */
		private var _name					:String			= "";
		
		protected var _type					:String			= "";
		
		/**
		 * 
		 */
		private var _isStartDrag			:Boolean		= false;
		private var _isStopDrag				:Boolean		= false;
		
		private var _isClone				:Boolean		= false;
		
		private var _isSizeDirty			:Boolean		= true;
		
		/**
		 * 
		 */
		private var _initialPoint			:Point			= null;
		
		/**
		 * 
		 * //"view/newView/toolItemDefault.png";
		 */
		private var _defaultIconUrl			:String			= "../../icons/nodes/diagramTool.png";
		private var _url					:String			= "";
		private var _toolIcon				:Loader			= null;
		
	 	private var _mask					:Sprite			= null;
		
		protected var _overGlow				:GlowFilter		= null;
		protected var _isOverGlowDirty		:Boolean		= false;
		protected var _overGlowAlpha		:Number			= 0;
		
		protected var _myTween				:TweenMax		= null;
		
		/**
		 * 
		 * cet attribut nous permet de limiter les appels à la méthode setOverGlowAlpha
		 * à une seule fois pour qu'il effectue la tween du glow une seule fois.
		 */
		protected var _isOverGlowDone:Boolean = false;
		
		
		/**
		 * 
		 * 
		 * 
		 * @param p_name
		 * @param p_type
		 * @param p_url
		 * 
		 */
		public function UmlViewToolItem(p_name:String, p_type:String, p_url:String="")
		{
			super();
			
			_name		= p_name;
			_type		= p_type;
			_url		= (p_url == "") ? _defaultIconUrl : p_url;
			_overGlow	= new GlowFilter(0xFFFFFF, _overGlowAlpha, 6, 6, 1, 10);
			
			
			filters		= [_overGlow];
			
			initListeners();
		}
		
		
		//--------------------------------
		// overriden functions
		//--------------------------------
		
		/**
		 * 
		 * 
		 */
		protected override function createChildren():void
		{
			super.createChildren();
			
			initIcon();
		}
		
		protected override function measure():void
		{
			super.measure();
			
			measuredWidth	= measuredMinWidth	= DEFAULT_ITEM_WIDTH;
			measuredHeight	= measuredMinHeight	= DEFAULT_ITEM_HEIGHT;
			
			if (_isSizeDirty)
			{
				measuredWidth	= measuredMinWidth	= (_toolIcon.width > 0) ? _toolIcon.width : DEFAULT_ITEM_WIDTH;
				measuredHeight	= measuredMinHeight	= (_toolIcon.height > 0) ? _toolIcon.height : DEFAULT_ITEM_HEIGHT;
			}
		}
		
		protected override function commitProperties():void
		{
			super.commitProperties();
			
		}
		
		/**
		 * 
		 * @param unscaledWidth
		 * @param unscaledHeight
		 * 
		 */
		protected override function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			if (_toolIcon.content)
			{
				_toolIcon.width = unscaledWidth;
				_toolIcon.height = unscaledHeight;
			}
			
			paint();
		}
		
		//--------------------------------
		// regular functions
		//--------------------------------
		
		protected function initListeners():void
		{
			addEventListener(FlexEvent.CREATION_COMPLETE,			onCreationComplete);
			
			addEventListener(MouseEvent.MOUSE_DOWN,					onMouseDown);
			addEventListener(MouseEvent.MOUSE_MOVE,					onMouseMove);
			addEventListener(MouseEvent.MOUSE_OVER,					onMouseOver);
			addEventListener(MouseEvent.MOUSE_OUT,					onMouseOut);
			addEventListener(MouseEvent.MOUSE_UP,					onMouseUp);
		}
		
		/**
		 * 
		 * 
		 */
		protected function onCreationComplete(e:FlexEvent):void
		{
			buttonMode = true;
			useHandCursor = true;
		}
		
		private function initIcon():void
		{
			_toolIcon					= new Loader();
			var request:URLRequest		= new URLRequest(_url);
			_toolIcon.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoaderComplete);
			_toolIcon.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onLoaderIOError);
			_toolIcon.load(request);
			this.addChild(_toolIcon);
		}
		
		private function onLoaderIOError(e:IOErrorEvent):void 
		{
			trace (e.text);
		}
		
		/**
		 * 
		 * @param e
		 * 
		 */
		private function onLoaderComplete(e:Event):void
		{
			_isSizeDirty = true;
			
			invalidateSize();
			invalidateDisplayList()
		}
		
		/**
		 * 
		 * 
		 * 
		 */
		protected function onMouseOver(e:MouseEvent):void
		{
			_isOverGlowDone = false;
		}
		
		/**
		 * 
		 * la méthode setOverGlowAlpha doit être appelée une seule fois, après le MouseOver.
		 */
		protected function onMouseMove(e:MouseEvent):void
		{
			if (!_isOverGlowDone)
			{
				_overGlowAlpha = 1;
				setOverGlowAlpha(false);
				_isOverGlowDone = true;
			}
		}
		
		/**
		 * 
		 * 
		 * 
		 */
		protected function onMouseOut(e:MouseEvent):void
		{
			_overGlowAlpha = 0;
			setOverGlowAlpha(true);
		}
		
		/**
		 * 
		 * 
		 */
		protected function onMouseDown(e:MouseEvent):void
		{
			if (!isClone())
			{
				// The UmlProjectWorspace is listning for this event
				// it creates the clone, and handle it.
				var umlEvent:UmlViewEvent = new UmlViewEvent(UmlViewEvent.TOOL_ITEM_START_DRAG, true);
				umlEvent.setDraggedToolItem(this);
				UmlLayoutControler.getInstance().dispatchEvent(umlEvent);
			}
		}
		
		/**
		 * this callBack verify if this toolItem is a clone, 
		 * to allows the view switch on its type, 
		 * so then it creates the right view node.
		 * 
		 * @param e
		 */
		protected function onMouseUp(e:MouseEvent):void
		{
			if (isClone())
			{
				// The View is listning for this event
				// it ends the operation, and creates the appropriate node.
				var umlEvent:UmlViewEvent = new UmlViewEvent(UmlViewEvent.TOOL_ITEM_END_DRAG, true);
				umlEvent.setDraggedToolItem(this);
				UmlLayoutControler.getInstance().dispatchEvent(umlEvent);
			}
		}
		
		/**
		 * 
		 * @param p_killTween
		 * 
		 */
		protected function setOverGlowAlpha(p_killTween:Boolean):void
		{
			_myTween = TweenMax.to
			(
				this, 
				1, 
				{
					glowFilter			: {alpha : _overGlowAlpha}, 
					onComplete			: killTween(),
					onCompleteParams	: [_myTween, p_killTween]
				}
			);
		}
		
		/**
		 * 
		 * @param p_tween
		 * @param p_killTween
		 * 
		 */
		protected function killTween(p_tween:TweenMax=null, p_killTween:Boolean=false):void
		{
			if (p_tween)
			{
				//p_tween.clear();
				p_tween.resume();
				
				if (p_killTween)
				{
					p_tween.killVars(p_tween.vars);
				}
			}
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function clone():UmlViewToolItem
		{
			var toolItemClone:UmlViewToolItem = new UmlViewToolItem(this._name, this._type, this._url);
			toolItemClone.setIsClone(true);
			
			if (parent)
			{
				var myPoint:Point = new Point(x, y);
				var coordinates:Point = parent.localToGlobal(myPoint);
				
				toolItemClone.x			= coordinates.x;
				toolItemClone.y			= coordinates.y;
				toolItemClone.alpha		= 0;
			}
			
			return toolItemClone;
		}
		
		/**
		 * 
		 * 
		 */
		private function paint():void
		{
			graphics.clear();
			graphics.beginFill(0xFFFFFF, 1);
			graphics.drawRect(0, 0, width, height);
			graphics.endFill();
		}
		
		public function isClone():Boolean
		{
			return _isClone;
		}
		public function setIsClone(isClone:Boolean):void
		{
			_isClone = isClone;
		}
		
		public function getType():String
		{
			return _type;
		}
		public function setType(p_type:String):void
		{
			this._type = p_type;
		}
		
	}
	
}
