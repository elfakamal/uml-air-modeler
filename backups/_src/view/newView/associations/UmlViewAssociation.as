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
	import flash.display.GradientType;
	import flash.display.JointStyle;
	import flash.display.LineScaleMode;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	import com.greensock.TweenMax;
	
	import model.IUmlModelAssociation;
	import model.IUmlModelElement;
	import model.UmlModelLiteralInteger;
	
	import mx.collections.ArrayCollection;
	import mx.containers.Canvas;
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	import mx.events.ResizeEvent;
	
	import view.core.UmlAlert;
	import view.core.UmlViewAssociationClassLine;
	import view.core.UmlViewEditableField;
	import view.core.UmlViewSolidLine;
	import view.newView.AioViewContextMenuItem;
	import view.newView.UmlViewDiagram;
	import view.newView.UmlViewElement;
	import view.newView.UmlViewRegularNode;
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
		[ArrayElementType("view.newView.UmlViewRegularNode")]
		protected var _classifiers			:Array					= null;
		
		/**
		 * business fields ;)
		 */
		[ArrayElementType("view.newView.associations.UmlViewAssociationEnd")]
		protected var _ends		:Array		= null;
		
		/**
		 * this point represents the connection point between 
		 * this association and association class's line.
		 */
		protected var _associationClassPoint	:Point					= null;
		protected var _associationClassLine:UmlViewAssociationClassLine	= null;
		
		protected var _associationName		:UmlViewEditableField	= null;
		protected var _isAssociationNameSelected:Boolean			= false;
		protected var _associationNameMargin:Number					= 20;
		
		/**
		 * this is the graphic line drawn to link the sides.
		 * it will be different depending of what kind of association it represent.
		 */
		protected var _line					:UmlViewSolidLine		= null;
		protected var _firstArrow			:Sprite					= null;
		protected var _lastArrow			:Sprite					= null;
		
		protected var _isUsingFilledArrow	:Boolean				= false;
		protected var _isUsingClosedArrow	:Boolean				= false;
		
		protected var newX					:Number = 0;
		protected var newY					:Number = 0;
		
		protected var _isSidePressed		:Boolean				= false;
		
		/**
		 * contextMenu items
		 */
		protected var _itemAssociationName		:AioViewContextMenuItem	= null;
		protected var _itemEndsNames			:AioViewContextMenuItem	= null;
		protected var _itemEndsMultiplicities	:AioViewContextMenuItem	= null;
		
		private var _temoin						:Canvas					= null;
		
		
		/**
		 * 
		 */
		public function UmlViewAssociation(umlParent:UmlViewDiagram)
		{
			super(null, umlParent.uid);
			
			_ownerDiagram		= umlParent;
			_classifiers		= new Array();
			_ends				= new Array();
			
			_isKeyboardAllowed					= true;
			_isSuperDragAllowed					= false;
			_isClipboardOperationsAllowed		= true;
			_isStopMouseEventPropagationAllowed	= true;
			
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
				_itemEndsNames			= new AioViewContextMenuItem("Ends Names");
				_itemEndsMultiplicities	= new AioViewContextMenuItem("Ends Multiplicities");
				
				_contextMenuItems.push("-");
				_contextMenuItems.push(_itemAssociationName);
				_contextMenuItems.push(_itemEndsNames);
				_contextMenuItems.push(_itemEndsMultiplicities);
			}
		}
		
		protected override function initContextMenuListeners():void
		{
			super.initContextMenuListeners();
			
			_itemAssociationName.addEventListener(MouseEvent.CLICK,		onItemAssociationNameClick);
			_itemEndsNames.addEventListener(MouseEvent.CLICK,			onItemEndsNamesClick);
			_itemEndsMultiplicities.addEventListener(MouseEvent.CLICK,	onItemEndMultiplicitiesClick);
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
			
			_ownerDiagram.modelElement.removeEventListener(UmlAssociationEvent.ASSOCIATION_ADDED, onAdded);
		}
		
		protected function onAssociationEndAdded(e:UmlAssociationEvent):void
		{
			var associationEnd:UmlViewAssociationEnd = null;
			
			associationEnd = new UmlViewAssociationEnd(e.getAddedElement(), uid, this);
			_ends.push(associationEnd);
			
			addChild(associationEnd);
			
//			updateFirstSidePosition();
//			updateLastSidePosition();
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
			
			_classifiers				= null;
			_firstArrow					= null;
			_lastArrow					= null;
			_associationClassPoint		= null;
			_associationClassLine		= null;
			_line						= null;
			_ownerDiagram				= null;
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
				
				_associationName.addEventListener(UmlViewEvent.ACTIVATED, onAssociationNameActivated);
				_associationName.addEventListener(UmlViewEvent.DEACTIVATED, onAssociationNameDeactivated);
				_associationName.addEventListener(UmlViewEvent.CREATED, onAssociationNameCreated);
				
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
				_associationName.removeEventListener(UmlViewEvent.DONE,	onAssociationNameDone);
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
			if (_ends != null)
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
				
				lowerMultiplicity = new UmlModelLiteralInteger("","");
				lowerMultiplicity.value = 1;
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
		}
		
		protected function createLastArrow():void
		{
			_lastArrow = new Sprite();
			addChild(_lastArrow);
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
				
				if (child is UmlViewRegularNode || child is UmlViewAssociation)
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
				
				if (child is UmlViewRegularNode || child is UmlViewAssociation)
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
		
//		protected function initRectangleCorners(
//									component:UIComponent, 
//									A:Point, B:Point, C:Point, D:Point, 
//									isComponentSwapped:Boolean = false):void
//		{
//			if (component	== null || 
//				A			== null || 
//				B			== null || 
//				C			== null || 
//				D			== null)
//			{
//				return;
//			}
//			
//			var parentPoint:Point = new Point();
//			
//			if (isComponentSwapped)
//			{
//				if (component.parent != null)
//				{
//					parentPoint.x = component.parent.x;
//					parentPoint.y = component.parent.y;
//				}
//			}
//			
//			A.x = parentPoint.x + component.x;
//			A.y = parentPoint.y + component.y;
//			
//			B.x = parentPoint.x + component.x + component.width;
//			B.y = parentPoint.y + component.y;
//			
//			C.x = parentPoint.x + component.x + component.width;
//			C.y = parentPoint.y + component.y + component.height;
//			
//			D.x = parentPoint.x + component.x;
//			D.y = parentPoint.y + component.y + component.height;
//		}
//		
//		protected function updateFirstSidePosition():void
//		{
//			if (_line == null)
//			{
//				return;
//			}
//			
//			var firstEndPosition	:uint = 0;
//			
//			// side 1
//			var A1		:Point		= new Point();
//			var B1		:Point		= new Point();
//			var C1		:Point		= new Point();
//			var D1		:Point		= new Point();
//			
//			// side 2
//			var A2		:Point		= new Point();
//			var B2		:Point		= new Point();
//			var C2		:Point		= new Point();
//			var D2		:Point		= new Point();
//			
//			// side 1
//			if (_classifiers[0].parent != null && 
//				_classifiers[0].parent != _ownerDiagram.getSelector())
//			{
//				initRectangleCorners(_classifiers[0], A1, B1, C1, D1);
//			}
//			else
//			{
//				initRectangleCorners(_classifiers[0], A1, B1, C1, D1, true);
//			}
//			
//			// second point 
//			var secondPoint:Point = _line.getSecondPoint();
//			A2 = B2 = C2 = D2 = secondPoint;
//			
//			// test the step 1 cases : 
//			// A1 & C2, B1 & D2, C1 & A2, D1 & B2
//			var isLeftTop			:Boolean	= A2.x <= A1.x && A2.y <= A1.y;
//			var isRightTop			:Boolean	= B2.x >= B1.x && B2.y <= B1.y;
//			var isRightBottom		:Boolean	= C2.x >= C1.x && C2.y >= C1.y;
//			var isLeftBottom		:Boolean	= D2.x <= D1.x && D2.y >= D1.y;
//			
//			if (isLeftTop)
//			{
//				_line.setFirstPoint(A1.x, A1.y);
//				
//				firstEndPosition = UmlViewAssociationEnd.TOP;
//				if (_line.getFirstLinkDirection() == UmlViewSolidLine.HORIZONTAL)
//				{
//					firstEndPosition = UmlViewAssociationEnd.LEFT;
//				}
//			}
//			else if (isRightTop)
//			{
//				_line.setFirstPoint(B1.x, B1.y);
//				
//				firstEndPosition = UmlViewAssociationEnd.TOP;
//				if (_line.getFirstLinkDirection() == UmlViewSolidLine.HORIZONTAL)
//				{
//					firstEndPosition = UmlViewAssociationEnd.RIGHT;
//				}
//			}
//			else if (isRightBottom)
//			{
//				_line.setFirstPoint(C1.x, C1.y);
//				
//				firstEndPosition = UmlViewAssociationEnd.BOTTOM;
//				if (_line.getFirstLinkDirection() == UmlViewSolidLine.HORIZONTAL)
//				{
//					firstEndPosition = UmlViewAssociationEnd.RIGHT;
//				}
//			}
//			else if (isLeftBottom)
//			{
//				_line.setFirstPoint(D1.x, D1.y);
//				
//				firstEndPosition = UmlViewAssociationEnd.BOTTOM;
//				if (_line.getFirstLinkDirection() == UmlViewSolidLine.HORIZONTAL)
//				{
//					firstEndPosition = UmlViewAssociationEnd.LEFT;
//				}
//			}
//			else
//			{
//				var isLeft			:Boolean		= A1.x > A2.x;
//				var isTop			:Boolean		= A1.y > A2.y;
//				var isRight			:Boolean		= B1.x < B2.x;
//				var isBottom		:Boolean		= D1.y < D2.y;
//				
//				if (isLeft)
//				{
//					_line.setFirstPoint(A1.x, A2.y);
//					
//					firstEndPosition = UmlViewAssociationEnd.LEFT;
//				}
//				else if (isTop)
//				{
//					_line.setFirstPoint(A2.x, A1.y);
//					
//					firstEndPosition = UmlViewAssociationEnd.TOP;
//				}
//				else if (isRight)
//				{
//					_line.setFirstPoint(B1.x, B2.y);
//					
//					firstEndPosition = UmlViewAssociationEnd.RIGHT;
//				}
//				else if (isBottom)
//				{
//					_line.setFirstPoint(D2.x, D1.y);
//					
//					firstEndPosition = UmlViewAssociationEnd.BOTTOM;
//				}
//			}
//			
//			updateAssciationEndsPositions(_ends[0], _line.getFirstPoint(), firstEndPosition);
//			
//			updateAssociationNamePosition();
//			
//			paintFirstArrow();
//			paintLastArrow();
//			
//			updateFirstArrowPositionAndRotation();
//			updateLastArrowPositionAndRotation();
//		}
//		
//		protected function updateLastSidePosition():void
//		{
//			if (_line == null)
//			{
//				return;
//			}
//			
//			var lastEndPosition		:uint = 0;
//			
//			// side 1
//			var A1					:Point					= new Point();
//			var B1					:Point					= new Point();
//			var C1					:Point					= new Point();
//			var D1					:Point					= new Point();
//			
//			// side 2
//			var A2					:Point					= new Point();
//			var B2					:Point					= new Point();
//			var C2					:Point					= new Point();
//			var D2					:Point					= new Point();
//			
//			if (_classifiers[1].parent != null && 
//				_classifiers[1].parent != _ownerDiagram.getSelector())
//			{
//				initRectangleCorners(_classifiers[1], A2, B2, C2, D2);
//			}
//			else
//			{
//				initRectangleCorners(_classifiers[1], A2, B2, C2, D2, true);
//			}
//			
//			// before last point 
//			var beforePoint:Point = _line.getBeforeLastPoint();
//			A1 = B1 = C1 = D1 = beforePoint;
//			
//			// test the step 1 cases : 
//			// A1 & C2, B1 & D2, C1 & A2, D1 & B2
//			var isLeftTop			:Boolean		= A1.x <= A2.x && A1.y <= A2.y;
//			var isRightTop			:Boolean		= B1.x >= B2.x && B1.y <= B2.y;
//			var isRightBottom		:Boolean		= C1.x >= C2.x && C1.y >= C2.y;
//			var isLeftBottom		:Boolean		= D1.x <= D2.x && D1.y >= D2.y;
//			
//			if (isLeftTop)
//			{
//				_line.setLastPoint(A2.x, A2.y);
//				
//				lastEndPosition = UmlViewAssociationEnd.TOP;
//				if (_line.getLastLinkDirection() == UmlViewSolidLine.HORIZONTAL)
//				{
//					lastEndPosition = UmlViewAssociationEnd.LEFT;
//				}
//			}
//			else if (isRightTop)
//			{
//				_line.setLastPoint(B2.x, B2.y);
//				
//				lastEndPosition = UmlViewAssociationEnd.TOP;
//				if (_line.getLastLinkDirection() == UmlViewSolidLine.HORIZONTAL)
//				{
//					lastEndPosition = UmlViewAssociationEnd.RIGHT;
//				}
//			}
//			else if (isRightBottom)
//			{
//				_line.setLastPoint(C2.x, C2.y);
//				
//				lastEndPosition = UmlViewAssociationEnd.BOTTOM;
//				if (_line.getLastLinkDirection() == UmlViewSolidLine.HORIZONTAL)
//				{
//					lastEndPosition = UmlViewAssociationEnd.RIGHT;
//				}
//			}
//			else if (isLeftBottom)
//			{
//				_line.setLastPoint(D2.x, D2.y);
//				
//				lastEndPosition = UmlViewAssociationEnd.BOTTOM;
//				if (_line.getLastLinkDirection() == UmlViewSolidLine.HORIZONTAL)
//				{
//					lastEndPosition = UmlViewAssociationEnd.LEFT;
//				}
//			}
//			else
//			{
//				var isLeft			:Boolean		= A1.x < A2.x;
//				var isTop			:Boolean		= A1.y < A2.y;
//				var isRight			:Boolean		= B1.x > B2.x;
//				var isBottom		:Boolean		= D1.y > D2.y;
//				
//				if (isLeft)
//				{
//					_line.setLastPoint(A2.x, A1.y);
//					
//					lastEndPosition = UmlViewAssociationEnd.LEFT;
//				}
//				else if (isTop)
//				{
//					_line.setLastPoint(A1.x, A2.y);
//					
//					lastEndPosition = UmlViewAssociationEnd.TOP;
//				}
//				else if (isRight)
//				{
//					_line.setLastPoint(B2.x, A1.y);
//					
//					lastEndPosition = UmlViewAssociationEnd.RIGHT;
//				}
//				else if (isBottom)
//				{
//					_line.setLastPoint(A1.x, D2.y);
//					
//					lastEndPosition = UmlViewAssociationEnd.BOTTOM;
//				}
//			}
//			
//			updateAssciationEndsPositions(_ends[1], _line.getLastPoint(), lastEndPosition);
//			
//			updateAssociationNamePosition();
//			
//			paintFirstArrow();
//			paintLastArrow();
//			
//			updateFirstArrowPositionAndRotation();
//			updateLastArrowPositionAndRotation();
//		}
//		
//		/**
//		 * 2 STEPS : 
//		 * 
//		 * 1 : we take just the corners
//		 * 2 : (the hardest) it's too hard to explain, ...
//		 * 
//		 * to nuderstand all this, look at the paper
//		 */
//		protected function updateLinePosition():void
//		{
//			if (_line == null)
//			{
//				return;
//			}
//			
//			_line.update();
//			
//			var firstEndPosition	:uint = 0;
//			var lastEndPosition		:uint = 0;
//			
//			// side 1
//			var A1					:Point					= new Point();
//			var B1					:Point					= new Point();
//			var C1					:Point					= new Point();
//			var D1					:Point					= new Point();
//			
//			// side 2
//			var A2					:Point					= new Point();
//			var B2					:Point					= new Point();
//			var C2					:Point					= new Point();
//			var D2					:Point					= new Point();
//			
//			// side 1
//			if (_classifiers[0].parent != null && 
//				_classifiers[0].parent != _ownerDiagram.getSelector())
//			{
//				initRectangleCorners(_classifiers[0], A1, B1, C1, D1);
//			}
//			else
//			{
//				initRectangleCorners(_classifiers[0], A1, B1, C1, D1, true);
//			}
//			
//			// side 2
//			if (_classifiers[1].parent != null && 
//				_classifiers[1].parent != _ownerDiagram.getSelector())
//			{
//				initRectangleCorners(_classifiers[1], A2, B2, C2, D2);
//			}
//			else
//			{
//				initRectangleCorners(_classifiers[1], A2, B2, C2, D2, true);
//			}
//			
//			// test the step 1 cases : 
//			// A1 & C2, B1 & D2, C1 & A2, D1 & B2
//			var isLeftTop			:Boolean	= A1.x >= C2.x && A1.y >= C2.y;
//			var isRightTop			:Boolean	= B1.x <= D2.x && B1.y >= D2.y;
//			var isRightBottom		:Boolean	= C1.x <= A2.x && C1.y <= A2.y;
//			var isLeftBottom		:Boolean	= D1.x >= B2.x && D1.y <= B2.y;
//			
//			if (isLeftTop)
//			{
//				_line.setFirstPoint(A1.x, A1.y);
//				_line.setLastPoint(C2.x, C2.y);
//			}
//			else if (isRightTop)
//			{
//				_line.setFirstPoint(B1.x, B1.y);
//				_line.setLastPoint(D2.x, D2.y);
//			}
//			else if (isRightBottom)
//			{
//				_line.setFirstPoint(C1.x, C1.y);
//				_line.setLastPoint(A2.x, A2.y);
//			}
//			else if (isLeftBottom)
//			{
//				_line.setFirstPoint(D1.x, D1.y);
//				_line.setLastPoint(B2.x, B2.y);
//			}
//			else
//			{
//				var isLeft			:Boolean		= A1.x > B2.x;
//				var isTop			:Boolean		= A1.y > D2.y;
//				var isRight			:Boolean		= B1.x < A2.x;
//				var isBottom		:Boolean		= D1.y < A2.y;
//				
//				var left1			:Number			= 0;
//				var top1			:Number			= 0;
//				var right1			:Number			= 0;
//				var bottom1			:Number			= 0;
//				
//				var left2			:Number			= 0;
//				var top2			:Number			= 0;
//				var right2			:Number			= 0;
//				var bottom2			:Number			= 0;
//				
//				var zoneLeft		:Number			= 0;
//				var zoneTop			:Number			= 0;
//				var zoneRight		:Number			= 0;
//				var zoneBottom		:Number			= 0;
//				
//				if (isLeft)
//				{
//					top1			= A1.y;
//					bottom1			= D1.y;
//					
//					top2			= B2.y;
//					bottom2			= C2.y;
//					
//					zoneTop			= (top1 >= top2)		? top1		: top2;
//					zoneBottom		= (bottom1 <= bottom2)	? bottom1	: bottom2;
//					
//					_line.setFirstPoint(A1.x, zoneTop + (zoneBottom - zoneTop) / 2);
//					_line.setLastPoint(B2.x, zoneTop + (zoneBottom - zoneTop) / 2);
//				}
//				else if (isTop)
//				{
//					left1			= A1.x;
//					right1			= B1.x;
//					
//					left2			= D2.x;
//					right2			= C2.x;
//					
//					zoneLeft		= (left1 >= left2)		? left1		: left2;
//					zoneRight		= (right1 <= right2)	? right1	: right2;
//					
//					_line.setFirstPoint(zoneLeft + (zoneRight - zoneLeft) / 2, A1.y);
//					_line.setLastPoint(zoneLeft + (zoneRight - zoneLeft) / 2, D2.y);
//				}
//				else if (isRight)
//				{
//					top1			= B1.y;
//					bottom1			= C1.y;
//					
//					top2			= A2.y;
//					bottom2			= D2.y;
//					
//					zoneTop			= (top1 >= top2)		? top1		: top2;
//					zoneBottom		= (bottom1 <= bottom2)	? bottom1	: bottom2;
//					
//					_line.setFirstPoint(B1.x, zoneTop + (zoneBottom - zoneTop) / 2);
//					_line.setLastPoint(A2.x, zoneTop + (zoneBottom - zoneTop) / 2);
//				}
//				else if (isBottom)
//				{
//					left1			= D1.x;
//					right1			= C1.x;
//					
//					left2			= A2.x;
//					right2			= B2.x;
//					
//					zoneLeft		= (left1 >= left2)		? left1		: left2;
//					zoneRight		= (right1 <= right2)	? right1	: right2;
//					
//					_line.setFirstPoint(zoneLeft + (zoneRight - zoneLeft) / 2, D1.y);
//					_line.setLastPoint(zoneLeft + (zoneRight - zoneLeft) / 2, A2.y);
//				}
//			}
//			
//			updateAssociationNamePosition();
//			
//			// la flêche 
//			paintFirstArrow();
//			paintLastArrow();
//			updateFirstArrowPositionAndRotation();
//			updateLastArrowPositionAndRotation();
//		}
		
		protected function updateFirstArrowPositionAndRotation():void
		{
			if (_line == null)
			{
				return;
			}
			
			if (_firstArrow != null)
			{
				_firstArrow.x			= _line.getFirstPoint().x;
				_firstArrow.y			= _line.getFirstPoint().y;
				
				_firstArrow.rotation	= UmlViewControler.getAngle
				(
					_line.getSecondPoint(), 
					_line.getFirstPoint()
				);
			}
		}
		
		protected function updateLastArrowPositionAndRotation():void
		{
			if (_line == null)
			{
				return;
			}
			
			if (_lastArrow != null)
			{
				_lastArrow.x			= _line.getLastPoint().x;
				_lastArrow.y			= _line.getLastPoint().y;
				
				_lastArrow.rotation		= UmlViewControler.getAngle
				(
					_line.getBeforeLastPoint(), 
					_line.getLastPoint()
				);
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
				
//				initLineListeners();
				
				// 
				// we add the _line to this view node, and then we add this node 
				// to the parent (the diagram)
				// 
				addChild(_line);
				_ownerDiagram.addChildAt(this, 0);
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
			side.addEventListener(MouseEvent.MOUSE_MOVE,	onSideMouseMove);
			side.addEventListener(MouseEvent.MOUSE_UP,		onSideMouseUp);
			
			side.addEventListener(ResizeEvent.RESIZE,		onSideResize);
		}
		
		protected function removeSideListeners(side:UIComponent):void
		{
			side.removeEventListener(MouseEvent.MOUSE_DOWN,		onSideMouseDown);
			side.removeEventListener(MouseEvent.MOUSE_MOVE,		onSideMouseMove);
			side.removeEventListener(MouseEvent.MOUSE_UP,		onSideMouseUp);
			
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
						element.addEventListener(MouseEvent.MOUSE_MOVE,		onSideMouseMove);
						element.addEventListener(MouseEvent.MOUSE_UP,		onSideMouseUp);
						
						element.addEventListener(UmlEvent.NODE_DESELECTED,	onElementDeselected);
					}
				}
			}
		}
		
		protected function onElementDeselected(e:UmlEvent):void
		{
			e.target.removeEventListener(MouseEvent.MOUSE_DOWN,		onSideMouseDown);
			e.target.removeEventListener(MouseEvent.MOUSE_MOVE,		onSideMouseMove);
			e.target.removeEventListener(MouseEvent.MOUSE_UP,		onSideMouseUp);
			
			e.target.removeEventListener(UmlEvent.NODE_DESELECTED,	onElementDeselected);
		}
		
		protected function onSideMouseDown(e:MouseEvent):void
		{
			_isSidePressed = true;
		}
		
		protected function onSideMouseMove(e:MouseEvent):void
		{
//			if (_line == null)
//			{
//				return;
//			}
//			
//			var side:UIComponent = e.currentTarget as UIComponent;
//			
//			if (UmlControler.getInstance().getMode() == "normal" && _isSidePressed)
//			{
//				// it's only in the case witch there is at least one point 
//				// in addition of the two sides, that we can apply the selective 
//				// update.
//				// else we apply the global update.
////				updateFirstSidePosition();
////				updateLastSidePosition();
////				
////				if (!_line.isThereAPoint())
////				{
////					updateLinePosition();
////				}
//				
//				// if the associationClassLine is set we refresh its render
//				if (_associationClassLine != null)
//				{
//					_associationClassLine.refreshRender();
//				}
//				
//				e.updateAfterEvent();
//			}
		}
		
		protected function onSideMouseUp(e:MouseEvent):void
		{
			_isSidePressed = false;
		}
		
		protected function onSideResize(e:ResizeEvent):void
		{
//			updateLinePosition();
//			updateFirstSidePosition();
//			updateLastSidePosition();
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
			
//			updateFirstSidePosition();
//			updateLastSidePosition();
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
				_line.setLastPoint(side.x + side.width/2, side.y + side.height/2);
				
				_ownerDiagram.removeEventListener(MouseEvent.MOUSE_MOVE, onParentMouseMove);
				removeNodesListeners();
				
				initSideListeners(side);
				_classifiers.push(side);
				
				_line.setSides(_classifiers);
				
				UmlControler.getInstance().setMode("normal");
				
//				updateLinePosition();
				
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
