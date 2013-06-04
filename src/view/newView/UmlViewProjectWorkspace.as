package view.newView
{
	
	import com.greensock.TweenMax;
	
	import controler.UmlControler;
	import controler.UmlLayoutControler;
	import controler.events.UmlEvent;
	import controler.events.UmlViewEvent;
	
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	
	import model.IUmlModelElement;
	import model.UmlModel;
	
	import mx.containers.Canvas;
	import mx.controls.Image;
	import mx.events.FlexEvent;
	import mx.events.FlexNativeWindowBoundsEvent;
	
	/**
	 * 
	 * @author kamal
	 * 
	 */
	public class UmlViewProjectWorkspace extends UmlViewContainerNode
	{
		
		/**
		 * business managment
		 */
		protected var _diagrams				:Array						= null;
		
		/**
		 * the container that contains diagramsContainer :p ;)
		 */
		protected var _holder				:Canvas						= null;
		protected var _diagramsContainer	:UmlViewDiagramContainer	= null;
		
		/**
		 * 
		 */
		//protected var _addedNodePosition	:Point						= null;
		
		/**
		 * 
		 * 
		 */
		protected var _rightWindowContainer	:UmlViewWindowContainer		= null;
		protected var _viewToolBar			:UmlViewToolBar				= null;
		//protected var _menuBar				:ApplicationControlBar		= null;
		
		/**
		 * flags 
		 */
		protected var _isLayoutDirty			:Boolean				= true;
		protected var _isHolderSizeDirty		:Boolean				= true;
		protected var _isDrawingDirty			:Boolean				= true;
		protected var _isInitialized			:Boolean				= false;
		protected var _isFirstInit				:Boolean				= true;
		
		protected var _umlContextMenu			:UmlViewContextMenu		= null;
		
		/**
		 * 
		 * @param p_xml
		 * @param p_parentUID
		 * 
		 */
		public function UmlViewProjectWorkspace(modelElement:IUmlModelElement/*, p_parentUID:String*/)
		{
			super(modelElement, "#0");
			
			initListeners();
		}
		
		/***********************************************************************
		 * 
		 * overriden functions 
		 * 
		 **********************************************************************/
		
		/**
		 * 
		 * 
		 */
		protected override function initListeners():void
		{
			// it explain itself :p, it's dispatched by the model from the UmlModelProject class
			//UmlModel.getInstance().addEventListener(UmlEvent.DIAGRAM_ADDED, onDiagramAdded);
			_modelElement.addEventListener(UmlEvent.ELEMENT_ADDED, onDiagramAdded);
			
			addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			
			// dispatched by the UmlViewToolItem onMouseDown.
			UmlLayoutControler.getInstance().addEventListener(UmlViewEvent.TOOL_ITEM_START_DRAG, onToolItemStartDrag);
			UmlLayoutControler.getInstance().addNativeResizeEventListener(onWindowResize);
			
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			
			//addEventListener(MouseEvent.RIGHT_CLICK, onRightClick);
		}
		
		
		/**
		 * 
		 * @param child
		 * @return 
		 * 
		 */
		public override function addChild(child:DisplayObject):DisplayObject
		{
			if (child is UmlViewDiagram)
			{
				// ici on peut mettre le flags _isLayoutDirty à true, 
				// et on n'a pas besoin d'appeller invalidateDisplayList() 
				// parce que flex le fait au niveau de la classe Container.
				_isLayoutDirty = true;
				
				_diagramsContainer.addDiagram(child as UmlViewDiagram);
				
				return child;
			}
			else if (child is UmlViewToolBar)
			{
				return _globalHolder.addChildAt(_viewToolBar, _globalHolder.numChildren);
			}
			
			return _globalHolder.addChild(child);
		}
		
		/**
		 * 
		 * 
		 */
		protected override function createChildren():void
		{
			super.createChildren();
			
//			_menuBar					= new ApplicationControlBar();
			_holder						= new Canvas()
			_diagramsContainer			= new UmlViewDiagramContainer();
			_rightWindowContainer		= new UmlViewWindowContainer();
			_viewToolBar				= new UmlViewToolBar();
			
			_diagrams					= new Array();
			_isSuperDragAllowed			= false;
			
			addChild(_holder);
			_holder.addChild(_diagramsContainer);
			
			initWorkspaceViews();
		}
		
		/**
		 * 
		 * 
		 */
		protected override function measure():void
		{
			super.measure();
			
			if (parent)
			{
				measuredWidth = measuredMinWidth = parent.width;
				measuredHeight = measuredMinHeight = parent.height;
			}
		}
		
		public override function contains(child:DisplayObject):Boolean
		{
			return super.contains(_viewToolBar) || _globalHolder.contains(_viewToolBar);
		}
		
		/**
		 * 
		 * @param p_width
		 * @param p_height
		 * 
		 */
		protected override function layoutChildren(p_width:Number, p_height:Number):void
		{
			_background.x		= _globalHolder.x		= 0;
			_background.y		= _globalHolder.y		= 0;
			_background.width	= _globalHolder.width	= p_width;
			_background.height	= _globalHolder.height	= p_height;
			
			if (_isFirstInit && _viewToolBar && contains(_viewToolBar))
			{
				_viewToolBar.x = 0;
				
				// ici on le fait disparaitre en bas pour qu'on ait l'impression qu'il vien du bas 
				// quand il se collapse pour la première fois
				_viewToolBar.y = p_height;
				
				// pour que ce block soit exécuté une seul fois
				_isFirstInit = false;
			}
			
			if (_viewToolBar != null)
			{
				_holder.height = p_height - UmlViewTitle.TITLE_HEIGHT;
			}
		}
		
		/**
		 * 
		 * @param p_width
		 * @param p_height
		 * 
		 */
		protected override function paint(p_width:Number, p_height:Number):void
		{
			super.paint(p_width, p_height);
			
			_globalHolder.graphics.clear();
			_globalHolder.graphics.beginFill(0x222222, 1);
			_globalHolder.graphics.drawRect(0, 0, p_width, p_height);
			_globalHolder.graphics.endFill();
		}
		
		/**
		 * 
		 * @param toolItem
		 * @return 
		 * 
		 */
		protected override function isToolAllowed(toolItem:UmlViewToolItem):Boolean
		{
			return (toolItem.getType() == UmlModel.DIAGRAM);
		}
		
		/**
		 * 
		 * @param nodeType
		 * 
		 */
		protected override function createElementFromType(nodeType:String):void
		{
			switch (true)
			{
				case (nodeType == UmlModel.DIAGRAM) :
					UmlControler.getInstance().addDiagram("diagram 1");
				break;
			}
		}
		
		/**
		 * 
		 * @param child
		 * @return 
		 * 
		 */
		public override function removeChild(child:DisplayObject):DisplayObject
		{
			if (child is UmlViewToolItem && _globalHolder.contains(child))
			{
				return _globalHolder.removeChild(child);
			}
			return super.removeChild(child);
		}
		
		/**
		 * 
		 * 
		 */
		protected override function childrenCreated():void
		{
			super.childrenCreated();
			
			_holder.percentWidth = 100;
			
			//var verticalWindow:UmlViewWindow = new UmlViewWindow();
			
//			var contentTest:VBox = new VBox();
//			var labelContentTest:Label = new Label();
//			labelContentTest.text = "test";
//			var buttonContentTest:Button = new Button();
//			buttonContentTest.label = "test";
//			contentTest.addChild(labelContentTest);
//			contentTest.addChild(buttonContentTest);
			
			//verticalWindow.setType(UmlViewWindow.INDEPENDENT_WINDOW);
			
//			_rightWindowContainer.x = 200;
//			_rightWindowContainer.y = 100;
			
//			addChildAt(_rightWindowContainer, _globalHolder.getChildIndex(_viewToolBar));
//			addChild(_rightWindowContainer);
			
			//_rightWindowContainer.addChild(verticalWindow);
			//_rightWindowContainer.addChild(verticalWindow2);
			
			//verticalWindow.setContent(contentTest);
			
		}
		
		/***********************************************************************
		 * 
		 * regular functions
		 * 
		 **********************************************************************/
		
		public function endItemDragging(toolItem:UmlViewToolItem):void
		{
			if (toolItem.parent == _globalHolder)
			{
				_globalHolder.removeChild(toolItem);
			}
		}
		
		/**
		 * 
		 * 
		 */
		protected function initWorkspaceViews():void
		{
			initToolBar();
		}
		
		/**
		 * 
		 * 
		 */
		protected function initToolBar():void
		{
			_viewToolBar.addTool(new UmlViewToolItem("create diagram", 			UmlModel.DIAGRAM, "../../icons/nodes/diagram.jpg"));
			_viewToolBar.addTool(new UmlViewToolItem("create class", 			UmlModel.CLASS, "../../icons/nodes/class.jpg"));
			_viewToolBar.addTool(new UmlViewToolItem("create interface", 		UmlModel.INTERFACE));
			_viewToolBar.addTool(new UmlViewToolItem("create association",		UmlModel.ASSOCIATION));
			_viewToolBar.addTool(new UmlViewToolItem("create associationClass",	UmlModel.ASSOCIATION_CLASS));
			_viewToolBar.addTool(new UmlViewToolItem("create attribute", 		UmlModel.ATTRIBUTE));
			_viewToolBar.addTool(new UmlViewToolItem("create function", 		UmlModel.OPERATION));
			_viewToolBar.addTool(new UmlViewToolItem("create constant",			UmlModel.CONSTANT));
			_viewToolBar.addTool(new UmlViewToolItem("create signal",			UmlModel.SIGNAL));
			_viewToolBar.addTool(new UmlViewToolItem("create enumeration",		UmlModel.ENUMERATION));
			
			addChild(_viewToolBar);
			_viewToolBar.y = unscaledHeight;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public function getSelectedDiagram():UmlViewDiagram
		{
			return _diagramsContainer.getSelectedDiagram();
		}
		
		public function getHolderHorizontalScrollPosition():Number
		{
			return _holder.horizontalScrollPosition;
		}
		
		public function getHolderVerticalScrollPosition():Number
		{
			return _holder.verticalScrollPosition;
		}
		
		/***********************************************************************
		 * 
		 * callback functions
		 * 
		 **********************************************************************/
		
		/**
		 * 
		 * @param e
		 * 
		 */
		protected function onDiagramAdded(e:UmlEvent):void
		{
			var diagram:UmlViewDiagram = new UmlViewDiagram(e.getAddedElement(), "#0");
			_diagrams.push(diagram);
			addChild(diagram);
			
			_isLayoutDirty = true;
			invalidateDisplayList()
		}
		
		/**
		 * 
		 * @param e
		 * 
		 */
		protected function onToolItemStartDrag(e:UmlViewEvent):void
		{
			var toolItem:UmlViewToolItem = e.getDraggedToolItem();
			var toolItemClone:UmlViewToolItem = toolItem.clone();
			
			addChild(toolItemClone);
			
			toolItemClone.addEventListener(MouseEvent.MOUSE_MOVE,	onToolItemMove);
			UmlLayoutControler.getInstance().addEventListener(UmlViewEvent.TOOL_ITEM_END_DRAG, onToolItemEndDrag);			
			toolItemClone.startDrag();
			
			TweenMax.to
			(
				toolItemClone, 
				1, 
				{
					alpha	: UmlViewToolItem.DEFAULT_ITEM_ALPHA
				}
			);
		}
		
		/**
		 * 
		 * @param e
		 * 
		 */
		protected function onWindowResize(e:FlexNativeWindowBoundsEvent):void
		{
			_isDrawingDirty = true;
			invalidateDisplayList();
		}
		
		/**
		 * 
		 * @param e
		 * 
		 */
		protected function onToolItemMove(e:MouseEvent):void
		{
			e.updateAfterEvent();
		}
		
		protected override function onMouseDown(e:MouseEvent):void
		{
			//if (!_viewToolBar.isCollapsed()) 
			_viewToolBar.collapse();
		}
		
		protected function onRightClick(e:MouseEvent):void
		{
			if (_umlContextMenu == null)
			{
				_umlContextMenu = new UmlViewContextMenu();
			}
			
			if (!_globalHolder.contains(_umlContextMenu))
			{
				addChild(_umlContextMenu);
				
				_umlContextMenu.addItem("Constant", "");
				_umlContextMenu.addItem("Attribute", "");
				_umlContextMenu.addItem("Constructor", "");
				_umlContextMenu.addItem("Function", "");
			}
			
			_umlContextMenu.x = mouseX;
			_umlContextMenu.y = mouseY;
		}
		
		/**
		 * 
		 * @param e
		 * 
		 */
		protected override function onCreationComplete(e:FlexEvent):void
		{
			
			
//			var icon:Image = new Image();
//			icon.source = "/icons/association.png";
//			icon.x = 100;
//			icon.y = 100;
//			addChild(icon);
			
			
//			var coolElement:UmlViewCoolElement = new UmlViewCoolElement();
//			addChild(coolElement);
//			coolElement.x = 300;
//			coolElement.y = 200;
			
			
//			var verticalWindow2:UmlViewWindow = new UmlViewWindow();
//			verticalWindow2.setType(UmlViewWindow.INDEPENDENT_WINDOW);
//			var testForm:UmlViewInterfaceForm = new UmlViewInterfaceForm();
//			addChild(verticalWindow2);
//			
//			verticalWindow2.setContent(testForm);
//			verticalWindow2.x = 300;
//			verticalWindow2.y = 300;
			
//			var btn:Button = new Button();
//			btn.label = "test";
//			btn.x = 300;
//			btn.y = 300;
//			addChild(btn);
//			
//			var src:Array			= ["tomate", "chou-fleur", "oignon", "riz"];
//			var combo:ComboBox		= new ComboBox();
//			combo.editable			= true;
//			combo.dataProvider		= src;
//			combo.x					= 300;
//			combo.y					= 350;
//			combo.height			= 20;
//			addChild(combo);
			
//			var umlPackage:UmlViewPackage = new UmlViewPackage(<umlPackage id="98" name="myPackage1" />, -1);
//			addChild(umlPackage);
//			umlPackage.x = 200;
//			umlPackage.y = 200;
//			
//			var umlObject:UmlViewObject;
//			umlObject = new UmlViewObject(<umlObject id="166" name="unObjetAlaCon" />, -1);
//			
//			var umlDataType:UmlViewDataType;
//			umlDataType = new UmlViewDataType(<umlObject id="190" name="unDataTypeAlaCon" />, -1);
//			
//			var umlArtifact:UmlViewArtifact;
//			umlArtifact = new UmlViewArtifact(<umlObject id="120" name="unArtifactAlaCon" />, -1);
//			
//			var umlNote:UmlViewNote;
//			umlNote = new UmlViewNote(<umlNote id="86" name="note1" content="ceci est le contenu de la noté ajoutée" />, -1);
//			
//			var umlEnumeration:UmlViewEnumeration;
//			umlEnumeration = new UmlViewEnumeration(<umlEnumeration id="806" name="Enumeration1" />, -1);
//			
//			var umlSignal:UmlViewSignal;
//			umlSignal = new UmlViewSignal(<umlRegularNode id="67" name="regularNode" />, -1);
//			
//			var umlEnumLiteral:UmlViewEnumerationLiteral;
//			umlEnumLiteral = new UmlViewEnumerationLiteral(<umlEnumerationLiteral id="607" name="unChildNode" />, -1);
//			
//			addChild(umlObject);
//			umlObject.x = 200;
//			umlObject.y = 200;
//			
//			addChild(umlDataType);
//			umlDataType.x = 400;
//			umlDataType.y = 200;
//			
//			addChild(umlArtifact);
//			umlArtifact.x = 200;
//			umlArtifact.y = 400;
//			
//			addChild(umlNote);
//			umlNote.x = 400;
//			umlNote.y = 400;
//			
//			addChild(umlEnumeration);
//			umlEnumeration.x = 600;
//			umlEnumeration.y = 400;
//			
//			_globalHolder.addChild(umlSignal);
//			umlSignal.x = 600;
//			umlSignal.y = 10;
//			
//			addChild(umlEnumLiteral);
//			umlEnumLiteral.x = 800;
//			umlEnumLiteral.y = 600;
//			// cette ligne ne fait rien car un champs d'une enumération ne peut être privé ;)
//			umlEnumLiteral.setPrivate();
//			
		}
		
	}
	
}
