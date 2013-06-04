package view.newView.associations
{
	
	import controler.UmlControler;
	import controler.UmlSelectionControler;
	import controler.UmlViewControler;
	import controler.events.UmlAssociationEvent;
	import controler.events.UmlEvent;
	import controler.events.UmlViewEvent;
	
	import flash.display.CapsStyle;
	import flash.display.DisplayObject;
	import flash.display.JointStyle;
	import flash.display.LineScaleMode;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import model.IUmlModelAssociation;
	import model.IUmlModelElement;
	import model.UmlModelLiteralInteger;
	
	import mx.containers.Canvas;
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	import mx.events.ResizeEvent;
	
	import view.core.UmlAlert;
	import view.core.UmlViewAssociationClassLine;
	import view.core.UmlViewEditableField;
	import view.core.UmlViewSolidLine;
	import view.newView.AioViewContextMenuItem;
	import view.newView.UmlViewClassifier;
	import view.newView.UmlViewDiagram;
	import view.newView.UmlViewElement;
	import view.panels.UmlViewAssociationEndForm;
	import view.panels.UmlViewAssociationForm;
	
	
	/**
	 * 
	 * @author kamal
	 */
	public class UmlViewAssociation extends UmlViewElement
	{
		
		public static const ARROW_SIZE		:Number		= 10;
		
		protected var _ownerDiagram			:UmlViewDiagram			= null;
		
		/**
		 * if this array is still null, that means that there's no other 
		 * node between the 2 normal sides (_side1 & _side2).
		 */
		[ArrayElementType("view.newView.UmlViewClassifier")]
		protected var _classifiers			:Array					= null;
		
		/**
		 * business fields ;)
		 */
		[ArrayElementType("view.newView.associations.UmlViewAssociationEnd")]
		protected var _ends					:Array					= null;
		
		[ArrayElementType("view.newView.associations.UmlViewAssociationEnd")]
		protected var _selectedEnds			:Array					= null;
		
		
		/**
		 * this point represents the connection point between 
		 * this association and association class's line.
		 */
		protected var _associationClassPoint	:Point					= null;
		protected var _associationClassLine:UmlViewAssociationClassLine	= null;
		
		protected var _associationName		:UmlViewEditableField	= null;
		
		protected var _isAssociationNameSelected	:Boolean		= false;
		protected var _associationNameMargin		:Number			= 20;
		
		protected var _areEndsAllowed				:Boolean		= false;
		
		/**
		 * this is the graphic line drawn to link the sides.
		 * it will be different depending of what kind of association it represent.
		 */
		protected var _line					:UmlViewSolidLine		= null;
		protected var _firstArrow			:Sprite					= null;
		protected var _lastArrow			:Sprite					= null;
		
		protected var _isUsingFilledArrow	:Boolean				= false;
		protected var _isUsingClosedArrow	:Boolean				= false;
		
		protected var _isSidePressed		:Boolean				= false;
		
		/**
		 * contextMenu items
		 */
		protected var _itemAssociationName		:AioViewContextMenuItem	= null;
		protected var _itemEndsNames			:AioViewContextMenuItem	= null;
		protected var _itemEndsMultiplicities	:AioViewContextMenuItem	= null;
		
		protected var _temoin					:Canvas					= null;
		
		
		
		
		/**
		 * 
		 */
		public function UmlViewAssociation(umlParent:UmlViewDiagram)
		{
			super(null, umlParent.uid);
			
			
			_ownerDiagram		= umlParent;
			_classifiers		= new Array();
			_ends				= new Array();
			_selectedEnds		= new Array();
			
			_isKeyboardAllowed					= true;
			_isSuperDragAllowed					= false;
			_isClipboardOperationsAllowed		= true;
			_isStopMouseEventPropagationAllowed	= true;
			_areEndsAllowed						= true;
			
			initNodesListeners();
		}
		
		public function get modelAssociation():IUmlModelAssociation
		{
			if (modelElement != null && modelElement is IUmlModelAssociation)
			{
				return modelElement as IUmlModelAssociation;
			}
			
			return null;
		}
		
		/***********************************************************************
		 * 
		 * overriden functions 
		 * 
		 **********************************************************************/
		
		protected override function createChildren():void
		{
			super.createChildren();
			
			// création des flêches de l'association 
			createFirstArrow();
			createLastArrow();
		}
		
		protected override function createContextMenuAdditionalItems():void
		{
			super.createContextMenuAdditionalItems();
			
			if (_contextMenuItems != null)
			{
				_itemAssociationName	= new AioViewContextMenuItem("Association Name");
				
				_contextMenuItems.push("-");
				_contextMenuItems.push(_itemAssociationName);
				
				if (_areEndsAllowed)
				{
					_itemEndsNames			= new AioViewContextMenuItem("Ends Names");
					_itemEndsMultiplicities	= new AioViewContextMenuItem("Ends Multiplicities");
					
					_contextMenuItems.push(_itemEndsNames);
					_contextMenuItems.push(_itemEndsMultiplicities);
				}
			}
		}
		
		protected override function initContextMenuListeners():void
		{
			super.initContextMenuListeners();
			
			_itemAssociationName.addEventListener(MouseEvent.CLICK,		onItemAssociationNameClick);
			
			if (_areEndsAllowed)
			{
				_itemEndsNames.addEventListener(MouseEvent.CLICK,			onItemEndsNamesClick);
				_itemEndsMultiplicities.addEventListener(MouseEvent.CLICK,	onItemEndMultiplicitiesClick);
			}
		}
		
		protected function onItemAssociationNameClick(event:MouseEvent):void
		{
			createName();
		}
		
		protected function onItemEndsNamesClick(event:MouseEvent):void
		{
			createEnds();
		}
		
		protected function onItemEndMultiplicitiesClick(event:MouseEvent):void
		{
			
		}
		
		protected override function onItemPropertiesClick(event:MouseEvent):void
		{
			editUsingForm();
		}
		
		protected function editUsingForm():void
		{
			var associationForm:UmlViewAssociationForm = null;
			var umlAlert:UmlAlert = null;
			
			associationForm = new UmlViewAssociationForm();
			
			associationForm.addEventListener(UmlEvent.VIEW_FIELD_FORM_READY,	onViewFormReady);
			associationForm.addEventListener(UmlEvent.UML_ACTION_CANCELED,		onUmlActionCanceled);
			
			umlAlert = new UmlAlert(associationForm);
			umlAlert.show();
			associationForm.setAssociation(this);
		}
		
		protected function onViewFormReady(event:UmlEvent):void
		{
			var associationForm		:UmlViewAssociationForm		= null;
			var associationEndForms	:Array						= null;
			var associationEndForm	:UmlViewAssociationEndForm	= null;
			
			if (event.currentTarget is UmlViewAssociationForm)
			{
				associationForm = event.currentTarget as UmlViewAssociationForm;
				
				UmlControler.getInstance().editAssociation
				(
					getParentId(),
					uid, 
					associationForm.getAssociationName()
				);
				
				associationForm.removeEventListener(UmlEvent.VIEW_FIELD_FORM_READY, onViewFormReady);
				
				// TODO : détruire le fieldform (dans la mémoire biensur)
			}
		}
		
		protected function onUmlActionCanceled(event:UmlEvent):void
		{
			
		}
		
		/**
		 * this function adds the association to the model
		 */
		protected function sendData():void
		{
			var parentElement		:IUmlModelElement	= _ownerDiagram.modelElement;
			var modelClassifiers	:Array				= new Array();
			var viewElement			:UmlViewElement		= null;
			var modelSide			:IUmlModelElement	= null;
			var i:int = 0;
			
			if (_classifiers.length == 2)
			{
				modelClassifiers.push((_classifiers[0] as UmlViewElement).modelElement);
				modelClassifiers.push((_classifiers[1] as UmlViewElement).modelElement);
			}
			
			else if (_classifiers.length > 2)
			{
				for (i = 0; i < _classifiers.length; i++)
				{
					modelClassifiers.push((_classifiers[i] as UmlViewElement).modelElement);
				}
			}
			else
			{
				//error
				//here we must create an UmlError to save it as a modeling error
				trace("UmlViewAssociation::sendData() classifiers array is incomplete");
			}
			
			for (i = 0; i < modelClassifiers.length; i++)
			{
				modelSide = modelClassifiers[i] as IUmlModelElement;
				initSidesModelListeners(modelSide);
			}
			
			_ownerDiagram.modelElement.addEventListener(UmlAssociationEvent.ASSOCIATION_ADDED, onAdded);
			UmlControler.getInstance().addAssociation("", modelClassifiers);
		}
		
		protected function onAdded(e:UmlEvent):void
		{
			if (e.getAddedElement() is IUmlModelAssociation)
			{
				_modelElement = e.getAddedElement();
				
				modelAssociation.addEventListener
				(
					UmlAssociationEvent.ASSOCIATION_END_ADDED, 
					onAssociationEndAdded
				);
				
				updateContent();
			}
			
			_ownerDiagram.modelElement.removeEventListener
			(
				UmlAssociationEvent.ASSOCIATION_ADDED, 
				onAdded
			);
		}
		
		protected function onAssociationEndAdded(e:UmlAssociationEvent):void
		{
			var associationEnd:UmlViewAssociationEnd = null;
			
			associationEnd = new UmlViewAssociationEnd(e.getAddedElement(), uid, this);
			
			associationEnd.addEventListener(UmlEvent.ELEMENT_SELECTED,		onAssociationEndSelected);
			associationEnd.addEventListener(UmlEvent.ELEMENT_DESELECTED,	onAssociationEndDeselected);
			
			_ends.push(associationEnd);
			addChild(associationEnd);
			
			if (_ends.length == 1)
			{
				paintFirstArrow();
				updateFirstArrowPositionAndRotation();
			}
			else if (_ends.length == 2)
			{
				paintLastArrow();
				updateLastArrowPositionAndRotation();
			}
			
			updateEndsPositions();
		}
		
		protected function onAssociationEndSelected(event:UmlEvent):void
		{
			_selectedEnds.push(event.getSelectedElement());
		}
		
		protected function onAssociationEndDeselected(event:UmlEvent):void
		{
			var index:int = _selectedEnds.indexOf(event.getDeselectedElement());
			
			if (index >= 0)
			{
				_selectedEnds.splice(index, 1);
			}
		}
		
		protected function initSidesModelListeners(element:IUmlModelElement):void
		{
			if (_ownerDiagram != null)
			{
				element.addEventListener(UmlEvent.DELETED, onNodeDeleted);
			}
		}
		
		protected function removeSidesModelListeners(element:IUmlModelElement):void
		{
			if (_ownerDiagram != null)
			{
				element.removeEventListener(UmlEvent.DELETED, onNodeDeleted);
			}
		}
		
		/**
		 * il faut juste supprimer cette association du model 
		 * pour qu'elle soit supprimée aussi dans la vue (diagramme)
		 */
		protected function onNodeDeleted(e:UmlEvent):void
		{
			UmlSelectionControler.getInstance().deselectElement(this);
			UmlControler.getInstance().removeNode(_parentUID, uid);
			removeSidesModelListeners(e.target as IUmlModelElement);
		}
		
		public override function requestEdit():void
		{
			super.requestEdit();
			
			if (_associationName != null && _associationName.isSelected())
			{
				_associationName.activate();
			}
			else
			{
				editUsingForm();
			}
		}
		
		public override function setSelected(value:Boolean):void
		{
			super.setSelected(value);
			
			if (_isSelected)
			{
				select();
			}
			else
			{
				deselect();
			}
		}
		
		protected override function onDeselected(event:UmlEvent):void
		{
			super.onDeselected(event);
			
			//à réctifier plus tard
			if (modelAssociation != null && _associationName != null)
			{
				//à discuter plus tard
				editAssociationName();
				_associationName.deactivate();
			}
		}
		
		public override function dispose():void
		{
			var element	:UmlViewElement	= null;
			var i		:int			= 0;
			
			removeNodesListeners();
			removeElementSwappingListeners();
			
			for (i = 0; i < _classifiers.length; i++)
			{
				element = _classifiers[i] as UmlViewElement;
				removeSideListeners(element);
			}
			
			element = null;
			
			_line.dispose();
			
			if (_associationClassLine != null)
			{
				_associationClassLine.dispose();
			}
			
			_classifiers			= null;
			_firstArrow				= null;
			_lastArrow				= null;
			_associationClassPoint	= null;
			_associationClassLine	= null;
			_line					= null;
			_ownerDiagram			= null;
		}
		
		/***********************************************************************
		 * 
		 * regular functions 
		 * 
		 **********************************************************************/
		
		protected function createName():void
		{
			if (_associationName == null)
			{
				_associationName = new UmlViewEditableField(modelAssociation.name);
				_associationName.deactivate();
				
				_associationName.addEventListener(UmlViewEvent.ACTIVATED,	onAssociationNameActivated);
				_associationName.addEventListener(UmlViewEvent.DEACTIVATED,	onAssociationNameDeactivated);
				_associationName.addEventListener(UmlViewEvent.CREATED,		onAssociationNameCreated);
				
				addChild(_associationName);
			}
		}
		
		protected function onAssociationNameActivated(event:UmlViewEvent):void
		{
			if (_associationName != null)
			{
				_associationName.addEventListener(UmlViewEvent.DONE,	onAssociationNameDone);
				_associationName.addEventListener(UmlViewEvent.CANCEL,	onAssociationNameCancel);
			}
		}
		
		protected function onAssociationNameDeactivated(event:UmlViewEvent):void
		{
			if (_associationName != null)
			{
				_associationName.removeEventListener(UmlViewEvent.DONE,		onAssociationNameDone);
				_associationName.removeEventListener(UmlViewEvent.CANCEL,	onAssociationNameCancel);
			}
			
			updateAssociationNamePosition();
		}
		
		protected function onAssociationNameDone(event:UmlViewEvent):void
		{
			setFocus();
			updateAssociationNamePosition();
			editAssociationName();
			
			if (_associationName != null)
			{
				_associationName.deactivate();
			}
		}
		
		protected function onAssociationNameCancel(event:UmlViewEvent):void
		{
			setFocus();
			updateAssociationNamePosition();
			
			if (_associationName != null)
			{
				_associationName.deactivate();
			}
		}
		
		protected function onAssociationNameCreated(event:UmlViewEvent):void
		{
			if (_temoin != null)
			{
				_temoin.setStyle("backgroundColor", 0xFF5500);
				_temoin.width	= 10;
				_temoin.height	= 10;
				
				addChild(_temoin);
			}
			
			if (_associationName != null)
			{
				_associationName.x = _line.getLineCentralPoint().x - _associationName.width/2;
				_associationName.y = _line.getLineCentralPoint().y;
				
				updateAssociationNamePosition();
			}
		}
		
		protected function updateAssociationNamePosition():void
		{
			var centralPoint:Point = _line.getLineCentralPoint();
			
			if (centralPoint != null && _temoin != null)
			{
				_temoin.x = centralPoint.x - _temoin.width/2;
				_temoin.y = centralPoint.y - _temoin.height/2;
			}
			
			if (centralPoint != null && _associationName != null)
			{
				_associationName.x = centralPoint.x - _associationName.width / 2;
				_associationName.y = centralPoint.y;
			}
		}
		
		protected function editAssociationName():void
		{
			if (_associationName != null)
			{
				UmlControler.getInstance().editAssociation
				(
					getParentId(), 
					uid, 
					_associationName.text
				);
			}
		}
		
		protected function createEnds():void
		{
			if (_ends != null && _ends.length == 0)
			{
				var lowerMultiplicity:UmlModelLiteralInteger = new UmlModelLiteralInteger("","");
				lowerMultiplicity.value = 1;
				
				UmlControler.getInstance().addAssociationEnd
				(
					uid, 
					"unnamed", 
					"private", 
					(_classifiers[0] as UmlViewElement).uid, 
					true, 
					[lowerMultiplicity, null]
				);
				
				lowerMultiplicity		= new UmlModelLiteralInteger("","");
				lowerMultiplicity.value	= 1;
				
				UmlControler.getInstance().addAssociationEnd
				(
					uid, 
					"unnamed", 
					"private", 
					(_classifiers[1] as UmlViewElement).uid, 
					true, 
					[lowerMultiplicity, null]
				);
			}
		}
		
		protected function createMultiplicities():void
		{
			var lower	:UmlModelLiteralInteger	= null;
			var end		:UmlViewAssociationEnd	= null;
			
			for each (end in _ends)
			{
				lower = new UmlModelLiteralInteger("","");
				lower.value = 1;
				end.modelMultiplicityElement.lowerValue = lower;
			}
			
			//var zero	:UmlModelLiteralInteger = new UmlModelLiteralInteger("", "");
			//var infini	:UmlModelLiteralUnlimitedNatural = new UmlModelLiteralUnlimitedNatural("", "");
			
			//zero.value		= 1;
			//infini.value	= "*";
			
			//(associationEnd as IUmlModelMultiplicityElement).lowerValue = zero;
			//(associationEnd as IUmlModelMultiplicityElement).upperValue = infini;
			
		}
		
		protected function createLine():UmlViewSolidLine
		{
			return new UmlViewSolidLine();
		}
		
		protected function createFirstArrow():void
		{
			_firstArrow = new Sprite();
			addChild(_firstArrow);
			paintFirstArrow();
		}
		
		protected function createLastArrow():void
		{
			_lastArrow = new Sprite();
			addChild(_lastArrow);
			paintLastArrow();
		}
		
		protected function destroyFirstArrow():void
		{
			removeChild(_firstArrow);
			_firstArrow = null;
		}
		
		protected function destroyLastArrow():void
		{
			removeChild(_lastArrow);
			_lastArrow = null;
		}
		
		/**
		 * this function paints the association's last arrow 
		 * in its extremly first side.
		 * 
		 * must be overriden in subclasses
		 */
		protected function paintFirstArrow():void
		{
			var firstEnd:UmlViewAssociationEnd = null;
			
			if (_ends != null && _ends.length > 0)
			{
				if (_ends.length >= 0 )
				{
					firstEnd = _ends[0] as UmlViewAssociationEnd;
				}
				
				if (firstEnd != null && firstEnd.modelFeature.isNavigable())
				{
					drawArrow(_firstArrow);
				}
			}
		}
		
		protected function drawArrow(arrow:Sprite):void
		{
			var coordinateSystem:Point = null;
			coordinateSystem = new Point(0, 0);
			
			with (arrow.graphics)
			{
				clear();
				lineStyle
				(
					0.25, 0xFFFFFF, 1, false, LineScaleMode.NORMAL, 
					CapsStyle.ROUND, JointStyle.ROUND
				);
				
				if (_isUsingFilledArrow)
				{
					beginFill(0x222222, 1);
				}
				
				moveTo(coordinateSystem.x - ARROW_SIZE, coordinateSystem.y - ARROW_SIZE/2);
				lineTo(coordinateSystem.x, coordinateSystem.y);
				lineTo(coordinateSystem.x - ARROW_SIZE, coordinateSystem.y + ARROW_SIZE/2);
				
				if (_isUsingFilledArrow)
				{
					endFill();
				}
			}
		}
		
		/**
		 * this function paints the association's last arrow 
		 * in its extremly second side.
		 */
		protected function paintLastArrow():void
		{
			var lastEnd:UmlViewAssociationEnd = null;
			
			if (_ends != null && _ends.length > 0)
			{
				if (_ends.length == 2 )
				{
					lastEnd = _ends[1] as UmlViewAssociationEnd;
				}
				
				if (lastEnd != null && lastEnd.modelFeature.isNavigable())
				{
					drawArrow(_lastArrow);
				}
			}
		}
		
		protected function select():void
		{
			if (_line == null)
			{
				return;
			}
			
			_line.selectLine();
		}
		
		protected function deselect():void
		{
			if (_line == null)
			{
				return;
			}
			
			_line.deselectLine();
		}
		
		protected function initNodesListeners():void
		{
			var viewNodes	:Array			= null;
			var child		:DisplayObject	= null;
			var i			:uint			= 0;
			
			viewNodes = _ownerDiagram.getViewNodes();
			
			for (i = 0; i < viewNodes.length; i++)
			{
				child = viewNodes[i];
				
				if (child is UmlViewClassifier || child is UmlViewAssociation)
				{
					child.addEventListener(MouseEvent.MOUSE_DOWN,	onListenerMouseDown);
					child.addEventListener(MouseEvent.MOUSE_UP,		onListenerMouseUp);
				}
			}
			
			_ownerDiagram.addEventListener(MouseEvent.MOUSE_UP, onDiagramListenerMouseUp);
		}
		
		protected function removeNodesListeners():void
		{
			var viewNodes	:Array			= null;
			var child		:DisplayObject	= null;
			var i			:uint			= 0;
			
			viewNodes = _ownerDiagram.getViewNodes();
			
			for (i = 0; i < viewNodes.length; i++)
			{
				child = viewNodes[i];
				
				if (child is UmlViewClassifier || child is UmlViewAssociation)
				{
					child.removeEventListener(MouseEvent.MOUSE_DOWN,	onListenerMouseDown);
					child.removeEventListener(MouseEvent.MOUSE_UP,		onListenerMouseUp);
				}
			}
		}
		
		public function setAssociationClassLine(associationClassLine:UmlViewAssociationClassLine):void
		{
			if (associationClassLine)
			{
				_associationClassLine = associationClassLine;
			}
		}
		
		protected function updateAssciationEndsPositions(
										end			:UmlViewAssociationEnd, 
										point		:Point, 
										position	:uint):void
		{
			var finalX:Number = 0;
			var finalY:Number = 0;
			
			if (end != null)
			{
				end.setPosition(position);
				end.x = point.x;
				end.y = point.y;
			}
		}
		
		protected function updateFirstArrowPositionAndRotation():void
		{
			var firstPoint	:Point = null;
			var secondPoint	:Point = null;
			
			if (_line == null)
			{
				return;
			}
			
			if (_firstArrow != null)
			{
				firstPoint	= _line.getFirstPoint();
				secondPoint	= _line.getSecondPoint();
				
				if (firstPoint != null)
				{
					_firstArrow.x	= firstPoint.x;
					_firstArrow.y	= firstPoint.y;
				}
				
				if (firstPoint != null && secondPoint != null)
				{
					_firstArrow.rotation = UmlViewControler.getAngle
					(
						_line.getSecondPoint(), 
						_line.getFirstPoint()
					);
				}
			}
		}
		
		protected function updateLastArrowPositionAndRotation():void
		{
			var beforeLastPoint	:Point	= null;
			var lastPoint		:Point	= null;
			
			if (_line == null)
			{
				return;
			}
			
			if (_lastArrow != null)
			{
				beforeLastPoint	= _line.getBeforeLastPoint();
				lastPoint		= _line.getLastPoint();
				
				if (lastPoint != null)
				{
					_lastArrow.x	= _line.getLastPoint().x;
					_lastArrow.y	= _line.getLastPoint().y;
				}
				
				if (lastPoint != null && beforeLastPoint != null)
				{
					_lastArrow.rotation = UmlViewControler.getAngle
					(
						_line.getBeforeLastPoint(), 
						_line.getLastPoint()
					);
				}
			}
		}
		
		public function getLine():UmlViewSolidLine
		{
			return _line;
		}
		
		public function getAssociationClassPoint():Point
		{
			if (_line == null)
			{
				return null;
			}
			
			return _line.getLineCentralPoint();
		}
		
		public function getViewEnds():Array
		{
			return _ends;
		}
		
		/**
		 * cette fonction permet de démarrer la création de l'association 
		 * en procédant directement par l'exécution de l'événement MOUSE_DOWN.
		 * 
		 * @param firstSide
		 */
		public function processCreation(firstSide:UmlViewElement):void
		{
			if (_classifiers == null || _classifiers.length > 0)
			{
				_classifiers = new Array();
			}
			
			_classifiers.push(firstSide);
			
			onListenerMouseDown();
		}
		
		/**
		 * dans un premier temps, tous les éléments susceptibles d'être attaché
		 * à l'association sont appelés Listeners, parce qu'ils ont tous un 
		 * écouteur qui écoute le MouseDown et le MouseUp.
		 */
		protected function onListenerMouseDown(e:MouseEvent=null):void
		{
			if (UmlControler.getInstance().getMode() == "association")
			{
				var side:UmlViewElement = null;
				
				_ownerDiagram.addEventListener(MouseEvent.MOUSE_MOVE, onParentMouseMove);
				
				if (e != null)
				{
					side = e.currentTarget as UmlViewElement;
					_classifiers.push(side);
				}
				else if (_classifiers.length == 1)
				{
					side = _classifiers[0] as UmlViewElement;
				}
				
				initSideListeners(side);
				
				_line = createLine();
				_line.setLineTickness(1);
				_line.setLineColor(0xCCCCCC);
				_line.setFirstPoint(side.x + side.width/2, side.y + side.height/2);
				_line.setLastPoint(_ownerDiagram.mouseX, _ownerDiagram.mouseY);
				
				_line.addEventListener(UmlViewEvent.LINE_UPDATED,		onLineUpdated);
				_line.addEventListener(UmlViewEvent.LINE_POINT_REMOVED,	onLinePointRemoved);
				_line.addEventListener(UmlViewEvent.LINE_SIDE_POINT_CHANGE_BEGIN,	onLineSidePointChangeBegin);
				
//				initLineListeners();
				
				// 
				// we add the _line to this view node, and then we add this node 
				// to the parent (the diagram)
				// 
				addChild(_line);
				_ownerDiagram.addChildAt(this, 0);
			}
		}
		
		protected function onLineUpdated(event:UmlViewEvent):void
		{
			updateLine();
		}
		
		protected function onLinePointRemoved(event:UmlViewEvent):void
		{
			updateLine();
		}
		
		protected function onLineSidePointChangeBegin(event:UmlViewEvent):void
		{
			//TODO : complete the stuff
			
			var i			:int			= 0;
			var viewNodes	:Array			= null;
			var child		:UIComponent	= null;
			
			_line.addEventListener
			(
				UmlViewEvent.LINE_SIDE_POINT_CHANGE_END, 
				onLineSidePointChangeEnd
			);
			
			viewNodes = _ownerDiagram.getViewNodes();
			
			for (i = 0; i < viewNodes.length; i++)
			{
				child = viewNodes[i];
				
				if (child is UmlViewClassifier || child is UmlViewAssociation)
				{
					//child.removeEventListener(MouseEvent.MOUSE_UP,	onViewElementMouseUp);
				}
			}
		}
		
		protected function onLineSidePointChangeEnd(event:UmlViewEvent):void
		{
			
		}
		
		protected function updateLine():void
		{
			updateEndsPositions();
			updateAssociationNamePosition();
			updateFirstArrowPositionAndRotation();
			updateLastArrowPositionAndRotation();
		}
		
		protected function updateEndsPositions():void
		{
			if (_ends != null && _ends.length > 0)
			{
				updateAssciationEndsPositions
				(
					_ends[0], 
					_line.getFirstPoint(), 
					_line.getFirstEndPosition() 
				);
				
				if (_ends.length > 1)
				{
					updateAssciationEndsPositions
					(
						_ends[1], 
						_line.getLastPoint(), 
						_line.getLastEndPosition() 
					);
				}
			}
		}
		
		protected function onParentMouseMove(e:MouseEvent):void
		{
			if (_line == null)
			{
				return;
			}
			
			if (UmlControler.getInstance().getMode() == "association")
			{
				_line.setLastPoint(_ownerDiagram.mouseX, _ownerDiagram.mouseY);
			}
		}
		
		protected function initSideListeners(side:UIComponent):void
		{
			side.addEventListener(MouseEvent.MOUSE_DOWN,	onSideMouseDown);
			side.addEventListener(ResizeEvent.RESIZE,		onSideResize);
		}
		
		protected function removeSideListeners(side:UIComponent):void
		{
			side.removeEventListener(MouseEvent.MOUSE_DOWN,		onSideMouseDown);
			side.removeEventListener(ResizeEvent.RESIZE,		onSideResize);
		}
		
		protected function onElementsSwapped(e:UmlViewEvent):void
		{
			// search if some of the classifiers are swapped, else continue.
			var i		:int			= 0;
			var element	:UmlViewElement	= null;
			var found	:Boolean		= false;
			
			for (i = 0; i < _classifiers.length && !found; i++)
			{
				element = _classifiers[i] as UmlViewElement;
				
				if (e.swappedElements.indexOf(element) < 0)
				{
					found = true;
				}
			}
			
			if (found)
			{
				for (i = 0; i < e.swappedElements.length; i++)
				{
					element = e.swappedElements[i] as UmlViewElement;
					
					if (_classifiers.indexOf(element) < 0)
					{
						element.addEventListener(MouseEvent.MOUSE_DOWN,		onSideMouseDown);
						element.addEventListener(UmlEvent.ELEMENT_DESELECTED,	onElementDeselected);
					}
				}
			}
		}
		
		protected function onElementDeselected(e:UmlEvent):void
		{
			e.target.removeEventListener(MouseEvent.MOUSE_DOWN,		onSideMouseDown);
			e.target.removeEventListener(UmlEvent.ELEMENT_DESELECTED,	onElementDeselected);
		}
		
		protected function onSideMouseDown(e:MouseEvent):void
		{
			_isSidePressed = true;
			e.target.addEventListener(MouseEvent.MOUSE_MOVE,	onSideMouseMove);
			e.target.addEventListener(MouseEvent.MOUSE_UP,		onSideMouseUp);
		}
		
		protected function onSideMouseMove(e:MouseEvent):void
		{
			if (_line == null)
			{
				return;
			}
			
			//updateLine();
			
//			// if the associationClassLine is set we refresh its render
//			if (_associationClassLine != null)
//			{
//				_associationClassLine.refreshRender();
//			}
			
			e.updateAfterEvent();
		}
		
		protected function onSideMouseUp(e:MouseEvent):void
		{
			_isSidePressed = false;
			
			e.target.removeEventListener(MouseEvent.MOUSE_MOVE,	onSideMouseMove);
			e.target.removeEventListener(MouseEvent.MOUSE_UP,	onSideMouseUp);
		}
		
		protected function onSideResize(e:ResizeEvent):void
		{
			updateLine();
		}
		
		protected function onDiagramListenerMouseUp(event:MouseEvent):void
		{
			_ownerDiagram.removeEventListener(MouseEvent.MOUSE_UP, onDiagramListenerMouseUp);
			
			if (_ownerDiagram != null)
			{
				_ownerDiagram.addEventListener(UmlViewEvent.ELEMENT_ADDED, onClassAdded);
				UmlControler.getInstance().addClass();
			}
		}
		
		private function onClassAdded(event:UmlViewEvent):void
		{
			var addedClass:UmlViewElement = null;
			
			addedClass = event.addedElement;
			
			if (addedClass != null)
			{
				addedClass.addEventListener(FlexEvent.CREATION_COMPLETE, onAddedClassCreationComplete);
			}
			
			if (_ownerDiagram != null)
			{
				_ownerDiagram.removeEventListener(UmlViewEvent.ELEMENT_ADDED, onClassAdded);
			}
		}
		
		protected function onAddedClassCreationComplete(event:FlexEvent):void
		{
			var addedClass:UmlViewElement = event.currentTarget as UmlViewElement;
			
			finishCreation(addedClass);
			
			updateLine();
		}
		
		protected function onListenerMouseUp(e:MouseEvent):void
		{
			if (_line == null)
			{
				return;
			}
			
			_ownerDiagram.removeEventListener(MouseEvent.MOUSE_UP, onDiagramListenerMouseUp);
			
			if (UmlControler.getInstance().getMode() == "association" && 
				_classifiers != null && 
				_classifiers.length >= 1)
			{
				var side:UmlViewElement = e.currentTarget as UmlViewElement;
				finishCreation(side);
			}
		}
		
		protected function finishCreation(side:UmlViewElement):void
		{
			if (_line != null && side != null)
			{
				_line.setLastPoint
				(
					side.x + side.width / 2, 
					side.y + side.height / 2
				);
				
				_ownerDiagram.removeEventListener(MouseEvent.MOUSE_MOVE, onParentMouseMove);
				removeNodesListeners();
				
				initSideListeners(side);
				_classifiers.push(side);
				
				_line.setSides(_classifiers);
				
				UmlControler.getInstance().setMode("normal");
				
				updateLine();
				
				// here is the stuff 
				sendData();
				
				// listen to elements swapping
				initElementSwappingListeners();
			}
		}
		
		protected function initElementSwappingListeners():void
		{
			if (_ownerDiagram != null)
			{
				_ownerDiagram.addEventListener(UmlViewEvent.ELEMENTS_SWAPPED, onElementsSwapped);
			}
		}
		
		protected function removeElementSwappingListeners():void
		{
			if (_ownerDiagram != null)
			{
				_ownerDiagram.removeEventListener(UmlViewEvent.ELEMENTS_SWAPPED, onElementsSwapped);
			}
		}
		
	}
	
}
