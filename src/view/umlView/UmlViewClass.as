package view.umlView
{
	import controler.UmlControler;
	import controler.UmlSelectionControler;
	import controler.events.UmlEvent;
	import controler.namespaces.creator;
	import controler.serialization.XmiController;
	
	import flash.display.DisplayObject;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	
	import model.IUmlModelElement;
	
	import mx.controls.Button;
	import mx.events.FlexEvent;
	
	import view.core.UmlAlert;
	import view.core.UmlViewManagmentPicker;
	import view.newView.UmlViewContextMenu;
	import view.newView.UmlViewField;
	import view.newView.UmlViewClassifier;
	import view.panels.UmlViewClassForm;
	
	/**
	 * 
	 * @author kamal
	 * 
	 */
	public class UmlViewClass extends UmlViewClassifier
	{
		
		public static const UML_MIN_SIZE				:Number			= 100;
		
		public static const UML_DEFAULT_SIZE			:Number			= 200;
		public static const UML_DEFAULT_TITLE_SIZE		:Number			= 30;
		
		protected var addConstBtn				:Button				= null;
		protected var addAttBtn					:Button				= null;
		protected var addFuncBtn				:Button				= null;
		
		protected var _presse					:Boolean			= false;
		protected var _isResizerHidden			:Boolean			= false;
		
		protected var _interfaces				:Array				= null;
		
		
		/**
		 * 
		 * @param xml
		 * @param parentUID
		 * 
		 */
		public function UmlViewClass(modelElement:IUmlModelElement, parentUID:String)
		{
			super(modelElement,  parentUID);
			
			doubleClickEnabled		= true;
			
			// on aura des problèmes au cas où on utilisera le superDrag&drop 
			_isSuperDragAllowed		= false;
			_isKeyboardAllowed		= true;
		}
		
		/*******************************************************************************************
		 * 
		 * overriden functions 
		 * 
		 ******************************************************************************************/
		
		protected override function initListeners():void
		{
			super.initListeners();
			addEventListener(MouseEvent.DOUBLE_CLICK, onDoubleClick);
		}
		
		protected override function initModelListeners() : void
		{
			super.initModelListeners();
			
			_modelElement.addEventListener(UmlEvent.CONSTANT_ADDED,		onConstantAdded);
			_modelElement.addEventListener(UmlEvent.ATTRIBUTE_ADDED,	onAttributeAdded);
			_modelElement.addEventListener(UmlEvent.OPERATION_ADDED,	onOperationAdded);
		}
		
		protected override function onAddFieldClick(e:MouseEvent) : void
		{
			if (parent != null)
			{
				initAddFieldContextMenu();
				layoutContextMenu();
				
				_umlAddActionContextMenu.show();
				_umlAddActionContextMenu.setFocus();
				_umlAddActionContextMenu.addEventListener(FocusEvent.FOCUS_OUT, onContextMenuFocusOut);
			}
		}
		
		protected function initAddFieldContextMenu() : void
		{
			disposeCurrentContextMenu();
			
			if (_umlAddActionContextMenu == null)
			{
				_umlAddActionContextMenu = new UmlViewContextMenu();
			}
			
			_umlAddActionContextMenu.reset();
			
			if (parent != null)
			{
				if (!parent.contains(_umlAddActionContextMenu))
				{
					parent.addChild(_umlAddActionContextMenu);
				}
				
				_addConstantMenuItem		= _umlAddActionContextMenu.addItem("Constant", "");
				_addAttributeMenuItem		= _umlAddActionContextMenu.addItem("Attribute", "");
				_addFunctionMenuItem		= _umlAddActionContextMenu.addItem("Operation", "");
				
				_addConstantMenuItem.addEventListener(MouseEvent.CLICK,		onAddConstantRequested);
				_addAttributeMenuItem.addEventListener(MouseEvent.CLICK,	onAddAttributeRequested);
				_addFunctionMenuItem.addEventListener(MouseEvent.CLICK,		onAddFunctionRequested);
			}
		}
		
		protected function onAddConstantRequested(e:MouseEvent):void
		{
			requestAddConstant();
		}
		
		protected function onAddAttributeRequested(e:MouseEvent):void
		{
			requestAddAttribute();
		}
		
		protected function onAddFunctionRequested(e:MouseEvent):void
		{
			requestAddOperation();
		}
		
		protected function onContextMenuFocusOut(e:FocusEvent):void
		{
			resetContextMenu();
		}
		
		protected function resetContextMenu():void
		{
			if (_umlAddActionContextMenu != null)
			{
				_umlAddActionContextMenu.dispose(disposeCurrentContextMenu);
			}
		}
		
		protected function layoutContextMenu():void
		{
			_umlAddActionContextMenu.x =	x + unscaledWidth + 1 + 
											UmlViewManagmentPicker.PICKER_MARGIN + 
											UmlViewManagmentPicker.PICKER_MAX_WIDTH;
			
			_umlAddActionContextMenu.y = y;
		}
		
		protected function disposeCurrentContextMenu():void
		{
			if (parent != null && 
				_umlAddActionContextMenu != null && 
				parent.contains(_umlAddActionContextMenu))
			{
				parent.removeChild(_umlAddActionContextMenu);
			}
		}
		
		/**
		 * 
		 * 
		 */
		protected override function createChildren():void
		{
			super.createChildren();
			_title.setText(name);
		}
		
		/**
		 * 
		 * @param child
		 * @return 
		 * 
		 */
		public override function addChild(child:DisplayObject):DisplayObject
		{
			return null;
		}
		
		/**
		 * 
		 * 
		 */
		protected override function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
		}
		
		protected override function layoutChildren(p_width:Number, p_height:Number):void
		{
			super.layoutChildren(p_width, p_height);
		}
		
		/**
		 * 
		 * 
		 */
		public function requestAddConstant():void
		{
			super.requestAddField();
			UmlControler.getInstance().addConstant(uid);
		}
		
		/**
		 * 
		 * 
		 */
		public function requestAddAttribute():void
		{
			super.requestAddField();
			UmlControler.getInstance().addAttribute(uid);
		}
		
		/**
		 * 
		 * 
		 */
		public function requestAddOperation():void
		{
			super.requestAddField();
			UmlControler.getInstance().addOperation(uid);
		}
		
		protected override function addField(umlField:UmlViewField):void
		{
			super.addField(umlField);
			invalidateDisplayList();
		}
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected override function keyDownHandler(event:KeyboardEvent):void
		{
			super.keyDownHandler(event);
		}
		
		/*******************************************************************************************
		 * 
		 * overriden callback functions 
		 * 
		 ******************************************************************************************/
		
		protected override function onCreationComplete(e:FlexEvent):void
		{
			super.onCreationComplete(e);
		}
		
		protected override function onMouseDown(e:MouseEvent):void
		{
			super.onMouseDown(e);
			
			if (UmlControler.getInstance().getMode() == "normal")
			{
				// once we've selected this class, we must add a listener to it.
//				addEventListener(UmlEvent.NODE_DESELECTED,	onNodeDeselected);
//				addEventListener(KeyboardEvent.KEY_DOWN,	keyDownHandler);
				
				_presse = true;
				
				setFocus();
			}
		}
		
		protected override function onMouseMove(e:MouseEvent):void
		{
			super.onMouseMove(e);
			
			if (UmlControler.getInstance().getMode() == "normal")
			{
				if (_presse && !_isResizerHidden)
				{
					_isResizerHidden = true;
				}
				
				e.updateAfterEvent();
			}
		}
		
		protected override function onMouseUp(e:MouseEvent):void
		{
			super.onMouseUp(e);
			
			if (UmlControler.getInstance().getMode() == "normal")
			{
				_presse					= false;
				_isResizerHidden		= false;
			}
		}
		
		/*******************************************************************************************
		 * 
		 * business callback functions 
		 * 
		 ******************************************************************************************/
		
		protected function onConstantAdded(e:UmlEvent):void
		{
			use namespace creator;
			var constant:UmlViewConstant = new UmlViewConstant(e.getAddedElement(), uid);
			constant.setPublic();
			addConstant(constant as UmlViewConstant);
			
			if (constant != null)
			{
				constant.addEventListener(UmlEvent.ELEMENT_SELECTED,	onFieldSelected);
				constant.addEventListener(UmlEvent.ELEMENT_DESELECTED,	onFieldDeselected);
			}
		}
		
		protected function onAttributeAdded(e:UmlEvent):void
		{
			use namespace creator;
			var attribute:UmlViewAttribute = new UmlViewAttribute(e.getAddedElement(), uid);
			attribute.setPublic();
			addAttribute(attribute as UmlViewAttribute);
			
			if (attribute != null)
			{
				attribute.addEventListener(UmlEvent.ELEMENT_SELECTED,		onFieldSelected);
				attribute.addEventListener(UmlEvent.ELEMENT_DESELECTED,	onFieldDeselected);
			}
		}
		
		protected function onOperationAdded(e:UmlEvent):void
		{
			use namespace creator;
			var operation:UmlViewOperation = new UmlViewOperation(e.getAddedElement(), uid);
			operation.setPublic();
			addFunction(operation);
			
			if (operation != null)
			{
				operation.addEventListener(UmlEvent.ELEMENT_SELECTED,		onFieldSelected);
				operation.addEventListener(UmlEvent.ELEMENT_DESELECTED,	onFieldDeselected);
			}
		}
		
		/*******************************************************************************************
		 * 
		 * regular functions 
		 * 
		 ******************************************************************************************/
		
		/**
		 * 
		 * @param umlConstant
		 * 
		 */
		creator function addConstant(constant:UmlViewConstant):void
		{
			super.addField(constant);
			UmlSelectionControler.setCtrlKeyDown(false);
			UmlSelectionControler.getInstance().selectElement(constant);
			invalidateDisplayList();
		}
		
		/**
		 * 
		 * @param umlAttribute
		 * 
		 */
		creator function addAttribute(attribute:UmlViewAttribute):void
		{
			super.addField(attribute);
			UmlSelectionControler.setCtrlKeyDown(false);
			UmlSelectionControler.getInstance().selectElement(attribute);
			invalidateDisplayList();
		}
		
		/**
		 * 
		 * @param umlFunction
		 * 
		 */
		creator function addFunction(operation:UmlViewOperation):void
		{
			super.addField(operation);
			UmlSelectionControler.setCtrlKeyDown(false);
			UmlSelectionControler.getInstance().selectElement(operation);
			invalidateDisplayList();
		}
		
		public override function requestEdit():void
		{
			super.requestEdit();
			
			var classForm:UmlViewClassForm = new UmlViewClassForm();
			classForm.addEventListener(UmlEvent.VIEW_FIELD_FORM_READY,	onViewFormReady);
			classForm.addEventListener(UmlEvent.UML_ACTION_CANCELED,	onUmlActionCanceled);
			
			var umlAlert:UmlAlert = new UmlAlert(classForm);
			umlAlert.show();
			classForm.setNode(this);
		}
		
		protected override function onViewFormReady(e:UmlEvent):void
		{
			if (e.currentTarget is UmlViewClassForm)
			{
				var classForm:UmlViewClassForm = e.target as UmlViewClassForm;
				UmlControler.getInstance().editClass
				(
					getParentId(), 
					uid, 
					classForm.getName(), 
					classForm.getVisibility() 
				);
				
				classForm.removeEventListener(UmlEvent.VIEW_FIELD_FORM_READY, onViewFormReady);
				
				// TODO : détruire le fieldform (dans la mémoire biensur)
			}
		}
		
		protected override function onUmlActionCanceled(e:UmlEvent):void
		{
			super.onUmlActionCanceled(e);
			
			if (e.currentTarget is UmlViewClassForm)
			{
				var classForm:UmlViewClassForm = e.currentTarget as UmlViewClassForm;
				classForm.removeEventListener(UmlEvent.UML_ACTION_CANCELED, onUmlActionCanceled);
			}
		}
		
		public function getImplementedInterfaces():Array
		{
			var interfaces:Array = null;
			
			// TODO un sacré bordel
			
			return interfaces;
		}
		
		public function isPressed():Boolean
		{
			return _presse;
		}
		
		/*******************************************************************************************
		 * 
		 * normal callback functions 
		 * 
		 ******************************************************************************************/
		
		
		private function onDoubleClick(e:MouseEvent):void
		{
			XmiController.getInstance().write();
			
			//trace(_modelElement.xml.toXMLString());
			requestEdit();
		}
		
		protected override function onClick(e:MouseEvent):void
		{
			super.onClick(e);
			e.stopPropagation();
		}
		
	}

}
