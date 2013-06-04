package view.newView
{
	
	import controler.UmlControler;
	import controler.UmlLayoutControler;
	import controler.UmlSelectionControler;
	import controler.events.UmlAssociationEvent;
	import controler.events.UmlEvent;
	import controler.events.UmlViewEvent;
	import controler.namespaces.selector;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import model.IUmlModelElement;
	import model.UmlModel;
	
	import mx.containers.Canvas;
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	
	import view.IUmlViewElement;
	import view.newView.associations.UmlViewAssociation;
	import view.umlView.UmlViewAssociationClass;
	import view.umlView.UmlViewClass;
	import view.umlView.UmlViewInterface;
	
	/**
	 * 
	 * @author kamal
	 * 
	 */
	public class UmlViewDiagram extends UmlViewContainerNode
	{
		
		/**
		 * utilisé quand on veut séléctionner un élément.
		 */
		use namespace selector;
		
		public static const MAX_WIDTH				:Number			= 2000;
		public static const MAX_HEIGHT				:Number			= 2000;
		
		public static const MIN_WIDTH				:Number			= 1000;
		public static const MIN_HEIGHT				:Number			= 700;
		
		private static const SELECTOR_MARGIN		:Number			= 10;
		
		/**
		 * selection managment
		 */
		protected var _presse						:Boolean		= false;
		protected var _firstPoint					:Point			= null;
		protected var _lastPoint					:Point			= null;
		protected var _selectionRectangle			:Canvas			= null;
		protected var _isMouseMoved					:Boolean		= false;
		protected var _selector						:Canvas			= null;
		protected var _isSelectorBusy				:Boolean		= false;
		protected var _minPoint						:Point			= null;
		
		
		/**
		 * background drawing
		 */
		protected var _gridHorizontalSpacing		:Number			= 20;
		protected var _gridVerticalSpacing			:Number			= 20;
		protected var _isDrawingDirty				:Boolean		= true;
		
		
		/**
		 * 
		 * @param xml
		 * @param parentUID
		 * 
		 */
		public function UmlViewDiagram(modelElement:IUmlModelElement, parentUID:String)
		{
			super(modelElement,  parentUID);
			
			doubleClickEnabled			= true;
			_isSuperDragAllowed			= false;
			_isSelectSimilarsAllowed	= false;
			_isPasteFeatureAllowed		= true;
			
			_minPoint					= new Point();
			
			initListeners();
		}
		
		/***********************************************************************
		 * 
		 * overriden functions 
		 * 
		 **********************************************************************/
		
		protected override function initListeners():void
		{
			super.initListeners();
			
			//addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			
			addEventListener(MouseEvent.CLICK, onClick);
			
			// dispatched by the UmlViewToolItem onMouseDown.
			UmlLayoutControler.getInstance().addEventListener(UmlViewEvent.TOOL_ITEM_END_DRAG, onToolItemEndDrag);
			
			// dispatched by a nodeManagment's button.
			//UmlControler.getInstance().addEventListener(UmlEvent.PICKER_ADD_ASSOCIATION, onAssociationNew);
			
			// dispatched by the toolbox's association button.
			UmlControler.getInstance().addEventListener("association", onAssociationNew);
		}
		
		protected override function initModelListeners() : void
		{
			super.initModelListeners();
			
			// these events are dispatched from the diagram model element.
			_modelElement.addEventListener(UmlEvent.CLASS_ADDED,				onClassAdded);
			_modelElement.addEventListener(UmlEvent.INTERFACE_ADDED,			onInterfaceAdded);
			_modelElement.addEventListener(UmlEvent.ENUMERATION_ADDED,			onEnumerationAdded);
			_modelElement.addEventListener(UmlEvent.SIGNAL_ADDED,				onSignalAdded);
			
			_modelElement.addEventListener(UmlAssociationEvent.ASSOCIATION_CLASS_ADDED,	onAssociationClassAdded);
			_modelElement.addEventListener(UmlAssociationEvent.ASSOCIATION_ADDED,		onAssociationAdded);
		}
		
		/**
		 * instead of adding the stuff to the viewNode, 
		 * we add it to the global children holder.
		 * 
		 * @param child
		 * @return 
		 */
		public override function addChild(child:DisplayObject):DisplayObject
		{
			return _globalHolder.addChild(child);
		}
		
		/**
		 * same job as the addChild function.
		 * 
		 * @param child
		 * @param index
		 * @return 
		 */
		public override function addChildAt(child:DisplayObject, index:int):DisplayObject
		{
			return _globalHolder.addChildAt(child, index);
		}
		
		/**
		 * instead of removing the stuff from the viewNode, 
		 * we remove it from the global children holder.
		 * 
		 * @param child
		 * @return 
		 */
		public override function removeChild(child:DisplayObject):DisplayObject
		{
			return _globalHolder.removeChild(child);
		}
		
		public override function contains(child:DisplayObject):Boolean
		{
			var isContaining:Boolean = false;
			isContaining = _globalHolder.contains(child);
			return isContaining;
		}
		
		protected override function createChildren():void
		{
			super.createChildren();
			
			_selector				= new Canvas();
			
			_selector.x				= 300;
			_selector.y				= 100;
			_selector.width			= 300;
			_selector.height		= 300;
			
			addChild(_selector);
			
			_selectionRectangle		= new Canvas();
		}
		
		protected override function measure():void
		{
			super.measure();
			
			measuredWidth	= measuredMinWidth		= MIN_WIDTH;
			measuredHeight	= measuredMinHeight		= MIN_HEIGHT;
		}
		
		protected override function commitProperties():void
		{
			super.commitProperties();
		}
		
		protected override function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
		}
		
		protected override function layoutChildren(p_width:Number, p_height:Number):void
		{
			super.layoutChildren(p_width, p_height);
			
			_background.x		= _globalHolder.x		= 0;
			_background.y		= _globalHolder.y		= 0;
			_background.width	= _globalHolder.width	= p_width;
			_background.height	= _globalHolder.height	= p_height;
		}
		
		protected override function paint(p_width:Number, p_height:Number):void
		{
			super.paint(p_width, p_height);
			
			var i:uint = 0;
			
			with (_globalHolder.graphics)
			{
				clear();
				
				beginFill(0x222222, 1);
				drawRoundRect(0, 0, p_width, p_height, 5, 5);
				endFill();
				
				lineStyle(0.25, 0x333333, 1, true);
				drawRoundRect(0, 0, p_width, p_height, 5, 5);
				
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
		
		protected override function isToolAllowed(toolItem:UmlViewToolItem):Boolean
		{
			// il faut d'abord tester si le type est valide
			// si valide:	tester si le test de collision est bon
			//				si oui on ajoute le node au diagram à la place du toolItem 
			//				sinon on ne fait rien, c'est au workspace du projet à afficher 
			//				une liste des éléments qui supportent ce type, pour en choisir un
			//				auquel on peut ajouter le nouveau node.
			
			var isTypeValid:Boolean	=	(toolItem.getType() == UmlModel.CLASS) || 
										(toolItem.getType() == UmlModel.INTERFACE) || 
										(toolItem.getType() == UmlModel.ASSOCIATION) ||
										(toolItem.getType() == UmlModel.ASSOCIATION_CLASS) ||
										(toolItem.getType() == UmlModel.ENUMERATION) ||
										(toolItem.getType() == UmlModel.SIGNAL);
			
			if (isTypeValid == true)
			{
				// on récupère le sprite qui nous permet d'effectuer le test des collisions.
				var toolItemHitArea:Sprite = null;
				if (parent && parent is UmlViewDiagramContainer)
				{
					toolItemHitArea = (parent as UmlViewDiagramContainer).getToolItemhitArea();
					
					//TODO : getHolderHorizontalScrollPosition doit être dans le UmlViewControler.
					var xOffset:Number = UmlControler.getInstance().getSelectedProjectWorkspace().getHolderHorizontalScrollPosition();
					var yOffset:Number = UmlControler.getInstance().getSelectedProjectWorkspace().getHolderVerticalScrollPosition();
					
					toolItemHitArea.x		= toolItem.x + xOffset;
					toolItemHitArea.y		= toolItem.y + yOffset;
					toolItemHitArea.width	= toolItem.width;
					toolItemHitArea.height	= toolItem.height;
				}
				
				// the hit test that help us to know if we have hitted the diagram.
				var isCollisionTestValid:Boolean = false;
				if (toolItemHitArea != null && toolItemHitArea.hitTestObject(this) == true)
				{
					return true;
				}
			}
			
			return false;
		}
		
		protected override function createElementFromType(elementType:String):void
		{
			if (!isSelected())
			{
				UmlSelectionControler.getInstance().selectElement(this);
			}
			
			switch (true)
			{
				case (elementType == UmlModel.CLASS) :
					UmlControler.getInstance().addClass();
				break;
				case (elementType == UmlModel.ASSOCIATION) :
					// detected by the UmlViewDiagram2
					//UmlControler.getInstance().dispatchEvent(new Event("association"));
				break;
				case (elementType == UmlModel.ENUMERATION) :
					UmlControler.getInstance().addEnumeration(uid);
				break;
				case (elementType == UmlModel.SIGNAL) :
					UmlControler.getInstance().addSignal(uid)
				break;
			}
		}
		
		public override function setSelected(value:Boolean):void
		{
			super.setSelected(value);
			
			if (_isSelected == true)
			{
				
			}
			else
			{
				
			}
		}
		
		/***********************************************************************
		 * 
		 * overriden callback functions
		 * 
		 **********************************************************************/
		
		protected override function onCreationComplete(e:FlexEvent):void
		{
			_selectionRectangle.setStyle("backgroundColor", "#FFFFFF");
			_selectionRectangle.alpha = .1;
			//_selectionRectangle.filters = [new BlurFilter(2, 2, 1)];
			
			UmlSelectionControler.getInstance().selectElement(this);
		}
		
		protected override function onMouseDown(e:MouseEvent):void
		{
			super.onMouseDown(e);
			
			if (UmlControler.getInstance().getMode() == "normal")
			{
				_presse			= true;
				_isMouseMoved	= false;
				
				_firstPoint		= new Point(mouseX, mouseY);
				_lastPoint		= new Point(mouseX, mouseY);
				
				// ici il faut selectionner le diagram, puis dispatcher 
				// un event pour informer le DiagramContainer.
//				UmlSelectionControler.getInstance().selectNode(this);
//				var umlEvent:UmlEvent = new UmlEvent(UmlEvent.NODE_SELECTED);
//				umlEvent.setSelectedNode(this);
//				
//				// écouté par UmlViewDiagramContainer
//				dispatchEvent(umlEvent);
				
				if (e.target == _globalHolder)
				{
					showSelectionRectangle();
				}
				
				// ici initialiser le selector si le user ne touche pas ctrl
				UmlSelectionControler.setCtrlKeyDown(e.ctrlKey);
				if (!UmlSelectionControler.isCtrlKeyDown())
				{
					initSelector();
				}
				
				// pk??? pour deselectionner aussi les associationEnds ;-) 
				UmlSelectionControler.getInstance().deselectFields();
				
				_selectionRectangle.x			= _firstPoint.x;
				_selectionRectangle.y			= _firstPoint.y;
				_selectionRectangle.width		= _lastPoint.x - _firstPoint.x;
				_selectionRectangle.height		= _lastPoint.y - _firstPoint.y;
			}
			
			e.stopPropagation();
		}
		
		protected override function onMouseMove(e:MouseEvent):void
		{
			super.onMouseMove(e);
			
			if (UmlControler.getInstance().getMode() == "normal")
			{
				if (_presse)
				{
					_lastPoint.x	= mouseX;
					_lastPoint.y	= mouseY;
					
					if (_lastPoint.x <= 0)
					{
						_lastPoint.x = 0;
					}
					
					if (_lastPoint.x >= _globalHolder.width)
					{
						_lastPoint.x = _globalHolder.width;
					}
					
					if (_lastPoint.y <= 0)
					{
						_lastPoint.y = 0;
					}
					
					if (_lastPoint.y >= _globalHolder.height)
					{
						_lastPoint.y = _globalHolder.height;
					}
					
					_selectionRectangle.width	= _lastPoint.x - _firstPoint.x;
					_selectionRectangle.height	= _lastPoint.y - _firstPoint.y;
					
					_isMouseMoved				= true;
				}
				e.updateAfterEvent();
			}
		}
		
		protected override function onMouseUp(e:MouseEvent):void
		{
			super.onMouseUp(e);
			
			if (UmlControler.getInstance().getMode() == "normal")
			{
				_presse = false;
				
				if (_globalHolder.contains(_selectionRectangle) && _isMouseMoved)
				{
					selectObjects(UmlSelectionControler.COLLISION_TEST);
					hideSelectionRactangle();
				}
			}
		}
		
		
		/***********************************************************************
		 * 
		 * regular functions
		 * 
		 **********************************************************************/
		
		
		protected function showSelectionRectangle():void
		{
			addChild(_selectionRectangle)
			
			_selectionRectangle.enabled = true;
			_selectionRectangle.visible = true;
		}
		
		protected function hideSelectionRactangle():void
		{
			_selectionRectangle.x = 0;
			_selectionRectangle.y = 0;
			_selectionRectangle.width = 0;
			_selectionRectangle.height = 0;
			
			_selectionRectangle.enabled = false;
			_selectionRectangle.visible = false;
			
			removeChild(_selectionRectangle);
		}
		
		public function selectAllNodes():void
		{
			selectObjects(UmlSelectionControler.ALL);
		}
		
		/**
		 * we will define it later, as constants :s
		 * 
		 * 1 : COLLISION TEST
		 * 2 : ALL
		 * 
		 * @param mode
		 */
		public function selectObjects(mode:uint):void
		{
			for (var i:uint = 0; i < _globalHolder.numChildren; i++)
			{
				var node:DisplayObject = _globalHolder.getChildAt(i);
				if (
						node != _selectionRectangle	&& 
						(
							node is UmlViewClass				|| 
							node is UmlViewInterface/* 			|| 
							node is UmlViewAssociation , il n'y en a aucun intérêt */ 
						)
					)
				{
					if (mode == UmlSelectionControler.COLLISION_TEST)
					{
						if (_selectionRectangle.hitTestObject(node))
						{
							UmlSelectionControler.setCtrlKeyDown(true);
							UmlSelectionControler.getInstance().selectElement(node as IUmlViewElement);
							UmlSelectionControler.setCtrlKeyDown(false);
						}
						else
						{
							if (!UmlSelectionControler.isCtrlKeyDown())
							{
								UmlSelectionControler.getInstance().deselectElement(node as IUmlViewElement);
							}
						}
					}
					else if (mode == UmlSelectionControler.ALL)
					{
						UmlSelectionControler.setCtrlKeyDown(true);
						UmlSelectionControler.getInstance().selectElement(node as IUmlViewElement);
						UmlSelectionControler.setCtrlKeyDown(false);
					}
				}
			}
			
			if (UmlSelectionControler.getInstance().getSelectedClasses().length > 1)
			{
				swapToMove(UmlSelectionControler.getInstance().getSelectedClasses());
			}
		}
		
		public function initSelector():void
		{
			if (UmlSelectionControler.getInstance().getSelectedClasses().length > 1)
			{
				swapToDiagram(UmlSelectionControler.getInstance().getSelectedClasses());
			}
			
			_selector.x = 0;
			_selector.y = 0;
			_selector.width = 10;
			_selector.height = 10;
			
			_selector.setStyle("backgroundColor", "#44FFFF");
			_selector.setStyle("backgroundAlpha", 0.2);
		}
		
		private function getMinPoint(nodes:Array):Point
		{
			var minPoint:Point = new Point();
			
			if (_selector.contains(nodes[0]))
			{
				minPoint.x = _selector.x + nodes[0].x;
				minPoint.y = _selector.y + nodes[0].y;
			}
			else
			{
				minPoint.x = nodes[0].x;
				minPoint.y = nodes[0].y;
			}
			
			for (var i:uint = 0; i < nodes.length; i++)
			{
				if (_selector.contains(nodes[i]))
				{
					if (_selector.x + nodes[i].x < minPoint.x) minPoint.x = _selector.x + nodes[i].x;
					if (_selector.y + nodes[i].y < minPoint.y) minPoint.y = _selector.y + nodes[i].y;
				}
				else
				{
					if (nodes[i].x < minPoint.x) minPoint.x = nodes[i].x;
					if (nodes[i].y < minPoint.y) minPoint.y = nodes[i].y;
				}
			}
			
			minPoint.x -= SELECTOR_MARGIN;
			minPoint.y -= SELECTOR_MARGIN;
			
			return minPoint;
		}
		
		private function getMaxPoint(nodes:Array):Point
		{
			var maxPoint:Point = new Point();
			var minPoint:Point = getMinPoint(nodes);
			
			for (var i:uint = 0; i < nodes.length; i++)
			{
				if (nodes[i].x + nodes[i].width - minPoint.x > maxPoint.x)
				{
					maxPoint.x = nodes[i].x + nodes[i].width - minPoint.x;
				}
				
				if (nodes[i].y + nodes[i].height - minPoint.y > maxPoint.y)
				{
					maxPoint.y = nodes[i].y + nodes[i].height - minPoint.y;
				}
			}
			
			maxPoint.x += SELECTOR_MARGIN;
			maxPoint.y += SELECTOR_MARGIN;
			
			return maxPoint;
		}
		
		/**
		 * au cas d'une selection multiple précédée d'une selection multiple 
		 * il faut swaper la première selection pour que la nouvelle prenne 
		 * en compte tout les nodes sélectionnés.
		 * 
		 * @param nodes
		 */
		public function updateHolderPosition(nodes:Array):void
		{
			var selectedNodes:Array = new Array();
			
			if (isSelectorBusy())
			{
				for (var i:uint = 0; i < nodes.length; i++)
				{
					if (_selector.contains(nodes[i]))
					{
						selectedNodes.push(nodes[i]);
					}
				}
				
				swapToDiagram(selectedNodes);
			}
			
			_minPoint = getMinPoint(nodes);
			_selector.x = getMinPoint(nodes).x;
			_selector.y = getMinPoint(nodes).y;
			
			_selector.width = getMaxPoint(nodes).x;
			_selector.height = getMaxPoint(nodes).y;
		}
		
		public function swapToMove(elements:Array):void
		{
			updateHolderPosition(elements);
			
			for (var i:uint = 0; i < elements.length; i++)
			{
				var child:UIComponent = elements[i];
				if (_selector.getChildren().indexOf(child) < 0)
				{
					if (child != null && this.contains(child))
					{
						var final_x : int = child.x - _minPoint.x;
						var final_y : int = child.y - _minPoint.y;
						
						var removedChild:DisplayObject = this.removeChild(child);
						_selector.addChild(removedChild);
						
						removedChild.x = final_x;
						removedChild.y = final_y;
					}
				}
			}
			
			var event:UmlViewEvent = new UmlViewEvent(UmlViewEvent.ELEMENTS_SWAPPED);
			event.swappedElements = elements;
			dispatchEvent(event);
			
			_isSelectorBusy = true;
		}
		
		public function swapToDiagram(nodes:Array):void
		{
			var minPoint:Point = new Point(_selector.x, _selector.y);
			
			for (var i:uint = 0; i < nodes.length; i++)
			{
				var child:UIComponent = nodes[i];
				if (child && _selector.contains(child))
				{
					var final_x:int = minPoint.x + child.x;
					var final_y:int = minPoint.y + child.y;
					
					var removedChild:DisplayObject = _selector.removeChild(child);
					this.addChild(removedChild);
					
					removedChild.x = final_x;
					removedChild.y = final_y;
				}
			}
			
			if (_selector.getChildren().length == 0)
			{
				_isSelectorBusy = false;
			}
			
			_selector.x = 0;
			_selector.y = 0;
			_selector.width = 10;
			_selector.height = 10;
		}
		
		public function isSelectorBusy():Boolean
		{
			return _isSelectorBusy;
		}
		
		public function getSelector():Canvas
		{
			return _selector;
		}
		
		public function getViewNodes():Array
		{
			return _globalHolder.getChildren();
		}
		
		/***********************************************************************
		 * 
		 * callback functions
		 * 
		 **********************************************************************/
		
		protected function onAssociationNew(e:Event):void
		{
			UmlControler.getInstance().setMode("association");
			var relationship:UmlViewAssociation = new UmlViewAssociation(this);
			_ownedElements.push(relationship);
			
			if (e is UmlEvent)
			{
				relationship.processCreation((e as UmlEvent).getFirstSide());
			}
		}
		
		private function onAssociationClassAdded(e:UmlAssociationEvent):void
		{
			if (UmlModel.getInstance().getSelectedProject().selectedNode.uid == uid)
			{
				// create AssociationClass's view
				var associationClassXml		:XML	= e.addedAssociationClass;
				var relativeAssociationXml	:XML	= null;
				
				for each(var childXml:XML in associationClassXml.children())
				{
					if (childXml.localName() == "relativeAssociation")
					{
						relativeAssociationXml = childXml;
					}
				}
				
				var relativeAssociationNode		:UmlViewAssociation		= null;
				var relativeAssociationId		:String					= "";
				
				if (relativeAssociationXml != null)
				{
					relativeAssociationId = relativeAssociationXml.@id;
				}
				
				for (var i:uint = 0; i < numChildren; i++)
				{
					var child:UIComponent = getChildAt(i) as UIComponent;
					if (child is UmlViewAssociation)
					{
						if ((child as UmlViewAssociation).uid == relativeAssociationId)
						{
							relativeAssociationNode = (child as UmlViewAssociation);
						}
					}
				}
				
				var umlAssociationClassView:UmlViewAssociationClass = null;
				umlAssociationClassView = new UmlViewAssociationClass
				(
					e.getAddedElement(), 
					uid, 
					relativeAssociationNode
				);
				
				_ownedElements.push(umlAssociationClassView);
				addChild(umlAssociationClassView);
			}
		}
		
		private function onClassAdded(e:UmlEvent):void
		{
			if (e.getAddedElement().owner.uid == uid)
			{
				var modelClass	:IUmlModelElement	= null;
				var viewClass	:UmlViewClass		= null;
				var viewEvent	:UmlViewEvent		= null;
				
				modelClass	= e.getAddedElement();
				viewClass	= new UmlViewClass(modelClass, uid);
				
				viewClass.addEventListener(UmlEvent.PICKER_ADD_ASSOCIATION, onAssociationNew);
				viewClass.addEventListener(FlexEvent.CREATION_COMPLETE, onAddedElementCreationComplete);
				
				viewEvent = new UmlViewEvent(UmlViewEvent.ELEMENT_ADDED);
				viewEvent.addedElement = viewClass;
				dispatchEvent(viewEvent);
				
				addChild(viewClass);
				_ownedElements.push(viewClass);
				UmlSelectionControler.getInstance().selectElement(viewClass);
			}
		}
		
		private function onAddedElementCreationComplete(event:FlexEvent):void
		{
			var addedElement:UmlViewElement = event.currentTarget as UmlViewElement;
			
			addedElement.x = mouseX - addedElement.width / 2;
			addedElement.y = mouseY - addedElement.height / 2;
		}
		
		private function onInterfaceAdded(e:UmlEvent):void
		{
			if (UmlModel.getInstance().getSelectedProject().selectedNode.uid == uid)
			{
				// create interface view
				var umlInterfaceView:UmlViewInterface = new UmlViewInterface(e.getAddedElement(), uid);
				umlInterfaceView.addEventListener(UmlEvent.PICKER_ADD_ASSOCIATION, onAssociationNew);
				_ownedElements.push(umlInterfaceView);
				addChild(umlInterfaceView);
			}
		}
		
		private function onAssociationAdded(e:UmlEvent):void
		{
			trace("an association is added");
			trace("____________________\n" + UmlModel.getInstance().getSelectedProject().xml.toXMLString());
		}
		
		protected function onEnumerationAdded(e:UmlEvent):void
		{
			if (UmlModel.getInstance().getSelectedProject().selectedNode.uid == uid)
			{
				var umlEnumeration:UmlViewEnumeration = null;
				umlEnumeration = new UmlViewEnumeration(e.getAddedElement(), uid);
				umlEnumeration.addEventListener(UmlEvent.PICKER_ADD_ASSOCIATION, onAssociationNew);
				_ownedElements.push(umlEnumeration);
				addChild(umlEnumeration);
			}
		}
		
		protected function onSignalAdded(e:UmlEvent):void
		{
			if (UmlModel.getInstance().getSelectedProject().selectedNode.uid == uid)
			{
				var umlSignal:UmlViewSignal = null;
				umlSignal = new UmlViewSignal(e.getAddedElement(), uid);
				umlSignal.addEventListener(UmlEvent.PICKER_ADD_ASSOCIATION, onAssociationNew);
				_ownedElements.push(umlSignal);
				addChild(umlSignal);
			}
		}
		
		protected override function onElementDeleted(e:UmlEvent) : void
		{
			super.onElementDeleted(e);
			
			var element		:UmlViewElement		= null;
			var found		:Boolean			= false;
			
			for (var i:uint = 0; i < _ownedElements.length && !found; i++)
			{
				element = _ownedElements[i] as UmlViewElement;
				
				if (element.uid == e.getDeletedNode().uid)
				{
					UmlSelectionControler.getInstance().deselectElement(element);
					
					if (element.parent == null)
					{
						break;
					}
					
					if (element.parent == _selector)
					{
						swapToDiagram([element]);
					}
					
					element.dispose();
					delete _ownedElements.splice(i, 1);
					delete removeChild(element);
					element = null;
					found = true;
				}
			}
		}
		
		private function onClick(e:MouseEvent):void
		{
			if (!_isMouseMoved && UmlControler.getInstance().getMode() == "normal")
			{
				//UmlSelectionControler.getInstance().selectNode(this);
			}
		}
		
	}
	
}
