package view.newView
{
	import controler.UmlControler;
	import controler.UmlSelectionControler;
	import controler.UmlViewControler;
	import controler.events.UmlEvent;
	
	import flash.display.GradientType;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	import model.IUmlModelElement;
	import model.UmlModel;
	
	import mx.containers.VBox;
	import mx.controls.Alert;
	import mx.core.ScrollPolicy;
	import mx.events.CloseEvent;
	import mx.events.FlexEvent;
	
	import view.core.UmlViewManagmentPicker;
	import view.core.UmlViewPickerItem;
	import view.core.UmlViewResizer;
	import view.newView.associations.UmlViewAggregation;
	import view.newView.associations.UmlViewAssociation;
	import view.newView.associations.UmlViewCompostion;
	import view.newView.associations.UmlViewDependency;
	import view.newView.associations.UmlViewGeneralization;
	import view.newView.associations.UmlViewImplementation;
	import view.newView.associations.UmlViewUsage;
	
	
	/**
	 * 
	 * @author kamal
	 * 
	 */
	public class UmlViewClassifier extends UmlViewElement
	{
		
		/**
		 * 
		 */
		protected static const ADD				:uint				= 1;
		protected static const EDIT				:uint				= 2;
		protected static const DELETE			:uint				= 3;
		
		/**
		 * 
		 */
		protected var _managmentPicker		:UmlViewManagmentPicker	= null;
		
		protected var _addFieldButton		:UmlViewPickerItem		= null;
		protected var _editFieldButton		:UmlViewPickerItem		= null;
		protected var _deleteFieldButton	:UmlViewPickerItem		= null;
		
		protected var _addConstantMenuItem	:UmlViewContextMenuItem	= null;
		protected var _addAttributeMenuItem	:UmlViewContextMenuItem	= null;
		protected var _addFunctionMenuItem	:UmlViewContextMenuItem	= null;
		
		protected var _umlAddActionContextMenu	:UmlViewContextMenu = null;
		
		/**
		 * 
		 */
		protected var _titleMask				:Sprite				= null;
		protected var _fieldsMask				:Sprite				= null;
		protected var _resizer					:UmlViewResizer		= null;
		
		/**
		 * 
		 */
		protected var _fieldsHolder				:VBox				= null;
		protected var _numFields				:uint				= 0;
		protected var _selectedFields			:Array				= null;
		
		/**
		 * 
		 */
		protected var _title					:UmlViewNodeTitle	= null;
		protected var _isTitleDirty				:Boolean			= true;
		
		protected var _isTitleAllowed			:Boolean			= true;
		protected var _isCustomBorderAllowed	:Boolean			= true;
		
		protected var _titleSeparator			:Sprite				= null;
		protected var _border					:Sprite				= null;
		
		protected var _rectangle				:Rectangle			= null;
		
		protected var _addAssociationButton		:UmlViewPickerItem		= null;
		protected var _addGeneralizationButton	:UmlViewPickerItem		= null;
		protected var _addUsageButton			:UmlViewPickerItem		= null;
		protected var _addDependencyButton		:UmlViewPickerItem		= null;
		protected var _addAggregationButton		:UmlViewPickerItem		= null;
		protected var _addCompositionButton		:UmlViewPickerItem		= null;
		protected var _addRealizationButton		:UmlViewPickerItem		= null;
		
		protected var _itemResizeToContent		:AioViewContextMenuItem	= null;
		protected var _itemGenerateCode			:AioViewContextMenuItem	= null;
		
		
		/**
		 * 
		 * @param xml
		 * @param parentUID
		 * 
		 */
		public function UmlViewClassifier(modelElement:IUmlModelElement, parentUID:String)
		{
			super(modelElement, parentUID);
			
			_rectangle				= new Rectangle();
			_border					= new Sprite();
			
			_isStopMouseEventPropagationAllowed	= true;
			_isClipboardOperationsAllowed		= true;
			_isPasteFeatureAllowed				= true;
		}
		
		/***********************************************************************
		 * 
		 * overriden functions 
		 * 
		 **********************************************************************/
		
		protected override function initListeners():void
		{
			super.initListeners();
			addEventListener(MouseEvent.CLICK, onClick);
		}
		
		protected override function initModelListeners() : void
		{
			super.initModelListeners();
		}
		
		protected override function createContextMenuAdditionalItems():void
		{
			super.createContextMenuAdditionalItems();
			
			if (_contextMenuItems != null)
			{
				_itemResizeToContent	= new AioViewContextMenuItem("Resize to content");
				_itemGenerateCode		= new AioViewContextMenuItem("Generate code");
				
				_contextMenuItems.push("-");
				_contextMenuItems.push(_itemResizeToContent);
				_contextMenuItems.push(_itemGenerateCode);
			}
		}
		
		protected function createPickerButtons():void
		{
			_addFieldButton		= _managmentPicker.addTopLevelButton("+");
			_editFieldButton	= _managmentPicker.addTopLevelButton("..");
			_deleteFieldButton	= _managmentPicker.addTopLevelButton("-");
			
			_addFieldButton.addEventListener(MouseEvent.CLICK,		onAddFieldClick);
			_editFieldButton.addEventListener(MouseEvent.CLICK,		onEditFieldClick);
			_deleteFieldButton.addEventListener(MouseEvent.CLICK,	onDeleteFieldClick);
			
			_addAssociationButton		= _managmentPicker.addLowLevelButton("", "/icons/association.png", "Association");
			_addGeneralizationButton	= _managmentPicker.addLowLevelButton("", "/icons/generalization.png", "Generalization");
			_addDependencyButton		= _managmentPicker.addLowLevelButton("", "/icons/dependency.png", "Dependency");
			_addAggregationButton		= _managmentPicker.addLowLevelButton("", "/icons/aggregation.png", "Aggregation");
			_addCompositionButton		= _managmentPicker.addLowLevelButton("", "/icons/composition.png", "Composition");
			_addRealizationButton		= _managmentPicker.addLowLevelButton("", "/icons/realization.png", "Realization");
			_addUsageButton				= _managmentPicker.addLowLevelButton("", "/icons/dependency.png", "Usage");
			
			
			_addAssociationButton.relatedClass		= UmlViewAssociation;
			_addGeneralizationButton.relatedClass	= UmlViewGeneralization;
			_addDependencyButton.relatedClass		= UmlViewDependency;
			_addAggregationButton.relatedClass		= UmlViewAggregation;
			_addCompositionButton.relatedClass		= UmlViewCompostion;
			_addRealizationButton.relatedClass		= UmlViewImplementation;
			_addUsageButton.relatedClass			= UmlViewUsage;
			
			
			_addAssociationButton.addEventListener(MouseEvent.MOUSE_DOWN,		onPickerItemMouseDown);
			_addGeneralizationButton.addEventListener(MouseEvent.MOUSE_DOWN,	onPickerItemMouseDown);
			_addDependencyButton.addEventListener(MouseEvent.MOUSE_DOWN,		onPickerItemMouseDown);
			_addAggregationButton.addEventListener(MouseEvent.MOUSE_DOWN,		onPickerItemMouseDown);
			_addCompositionButton.addEventListener(MouseEvent.MOUSE_DOWN,		onPickerItemMouseDown);
			_addRealizationButton.addEventListener(MouseEvent.MOUSE_DOWN,		onPickerItemMouseDown);
			_addUsageButton.addEventListener(MouseEvent.MOUSE_DOWN,				onPickerItemMouseDown);
			
			
			deactivateEditOperation();
			deactivateDeleteOperation();
		}
		
		protected function onPickerItemMouseDown(event:MouseEvent):void
		{
			var type		:Class				= null;
			var pickerItem	:UmlViewPickerItem	= null;
			
			if (event.currentTarget is UmlViewPickerItem)
			{
				pickerItem	= event.currentTarget as UmlViewPickerItem;
				type		= pickerItem.relatedClass;
			}
			
			createAssociation(type);
		}
		
		/**
		 * cette fonction dispatche un événement qui indiquera au diagramme
		 * que l'on a demandé de créer une association, ainsi, le diagramme 
		 * procèdera de la manière habituelle, mais juste avec un peu plus 
		 * de détails comme le premier côté de l'association.
		 */
		protected function createAssociation(type:Class):void
		{
			// détécté par UmlViewDiagram
			var umlEvent:UmlEvent = null;
			umlEvent = new UmlEvent(UmlEvent.PICKER_ADD_ASSOCIATION);
			umlEvent.setFirstSide(this);
			umlEvent.setAssociationCreationClass(type);
			dispatchEvent(umlEvent);
		}
		
		protected function onAddFieldClick(e:MouseEvent):void
		{
			requestAddField();
		}
		
		protected function onEditFieldClick(e:MouseEvent):void
		{
			requestEditField();
		}
		
		protected function onDeleteFieldClick(e:MouseEvent):void
		{
			requestDeleteField();
		}
		
		protected override function createChildren():void
		{
			super.createChildren();
			
			if (_isTitleAllowed)
			{
				_fieldsHolder	= new VBox();
				
				_title			= new UmlViewNodeTitle();
				//_title.setBackgroundAllowed(true);
				_title.fitToParentSize();
				
				// separators
				_titleSeparator	= new Sprite();
				
				// masks
				_titleMask		= new Sprite();
				_fieldsMask		= new Sprite();
				
				_selectedFields			= new Array();
				_managmentPicker	= new UmlViewManagmentPicker();
				
				_resizer				= new UmlViewResizer(this);
				
				_fieldsHolder.horizontalScrollPolicy	= ScrollPolicy.OFF;
				_fieldsHolder.verticalScrollPolicy		= ScrollPolicy.OFF;
				_fieldsHolder.setStyle("verticalGap", "1");
				//_fieldsHolder.setStyle("backgroundColor", "#ff5500");
				
				super.addChildAt(_managmentPicker, 0);
				createPickerButtons();
				
				super.addChild(_fieldsHolder);
				super.addChild(_title);
				super.addChild(_titleMask);
				super.addChild(_titleSeparator);
				super.addChild(_fieldsMask);
				super.addChild(_resizer);
				
				_fieldsHolder.cacheAsBitmap	= false;
				_fieldsHolder.mask			= _fieldsMask;
				
				_title.cacheAsBitmap	= false;
				_title.mask				= _titleMask;
			}
			else
			{
				_fieldsHolder		= null;
				_title				= null;
				_titleSeparator		= null;
			}
			
			super.addChild(_border);
		}
		
		protected override function measure():void
		{
			super.measure();
			
			measuredWidth	= measuredMinWidth	= UML_DEFAULT_WIDTH;
			measuredHeight	= measuredMinHeight	= UML_DEFAULT_HEIGHT;
		}
		
		protected override function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			layoutChildren(unscaledWidth, unscaledHeight);
			
			if (_isCustomBorderAllowed)
			{
				paintCustomBorder(unscaledWidth, unscaledHeight);
			}
			
			paint(unscaledWidth, unscaledHeight);
			paintTitleMask(unscaledWidth, unscaledHeight);
			paintFieldsMask(unscaledWidth, unscaledHeight);
			
			if (_rectangle != null)
			{
				_rectangle.x		= 0;
				_rectangle.y		= 0;
				_rectangle.width	= unscaledWidth;
				_rectangle.height	= unscaledHeight;
			}
		}
		
		protected override function layoutChildren(p_width:Number, p_height:Number):void
		{
			super.layoutChildren(p_width, p_height);
			
			if (_border != null)
			{
				_border.x		= 0;
				_border.y		= 0;
			}
			
			if (_title != null)
			{
				_title.x	= p_width / 2 - _title.getExplicitOrMeasuredWidth() / 2;
				_title.y	= 0;
				
				_titleSeparator.x		= 0;
				_titleSeparator.y		= _title.getExplicitOrMeasuredHeight();
				
				_titleMask.x			= 0;
				_titleMask.y			= 0;
				
				_fieldsMask.x			= 0;
				_fieldsMask.y			= _titleSeparator.y + _titleSeparator.height;
			}
			
			if (_fieldsHolder != null)
			{
				_fieldsHolder.x = 0;
				
				if (_titleSeparator != null)
				{
					_fieldsHolder.y = _titleSeparator.y + _titleSeparator.height;
				}
				else
				{
					_fieldsHolder.y = 0;
				}
				
				_fieldsHolder.width		= p_width;
				_fieldsHolder.height	= _numFields * (UmlViewField.DEFAULT_FIELD_HEIGHT + 
											Number(_fieldsHolder.getStyle("verticalGap")));
			}
			
			if (_managmentPicker != null)
			{
				_managmentPicker.x		= p_width + UmlViewResizer.SIDE_SIZE * 2;
				_managmentPicker.y		= 0;
			}
		}
		
		protected override function paint(p_width:Number, p_height:Number):void
		{
			var horizontalLineMatrix	:Matrix		= new Matrix();
			var gradientMatrix			:Matrix		= new Matrix();
			var normalBorderAlpha		:Number		= 1;
			
			if (_title != null)
			{
				horizontalLineMatrix.createGradientBox(p_width, .1, 0, 0, 0);
				
				_titleSeparator.graphics.clear();
				_titleSeparator.graphics.lineStyle(.1, 0);
				
				_titleSeparator.graphics.lineGradientStyle
				(
					GradientType.LINEAR, 
					[0x000000, 0xFFFFFF, 0x000000], 
					[0, 1, 0], 
					[0, 128, 255], 
					horizontalLineMatrix
				);
				
				_titleSeparator.graphics.drawRect(0, 0, p_width, 0.1);
			}
			
//			with (_fieldsHolder.graphics)
//			{
//				clear();
//				beginFill(0x000000, 0.0);
//				drawRect(0, 0, _fieldsHolder.width, _fieldsHolder.height);
//				endFill();
//			}
			
			if (_background == null)
			{
				return;
			}
			
			with (_background)
			{
				graphics.clear();
				gradientMatrix.createGradientBox
				(
					p_width, 
					p_height, 
					UmlViewControler.toRadians(90)
				);
				graphics.beginGradientFill
				(
					GradientType.LINEAR, 
					[0x333333, 0x111111], 
					[1, 1], 
					[0, 255], 
					gradientMatrix
				);
				graphics.drawRoundRect(0, 0, p_width, p_height, 2, 2);
				graphics.endFill();
				
				if (_isCustomBorderAllowed)
				{
					normalBorderAlpha = 1.0;
				}
				
				graphics.lineStyle(1, 0x444444, normalBorderAlpha);
				graphics.drawRoundRect(0, 0, p_width, p_height, 2, 2);
			}
		}
		
		public override function set name(value:String):void
		{
			super.name = value;
			_isTitleDirty = true;
			updateContent();
		}
		
		/**
		 * TODO : explain
		 * @param value
		 */
		public override function setSelected(value:Boolean):void
		{
			super.setSelected(value);
			
			if (_resizer == null)
			{
				return;
			}
			
			if (_isSelected)
			{
				_resizer.showResizer();
			}
			else
			{
				_resizer.hideResizer();
			}
		}
		
		public override function dispose() : void
		{
			if (_resizer != null)
			{
				_resizer.destroyResizer();
				_resizer = null;
			}
			
			_border						= null;
			_title						= null;
			_titleSeparator				= null;
			_titleMask					= null;
			_rectangle					= null;
			
			_fieldsHolder				= null;
			_fieldsMask					= null;
			_background					= null;
			
			_umlAddActionContextMenu	= null;
			_managmentPicker		= null;
			_selectedFields				= null;
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
				if (UmlSelectionControler.getInstance().getSelectedClasses().length > 1)
				{
					var selectedDiagram:UmlViewDiagram = UmlControler.getInstance().getSelectedDiagram();
					
					if (selectedDiagram.contains(this))
					{
						if (selectedDiagram.isSelectorBusy())
						{
							UmlControler.getInstance().getSelectedDiagram().swapToDiagram
							(
								UmlSelectionControler.getInstance().getSelectedClasses()
							);
						}
						UmlControler.getInstance().getSelectedDiagram().swapToMove
						(
							UmlSelectionControler.getInstance().getSelectedClasses()
						);
					}
					UmlControler.getInstance().getSelectedDiagram().getSelector().startDrag();
				}
				else
				{
					startDrag();
				}
			}
		}
		
		protected override function onMouseUp(e:MouseEvent):void
		{
			super.onMouseUp(e);
			
			if (UmlControler.getInstance().getMode() == "normal")
			{
				if (UmlSelectionControler.getInstance().getSelectedClasses().length > 1)
				{
					UmlControler.getInstance().getSelectedDiagram().getSelector().stopDrag();
				}
				else
				{
					stopDrag();
				}
			}
		}
		
		/*******************************************************************************************
		 * 
		 * regular functions 
		 * 
		 ******************************************************************************************/
		
		
		public function getRectangle():Rectangle
		{
			return _rectangle;
		}
		
		/**
		 * override in subClasses.
		 */
		public function requestAddField():void
		{
			
		}
		
		/**
		 * TODO : explain
		 */
		public function requestEditField():void
		{
			if (_selectedFields == null || _selectedFields.length == 0)
			{
				return;
			}
			
			var umlField:UmlViewField = null;
			
			// on vérifie s'il y a bien un seul élément dans le tableau 
			// champs pour l'éditer.
			if (_selectedFields.length == 1)
			{
				umlField = _selectedFields[0];
			}
			
			// faut bien un test de nullité.
			if (umlField != null)
			{
				umlField.requestEdit();
			}
		}
		
		/**
		 * TODO : explain
		 */
		public function requestDeleteField():void
		{
			deleteSelectedFields(); // tout court 
			
//			var alert:Alert = Alert.show
//			(
//				"Etes-vous sur de vouloir supprimer ces champs ?", 
//				"Suppression", 
//				Alert.YES | Alert.NO, 
//				UmlControler.getInstance().getSelectedProjectWorkspace(), 
//				onAlertClosed, 
//				null
//			);
		}
		
		protected function onAlertClosed(e:CloseEvent):void
		{
			switch (e.detail)
			{
				case Alert.YES :
					deleteSelectedFields();
				break;
				case Alert.NO : 
					// rien 
				break;
			}
		}
		
		/**
		 * TODO : explain
		 * @param umlField
		 */
		protected function addField(umlField:UmlViewField):void
		{
			if (_fieldsHolder == null || umlField == null)
			{
				return;
			}
			
			_numFields++;
			_fieldsHolder.addChild(umlField);
			
			umlField.addEventListener(UmlEvent.ELEMENT_SELECTED,			onFieldSelected);
			umlField.addEventListener(UmlEvent.ELEMENT_DESELECTED,			onFieldDeselected);
			umlField.addEventListener(UmlEvent.SELECT_ALL_REQUESTED,	onSelectAllRequested);
		}
		
		/**
		 * TODO : explain
		 */
		protected function deleteSelectedFields():void
		{
			var selectedFields:Array = UmlSelectionControler.getInstance().getSelectedFeatures();
			for (var i:uint = 0; i < selectedFields.length; i++)
			{
				var field:UmlViewField = selectedFields[i] as UmlViewField;
				if (field.getParentId() == this.uid)
				{
					UmlControler.getInstance().removeNode(this.uid, field.uid);
				}
			}
		}
		
		/**
		 * TODO : explain
		 * @param umlField
		 */
		protected function deleteField(umlField:UmlViewField):void
		{
			if (_fieldsHolder == null || umlField == null)
			{
				return;
			}
			
			_numFields--;
			
			umlField.removeEventListener(UmlEvent.ELEMENT_SELECTED, onFieldSelected);
			umlField.removeEventListener(UmlEvent.ELEMENT_SELECTED, onFieldDeselected);
			
			UmlSelectionControler.getInstance().deselectElement(umlField);
			_fieldsHolder.removeChild(umlField);
		}
		
		protected function paintFieldsMask(p_width:Number, p_height:Number):void
		{
			if (_fieldsMask == null)
			{
				return;
			}
			
			with (_fieldsMask.graphics)
			{
				clear();
//				beginFill(0xFFFFFF, 0.3);
				beginFill(0x000000, 0.0);
				drawRoundRect(0, 0, p_width, p_height - _fieldsMask.y, 2, 2);
				endFill();
			}
		}
		
		protected function paintTitleMask(p_width:Number, p_height:Number):void
		{
			if (_titleMask == null)
			{
				return;
			}
			
			with (_titleMask.graphics)
			{
				clear();
				beginFill(0x000000, 0.0);
				drawRoundRect(0, 0, p_width, p_height/*  - _titleSeparator.y */, 2, 2);
				endFill();
			}
		}
		
		protected function paintCustomBorder(p_width:Number, p_height:Number):void
		{
			if (_border == null)
			{
				return;
			}
			
			var horizontalLineMatrix:Matrix = new Matrix();
			horizontalLineMatrix.createGradientBox(p_width, .1, 0, 0, 0);
			
			_border.graphics.clear();
			_border.graphics.lineStyle(.1, 0);
			_border.graphics.lineGradientStyle
			(
				GradientType.LINEAR, 
				[0x000000, 0xFFFFFF, 0x000000], 
				[0, 1, 0], 
				[0, 128, 255], 
				horizontalLineMatrix
			);
			_border.graphics.drawRect(0, 0, p_width, 0.1);
			_border.graphics.drawRect(0, p_height, p_width, 0.1);
			
			var verticalLineMatrix:Matrix = new Matrix();
			verticalLineMatrix.createGradientBox(0.1, p_height, UmlViewControler.toRadians(90));
			_border.graphics.lineGradientStyle
			(
				GradientType.LINEAR, 
				[0x000000, 0xFFFFFF, 0x000000], 
				[0, 1, 0], 
				[0, 128, 255], 
				verticalLineMatrix
			);
			_border.graphics.drawRect(0, 0, 0.1, p_height);
			_border.graphics.drawRect(p_width, 0, 0.1, p_height);
		}
		
		public function setCustomBorderAllowed(permission:Boolean):void
		{
			_isCustomBorderAllowed = permission;
			invalidateDisplayList();
		}
		public function isCustonBorderAllowed():Boolean
		{
			return _isCustomBorderAllowed;
		}
		
		protected override function updateContent() : void
		{
			super.updateContent();
			
			if (_title == null)
			{
				return;
			}
			
			_title.setText(name);
		}
		
		/*******************************************************************************************
		 * 
		 * business callback functions 
		 * 
		 ******************************************************************************************/
		
		protected function onFieldAdded(e:UmlEvent):void
		{
			// mise à jour
			updateContent();
		}
		
		protected function onFieldEdited(e:UmlEvent):void
		{
			// mise à jour de l'xml du regular node.
			updateContent();
		}
		
		/**
		 * TODO : explain
		 * @param e
		 */
		protected function onFieldSelected(e:UmlEvent):void
		{
			if (_selectedFields == null)
			{
				return;
			}
			
			_selectedFields.push(e.getSelectedElement());
			
			// activer les buttons delete et edit 
			// (le "edit" est selon le nombre de fields 
			// séléctionnés qui doit être égale à 1) 
			if (_selectedFields.length == 1)
			{
				activateEditOperation();
			}
			else
			{
				deactivateEditOperation();
			}
			
			if (_selectedFields.length > 0)
			{
				activateDeleteOperation();
			}
			
			// this instruction help us to select this node when 
			// its children are selected, if we do not set 
			// the Control Key to down, the children will be deselected. 
			UmlSelectionControler.setCtrlKeyDown(true);
			UmlSelectionControler.getInstance().selectElement(this);
		}
		
		protected function onFieldDeselected(e:UmlEvent):void
		{
			if (_selectedFields == null)
			{
				return;
			}
			
			delete _selectedFields.splice(_selectedFields.indexOf(e.getSelectedElement()), 1);
			
			// désactiver les buttons delete et edit du NodeManagmentPicker 
			// toujours selon le nombre de fields séléctionnés. 
			if (_selectedFields.length == 0)
			{
				deactivateDeleteOperation();
				deactivateEditOperation();
			}
		}
		
		public function activateEditOperation():void
		{
			if (_editFieldButton == null)
			{
				return;
			}
			
			_editFieldButton.enabled = true;
		}
		public function deactivateEditOperation():void
		{
			if (_editFieldButton == null)
			{
				return;
			}
			
			_editFieldButton.enabled = false;
		}
		
		public function activateDeleteOperation():void
		{
			if (_deleteFieldButton == null)
			{
				return;
			}
			
			_deleteFieldButton.enabled = true;
		}
		public function deactivateDeleteOperation():void
		{
			if (_deleteFieldButton == null)
			{
				return;
			}
			
			_deleteFieldButton.enabled = false;
		}
		
		/**
		 * TODO : explain
		 * @param e
		 * 
		 */
		protected override function onElementDeleted(e:UmlEvent) : void
		{
			if (_fieldsHolder == null)
			{
				return;
			}
			var field:UmlViewField = null;
			var isFieldFound:Boolean = false;
			var i:uint = 0;
			
			for (i = 0; i < _numFields && !isFieldFound; i++)
			{
				field = _fieldsHolder.getChildAt(i) as UmlViewField;
				
				if (field.uid == e.getDeletedNode().uid)
				{
					isFieldFound = true;
					deleteField(field);
				}
			}
			
			// mise à jour de l'xml du regular node.
			updateContent();
		}
		
		protected function onViewFormReady(e:UmlEvent):void
		{
			
		}
		
		protected function onUmlActionCanceled(e:UmlEvent):void
		{
			UmlModel.getInstance().removeEventListener(UmlEvent.ELEMENT_EDITED, onEdited);
		}
		
		/***********************************************************************
		 * 
		 * callback functions 
		 * 
		 **********************************************************************/
		
		protected function onClick(e:MouseEvent):void
		{
			if (_titleSeparator == null)
			{
				return;
			}
			
			// tester sur le mouseX et mouseY pour éviter le cas du click sur
			// le managmentPicker qui est considéré comme un click sur la classe
			if (mouseX < width && mouseY > _titleSeparator.y)
			{
				if (_selectedFields.length > 0 && !UmlSelectionControler.isCtrlKeyDown())
				{
					UmlSelectionControler.getInstance().deselectFields();
				}
			}
		}
		
	}
	
}
