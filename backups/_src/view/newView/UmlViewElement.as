package view.newView
{
	
	import controler.UmlControler;
	import controler.UmlSelectionControler;
	import controler.UmlViewControler;
	import controler.events.UmlEvent;
	import controler.events.UmlViewEvent;
	
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Rectangle;
	import flash.ui.Keyboard;
	
	import model.IUmlModelElement;
	import model.IUmlModelNamedElement;
	
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	
	import view.IUmlViewElement;
	
	[Event(name="selectAll",		type="controler.events.UmlEvent")]
	[Event(name="nodeSelected",		type="controler.events.UmlEvent")]
	[Event(name="nodeDeselected",	type="controler.events.UmlEvent")]
	
	/**
	 * 
	 * @author kamal
	 * 
	 */
	public class	UmlViewElement 
		extends		UIComponent 
		implements	IUmlViewElement
	{
		
		/**
		 * 
		 */
		public static const UML_MIN_SIZE			:Number		= 100;
		
		public static const UML_DEFAULT_WIDTH		:Number		= 160;
		public static const UML_DEFAULT_HEIGHT		:Number		= 100;
		
		public static const UML_DEFAULT_TITLE_SIZE	:Number		= 30;
		
		public static const HORIZONTAL_MARGIN		:Number		= 10;
		public static const VERTICAL_MARGIN			:Number		= 10;
		
		/**
		 * 
		 */
		protected var _modelElement					:IUmlModelElement	= null;
		protected var _ownedElements				:Array				= null;
		
		/**
		 * 
		 */
		protected var _parentUID					:String				= "";
		
		/**
		 * 
		 */
		protected var _isSelected					:Boolean			= false;
		protected var _isSuperDragAllowed			:Boolean			= true;
		protected var _background					:Sprite				= null;
		
		protected var _isStopMouseEventPropagationAllowed	:Boolean	= true;
		
		protected var _isKeyboardAllowed			:Boolean			= false;
		
		/**
		 * context menu
		 */
		protected var _contextMenuItems				:Array				= null;
		protected var _isClipboardOperationsAllowed	:Boolean			= false;
		protected var _isPasteFeatureAllowed		:Boolean			= false;
		protected var _isSelectSimilarsAllowed		:Boolean			= true;
		
		protected var _itemSelectInModel		:AioViewContextMenuItem = null;
		protected var _itemSelectAll			:AioViewContextMenuItem = null;
		protected var _itemSelectSimilars		:AioViewContextMenuItem = null;
		
		protected var _itemCut					:AioViewContextMenuItem = null;
		protected var _itemCopy					:AioViewContextMenuItem = null;
		protected var _itemPaste				:AioViewContextMenuItem = null;
		
		protected var _itemProperties			:AioViewContextMenuItem = null;
		
		
		/**
		 * 
		 * @param xml
		 * @param parentUID
		 * 
		 */
		public function UmlViewElement(modelElement:IUmlModelElement, parentUID:String)
		{
			super();
			
			_modelElement	= modelElement;
			_parentUID		= parentUID;
		}
		
		/*******************************************************************************************
		 * 
		 * overriden functions 
		 * 
		 ******************************************************************************************/
		
		protected override function createChildren():void
		{
			super.createChildren();
			
			_ownedElements	= new Array();
			_background		= new Sprite();
			
			super.addChild(_background);
			
			initListeners();
			initModelListeners();
			
			createContextMenuItems();
			initContextMenuListeners();
		}
		
		protected override function measure():void
		{
			super.measure();
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
			layoutChildren(unscaledWidth, unscaledHeight);
			paint(unscaledWidth, unscaledHeight);
		}
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected override function keyDownHandler(event:KeyboardEvent):void
		{
			super.keyDownHandler(event);
			
			if (event.keyCode == Keyboard.F2)
			{
				var selectedNodesCount:int = 	UmlSelectionControler.getInstance().getSelectedClasses().length 
												+ 
												UmlSelectionControler.getInstance().getSelectedInterfaces().length 
												+ 
												UmlSelectionControler.getInstance().getSelectedAssociations().length;
				if (selectedNodesCount == 1)
				{
					requestEdit();
				}
			}
			
			//UmlControler.getInstance().handleKeyboardEvent(event);
		}
		
		/***********************************************************************
		 * 
		 * regular functions 
		 * 
		 **********************************************************************/
		
		/**
		 * 
		 * 
		 */
		protected function initListeners():void
		{
			addEventListener(FlexEvent.CREATION_COMPLETE,	onCreationComplete);
			addEventListener(MouseEvent.MOUSE_DOWN,			onMouseDown);
			addEventListener(MouseEvent.RIGHT_MOUSE_DOWN,	onRightMouseDown);
			
			addEventListener(UmlEvent.NODE_SELECTED,	onSelected);
			addEventListener(UmlEvent.NODE_DESELECTED,	onDeselected);
		}
		
		protected function initModelListeners():void
		{
			if (_modelElement != null)
			{
				_modelElement.addEventListener(UmlEvent.ELEMENT_EDITED,		onEdited);
				_modelElement.addEventListener(UmlEvent.ELEMENT_DELETED,	onElementDeleted);
			}
		}
		
		protected function createContextMenuClipboardItems():void
		{
			if (_contextMenuItems != null)
			{
				if (_isClipboardOperationsAllowed)
				{
					_itemCut = new AioViewContextMenuItem("Cut");
					_contextMenuItems.push(_itemCut);
					
					_itemCopy = new AioViewContextMenuItem("Copy");
					_contextMenuItems.push(_itemCopy);
				}
				
				if (_isPasteFeatureAllowed)
				{
					_itemPaste = new AioViewContextMenuItem("Paste");
					_contextMenuItems.push(_itemPaste);
				}
				
				if (_isClipboardOperationsAllowed || _isPasteFeatureAllowed)
				{
					_contextMenuItems.push("-");
				}
			}
		}
		
		protected function createContextMenuSelectionItems():void
		{
			if (_contextMenuItems != null)
			{
				_itemSelectInModel = new AioViewContextMenuItem("Select in model");
				_contextMenuItems.push(_itemSelectInModel);
				
				_itemSelectAll = new AioViewContextMenuItem("Select All");
				_contextMenuItems.push(_itemSelectAll);
				
				if (_isSelectSimilarsAllowed)
				{
					_itemSelectSimilars = new AioViewContextMenuItem("Select Similar Elements");
					_contextMenuItems.push(_itemSelectSimilars);
				}
			}
		}
		
		protected function createContextMenuAdditionalItems():void
		{
			//to override in subclasses.
		}
		
		protected function createContextMenuPropertiesItems():void
		{
			if (_contextMenuItems != null)
			{
				_itemProperties = new AioViewContextMenuItem("Properties");
				_contextMenuItems.push("-");
				_contextMenuItems.push(_itemProperties);
			}
		}
		
		/**
		 * must be overriden in subclasses.
		 */
		protected function createContextMenuItems():void
		{
			if (_contextMenuItems == null)
			{
				_contextMenuItems = new Array();
				
				createContextMenuClipboardItems();
				createContextMenuSelectionItems();
				createContextMenuAdditionalItems();
				createContextMenuPropertiesItems();
			}
		}
		
		protected function initContextMenuListeners():void
		{
			_itemSelectAll.addEventListener(MouseEvent.CLICK,		onItemSelectAllClick);
			_itemSelectInModel.addEventListener(MouseEvent.CLICK,	onItemSelectInModelClick);
			_itemProperties.addEventListener(MouseEvent.CLICK,		onItemPropertiesClick);
			
			if (_isClipboardOperationsAllowed)
			{
				_itemCut.addEventListener(MouseEvent.CLICK,		onItemCutClick);
				_itemCopy.addEventListener(MouseEvent.CLICK,	onItemSelectAllClick);
			}
			
			if (_isPasteFeatureAllowed)
			{
				_itemPaste.addEventListener(MouseEvent.CLICK, onItemPasteClick);
			}
		}
		
		/***********************************************************************
		 * 
		 * contextMenu callbacks
		 * 
		 **********************************************************************/		
		
		protected function onItemSelectAllClick(event:MouseEvent):void
		{
			var umlEvent:UmlEvent = new UmlEvent(UmlEvent.SELECT_ALL_REQUESTED);
			dispatchEvent(umlEvent);
			event.stopPropagation();
		}
		
		protected function onSelectAllRequested(event:UmlEvent):void
		{
			//override in subclasses.
			trace ("select all");
		}
		
		protected function onItemSelectInModelClick(event:MouseEvent):void
		{
			//override in subclasses.
		}
		
		protected function onItemPropertiesClick(event:MouseEvent):void
		{
			//override in subclasses.
		}
		
		protected function onItemCutClick(event:MouseEvent):void
		{
			//override in subclasses.
		}
		
		protected function onItemCopyClick(event:MouseEvent):void
		{
			//override in subclasses.
		}
		
		protected function onItemPasteClick(event:MouseEvent):void
		{
			//override in subclasses.
		}
		
		/**
		 * 
		 * @param p_width
		 * @param p_height
		 * 
		 */
		protected function layoutChildren(p_width:Number, p_height:Number):void
		{
			// to override in subClasses 
		}
		
		/**
		 * 
		 * @param p_width
		 * @param p_height
		 * 
		 */
		protected function paint(p_width:Number, p_height:Number):void
		{
			// to override in subClasses 
		}
		
		/**
		 * 
		 * abstract method, must be overriden in subclasses.
		 * it creates a node from the type parameter. 
		 * this nodeType must be one of the children's type
		 * 
		 * @param nodeType
		 */
		protected function createElementFromType(nodeType:String):void
		{
			// to override in subClasses 
		}
		
		/**
		 * 
		 * abstract method that return the permission of creating the view node.
		 * must be overriden in subClasses.
		 * 
		 * @param toolItem
		 * @return boolean : permission to create view node.
		 * 
		 */
		protected function isToolAllowed(toolItem:UmlViewToolItem):Boolean
		{
			return false;
		}
		
		public function showSelectionColor():void
		{
			
		}
		
		public function hideSelectionColor():void
		{
			
		}
		
		public function requestEdit():void
		{
			
		}
		
		/**
		 * this is the template method that update the view element fields.
		 * override in subclasses
		 */
		protected function updateContent():void
		{
			//rien
		}
		
		protected function getFormattedName():String
		{
			return "";
		}
		
		public function getContextMenuItems():Array
		{
			return _contextMenuItems;
		}
		
		public function dispose():void
		{
			//override in subclasses
		}
		
		public function get modelElement():IUmlModelElement
		{
			return _modelElement;
		}
		
		public function get ownedELements():Array
		{
			return _ownedElements;
		}
		
		public function get xml():XML
		{
			return _modelElement.xml;
		}
		
		public override function get uid():String
		{
			var id:String = _modelElement.uid;
			return id;
		}
		
		public function getParentId():String
		{
			return _parentUID;
		}
		
		public override function get name():String
		{
			if (_modelElement is IUmlModelNamedElement)
			{
				return (_modelElement as IUmlModelNamedElement).name;
			}
			
			return "";
		}
		
		public function getVisibility():String
		{
			if (_modelElement is IUmlModelNamedElement)
			{
				return (_modelElement as IUmlModelNamedElement).visibility.toString();
			}
			
			return "";
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		protected function getVisibilitySymbol():String
		{
			var visibilitySymbol:String = "";
			
			if (getVisibility() == "public")
			{
				visibilitySymbol = "+";
			}
			else if (getVisibility() == "private")
			{
				visibilitySymbol = "-";
			}
			else if (getVisibility() == "protected")
			{
				visibilitySymbol = "#";
			}
			else if (getVisibility() == "package")
			{
				visibilitySymbol = "~";
			}
			
			return visibilitySymbol;
		}
		
		public function isSelected():Boolean
		{
			return _isSelected;
		}
		
		public function setSelected(value:Boolean):void
		{
			var umlEvent:UmlEvent	= null;
			_isSelected				= value;
			
			if (_isSelected)
			{
				umlEvent = new UmlEvent(UmlEvent.NODE_SELECTED);
				umlEvent.setSelectedNode(this);
			}
			else
			{
				umlEvent = new UmlEvent(UmlEvent.NODE_DESELECTED);
				umlEvent.setSelectedNode(this);
			}
			
			dispatchEvent(umlEvent);
		}
		
		/***********************************************************************
		 * 
		 * business callback functions 
		 * 
		 **********************************************************************/
		
		protected function onSelected(event:UmlEvent):void
		{
			//override in subclasses.
			if (_isKeyboardAllowed && !hasEventListener(KeyboardEvent.KEY_DOWN))
			{
				addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
			}
			
			//setFocus();
		}
		
		protected function onDeselected(event:UmlEvent):void
		{
			//override in subclasses.
			if (_isKeyboardAllowed && hasEventListener(KeyboardEvent.KEY_DOWN))
			{
				removeEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
			}
		}
		
		protected function onEdited(e:UmlEvent):void
		{
			if (e.getEditedNode().uid == uid)
			{
				updateContent();
			}
		}
		
		/**
		 * this function is a callback of the delete element operation.
		 * 
		 * @param e
		 */
		protected function onElementDeleted(e:UmlEvent):void
		{
			//override in subclasses
		}
		
		/***********************************************************************
		 * 
		 * callback functions 
		 * 
		 **********************************************************************/
		
		protected function onRightMouseDown(event:MouseEvent):void
		{
			if (UmlControler.getInstance().getMode() == "normal")
			{
				UmlSelectionControler.setCtrlKeyDown(event.ctrlKey);
				UmlSelectionControler.getInstance().selectElement(this);
			}
			
			UmlViewControler.getInstance().showContextMenu(_contextMenuItems);
			
			if (_isStopMouseEventPropagationAllowed)
			{
				event.stopPropagation();
			}
		}
		
		/**
		 * @return the area rectangle that limits the drag operation.
		 */
		protected function getDragRectangle():Rectangle
		{
			//to override in subclasses.
			var rect:Rectangle = new Rectangle
			(
				0, 
				0, 
				this.parent.getRect(this.parent).width - this.width, 
				this.parent.getRect(this.parent).height - this.height 
			);
			
			return rect;
		}
		
		/**
		 * 
		 * @param e
		 * 
		 */
		protected function onMouseDown(e:MouseEvent):void
		{
			var rect:Rectangle = null;
			
			UmlControler.getInstance().addListenerToApplication(MouseEvent.MOUSE_MOVE,	onMouseMove);
			UmlControler.getInstance().addListenerToApplication(MouseEvent.MOUSE_UP,	onMouseUp);
			
			if (UmlViewControler.getInstance().isThereAContextMenu())
			{
				UmlViewControler.getInstance().disposeCurrentContextMenu();
			}
			
			if (_isSuperDragAllowed)
			{
				rect = getDragRectangle();
				this.startDrag(false, rect);
			}
			
			if (UmlControler.getInstance().getMode() == "normal")
			{
				UmlSelectionControler.setCtrlKeyDown(e.ctrlKey);
				UmlSelectionControler.getInstance().selectElement(this);
				setFocus();
			}
			
			if (_isStopMouseEventPropagationAllowed)
			{
				e.stopPropagation();
			}
		}
		
		/**
		 * 
		 * @param e
		 * 
		 */
		protected function onMouseMove(e:MouseEvent):void
		{
			if (_isSuperDragAllowed)
			{
				e.updateAfterEvent();
			}
		}
		
		/**
		 * 
		 * @param e
		 * 
		 */
		protected function onMouseUp(e:MouseEvent):void
		{
			if (_isSuperDragAllowed)
			{
				this.stopDrag();
			}
			
			UmlControler.getInstance().removeListenerFromApplication(MouseEvent.MOUSE_MOVE, onMouseMove);
			UmlControler.getInstance().removeListenerFromApplication(MouseEvent.MOUSE_UP, onMouseUp);
		}
		
		/**
		 * 
		 * @param e
		 * 
		 */
		protected function onCreationComplete(e:FlexEvent):void
		{
			// this filter is the default for all the subClasses
			filters = [new GlowFilter(0x000000, 1, 2, 2, 2, 10)];
			
			// to override in subClasses 
		}
		
		/**
		 * a template method that is a callBack of a drag operation's end.
		 * 
		 * @param event
		 */
		final protected function onToolItemEndDrag(event:UmlViewEvent):void
		{
			var umlToolItem:UmlViewToolItem = event.getDraggedToolItem();
			umlToolItem.stopDrag();
			
			if (isToolAllowed(umlToolItem) == true)
			{
				// creates the view node from the type
				createElementFromType(umlToolItem.getType());
			}
			
			// removes the toolItem from the view
			if (umlToolItem.parent != null)
			{
				umlToolItem.parent.removeChild(umlToolItem);
			}
		}
		
	}
	
}
