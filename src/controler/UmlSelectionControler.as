package controler
{
	import controler.events.UmlEvent;
	import controler.namespaces.selector;
	
	import flash.events.EventDispatcher;
	
	import model.IUmlModelDiagram;
	import model.IUmlModelElement;
	import model.UmlModel;
	
	import view.IUmlViewElement;
	import view.newView.UmlViewContainerNode;
	import view.newView.UmlViewDiagram;
	import view.newView.UmlViewEnumeration;
	import view.newView.UmlViewEnumerationLiteral;
	import view.newView.UmlViewField;
	import view.newView.UmlViewPackage;
	import view.newView.UmlViewProjectWorkspace;
	import view.newView.UmlViewClassifier;
	import view.newView.UmlViewSignal;
	import view.newView.UmlViewSignalAttribute;
	import view.newView.associations.UmlViewAssociation;
	import view.newView.associations.UmlViewAssociationEnd;
	import view.umlView.UmlViewAttribute;
	import view.umlView.UmlViewClass;
	import view.umlView.UmlViewConstant;
	import view.umlView.UmlViewInterface;
	import view.umlView.UmlViewOperation;

	/**
	 * 
	 * @author kamal
	 * 
	 */
	public class UmlSelectionControler extends EventDispatcher
	{
		
		public static const COLLISION_TEST			:uint			= 1;
		public static const ALL						:uint			= 2;
		
		protected static var _instance				:UmlSelectionControler = null;
		protected static var _ctrlKeyDown			:Boolean		= false;
		
		protected var _selectedProjects				:Array			= null;
		
		protected var _selectedDiagrams				:Array			= null;
		protected var _selectedPackages				:Array			= null;
		
		protected var _selectedClasses				:Array			= null;
		protected var _selectedInterfaces			:Array			= null;
		protected var _selectedEnumeration			:Array			= null;
		protected var _selectedSignals				:Array			= null;
		
		protected var _selectedAssociations			:Array			= null;
		
		protected var _selectedOperations			:Array			= null;
		protected var _selectedAttributes			:Array			= null;
		protected var _selectedEnumerationLiterals	:Array			= null;
		protected var _selectedSignalAttributes		:Array			= null;
		
		protected var _selectedAssociationEnds		:Array			= null;
		
		
		/**
		 * 
		 * @param lock
		 * 
		 */
		public function UmlSelectionControler(lock:Lock)
		{
			_selectedProjects				= new Array();
			_selectedDiagrams				= new Array();
			_selectedPackages				= new Array();
			
			_selectedClasses				= new Array();
			_selectedInterfaces				= new Array();
			_selectedEnumeration			= new Array();
			_selectedSignals				= new Array();
			
			_selectedAssociations			= new Array();
			_selectedAssociationEnds		= new Array();
			
			_selectedOperations				= new Array();
			_selectedAttributes				= new Array();
			_selectedEnumerationLiterals	= new Array();
			_selectedSignalAttributes		= new Array();
		}
		
		public static function getInstance():UmlSelectionControler
		{
			if(_instance)
			{
				return _instance;
			}
			else
			{
				_instance = new UmlSelectionControler(new Lock());
				return _instance;
			}
		}
		
		/**
		 * 
		 * @param node
		 * @return 
		 * 
		 */
		public function isSelected(element:IUmlViewElement):Boolean
		{
			return element.isSelected();
			
			if (
					_selectedProjects.some(searchElement)			||
					_selectedDiagrams.some(searchElement)			||
					_selectedClasses.some(searchElement)			||
					_selectedInterfaces.some(searchElement)			||
					_selectedAssociations.some(searchElement)		||
					_selectedOperations.some(searchElement)			||
					_selectedAttributes.some(searchElement)
				)
			{
				return true;
			}
			else
			{
				return false;
			}
			
			function searchElement(element:*, i:int, nodes:Array):Boolean
			{
				return element == element;
			}
		}
		
		/**
		 * 
		 * @param node
		 * 
		 */
		public function selectElement(element:IUmlViewElement):void
		{
			switch (true)
			{
				case (element is UmlViewContainerNode) : 
					
					deselectRegularNodes();
					deselectFields();
					
					if (!_ctrlKeyDown && !isSelected(element))
					{
						deselectContainerElements();
					}
					if (!isSelected(element))
					{
						if (element is UmlViewProjectWorkspace)
						{
							_selectedProjects.push(element);
							element.setSelected(true);
						}
						else if (element is UmlViewDiagram)
						{
							// séléction du diagramme dans le model.
							var modelDiagram:IUmlModelElement = null;
							modelDiagram = UmlControler.getInstance().getNodeById
							(
								element.uid, 
								UmlModel.getInstance().ownedElements
							);
							
							use namespace selector;
							
							UmlModel.getInstance().getSelectedProject().selectedNode = modelDiagram as IUmlModelDiagram;
							
							// ajout du diagramme à l'ensemble des diagrammes.
							_selectedDiagrams.push(element);
							element.setSelected(true);
						}
					}
					
				break;
				case (element is UmlViewClassifier) : 
					
					if (!_ctrlKeyDown && !isSelected(element))
					{
						deselectRegularNodes();
						deselectFields();
					}
					if (!isSelected(element))
					{
						if (element is UmlViewClass)
						{
							_selectedClasses.push(element);
						}
						else if (element is UmlViewInterface)
						{
							_selectedInterfaces.push(element);
						}
						else if (element is UmlViewEnumeration)
						{
							_selectedEnumeration.push(element);
						}
						else if (element is UmlViewSignal)
						{
							_selectedSignals.push(element);
						}
						
						element.setSelected(true);
					}
					
				break;
				case (element is UmlViewAssociation) :
					
					if (!_ctrlKeyDown && !isSelected(element))
					{
						deselectRegularNodes();
						deselectFields();
					}
//					deselectFields();
					if (!isSelected(element))
					{
						_selectedAssociations.push(element);
						element.setSelected(true);
					}
					
				break;
				case (element is UmlViewField) : 
					
					if (!_ctrlKeyDown)
					{
						deselectRegularNodes();
						deselectFields();
					}
					
					if (!isSelected(element))
					{
						if (element is UmlViewAttribute		|| 
							element is UmlViewConstant		|| 
							element is UmlViewAssociationEnd)
						{
							_selectedAttributes.push(element);
						}
						else if (element is UmlViewOperation)
						{
							_selectedOperations.push(element);
						}
						else if (element is UmlViewEnumerationLiteral)
						{
							_selectedEnumerationLiterals.push(element);
						}
						else if (element is UmlViewSignalAttribute)
						{
							_selectedSignalAttributes.push(element);
						}
						
						element.setSelected(true);
					}
					
				break;
				case (element is UmlViewAssociationEnd) : 
					
					if (!_ctrlKeyDown)
					{
						deselectRegularNodes();
						deselectFields();
					}
					if (!isSelected(element))
					{
						_selectedAssociationEnds.push(element);
						
						element.setSelected(true);
					}
					
				break;
			}
			
			UmlControler.getInstance().listenToKeyboard();
		}
		
		/**
		 * 
		 * @param node
		 * 
		 */
		public function deselectElement(element:IUmlViewElement):void
		{
			if (isSelected(element))
			{
				switch (true)
				{
					case (element is UmlViewContainerNode) :
						
						if (element is UmlViewProjectWorkspace)
						{
							if (_selectedProjects.indexOf(element) >= 0)
							{
								_selectedProjects.splice(_selectedProjects.indexOf(element), 1);
							}
						}
						else if (element is UmlViewDiagram)
						{
							if (_selectedDiagrams.indexOf(element) >= 0)
							{
								_selectedDiagrams.splice(_selectedDiagrams.indexOf(element), 1);
							}
						}
						else if (element is UmlViewPackage)
						{
							if (_selectedPackages.indexOf(element) >= 0)
							{
								_selectedPackages.splice(_selectedPackages.indexOf(element), 1);
							}
						}
						
					break;
					
					case (element is UmlViewClassifier) : 
						
						if (element is UmlViewClass)
						{
							if (_selectedClasses.indexOf(element) >= 0)
							{
								_selectedClasses.splice(_selectedClasses.indexOf(element), 1);
							}
						}
						else if (element is UmlViewInterface)
						{
							if (_selectedInterfaces.indexOf(element) >= 0)
							{
								_selectedInterfaces.splice(_selectedInterfaces.indexOf(element), 1);
							}
						}
						else if (element is UmlViewEnumeration)
						{
							if (_selectedEnumeration.indexOf(element) >= 0)
							{
								_selectedEnumeration.splice(_selectedEnumeration.indexOf(element), 1);
							}
						}
						else if (element is UmlViewSignal)
						{
							if (_selectedSignals.indexOf(element) >= 0)
							{
								_selectedSignals.splice(_selectedSignals.indexOf(element), 1);
							}
						}
						
					break;
					
					case (element is UmlViewAssociation) : 
						
						if (_selectedAssociations.indexOf(element) >= 0)
						{
							_selectedAssociations.splice(_selectedAssociations.indexOf(element), 1);
						}
						
					break;
					
					case (element is UmlViewField) : 
						
						if (element is UmlViewAttribute || element is UmlViewAssociationEnd)
						{
							if (_selectedAttributes.indexOf(element) >= 0)
							{
								_selectedAttributes.splice(_selectedAttributes.indexOf(element), 1);
							}
						}
						else if (element is UmlViewOperation)
						{
							if (_selectedOperations.indexOf(element) >= 0)
							{
								_selectedOperations.splice(_selectedOperations.indexOf(element), 1);
							}
						}
						else if (element is UmlViewEnumerationLiteral)
						{
							if (_selectedEnumerationLiterals.indexOf(element) >= 0)
							{
								_selectedEnumerationLiterals.splice(_selectedEnumerationLiterals.indexOf(element), 1);
							}
						}
						else if (element is UmlViewSignalAttribute)
						{
							if (_selectedSignalAttributes.indexOf(element) >= 0)
							{
								_selectedSignalAttributes.splice(_selectedSignalAttributes.indexOf(element), 1);
							}
						}
						
					break;
					
					case (element is UmlViewAssociationEnd) : 
						
						if (_selectedAssociationEnds.indexOf(element) >= 0)
						{
							_selectedAssociationEnds.splice(_selectedAssociationEnds.indexOf(element), 1);
						}
						
					break;
					
				}
				
				// set the node as unselceted
				element.setSelected(false);
				
				// dispatch the unselection event, 
				// it's listened from the node itself, 
				// or (if it's a field) from its parent. 
//				var umlEvent:UmlEvent = new UmlEvent(UmlEvent.ELEMENT_DESELECTED);
//				umlEvent.setDeselectedNode(element);
//				element.dispatchEvent(umlEvent);
			}
		}
		
		/**
		 * 
		 * 
		 */
		public function deselectRegularNodes():void
		{
			if (UmlControler.getInstance().getSelectedDiagram() != null && _selectedClasses.length > 0)
			{
				UmlControler.getInstance().getSelectedDiagram().swapToDiagram(_selectedClasses);
			}
			
			deselectElements(_selectedClasses);
			deselectElements(_selectedInterfaces);
			deselectElements(_selectedEnumeration);
			deselectElements(_selectedSignals);
			
			deselectElements(_selectedAssociations);
			
			_selectedClasses			= [];
			_selectedInterfaces			= [];
			_selectedEnumeration		= [];
			_selectedSignals			= [];
			
			
			_selectedAssociations		= [];
		}
		
		public function deselectFields():void
		{
			deselectElements(_selectedAttributes);
			deselectElements(_selectedOperations);
			deselectElements(_selectedEnumerationLiterals);
			deselectElements(_selectedSignalAttributes);
			deselectElements(_selectedAssociationEnds);
			
			_selectedAttributes				= [];
			_selectedOperations				= [];
			_selectedEnumerationLiterals	= [];
			_selectedSignalAttributes		= [];
			_selectedAssociationEnds		= [];
		}
		
		public function deselectContainerElements():void
		{
			deselectElements(_selectedDiagrams);
			deselectElements(_selectedPackages);
			
			_selectedDiagrams = [];
			_selectedPackages = [];
		}
		
		protected function deselectElements(elements:Array):void
		{
			for (var i:int = elements.length - 1; elements.length > 0; i--)
			{
				var node:IUmlViewElement = elements[i] as IUmlViewElement;
				deselectElement(node);
			}
		}
		
		public function deselectAllElements():void
		{
			for each (var umlDiagram:UmlViewDiagram in _selectedDiagrams)
			{
				deselectElement(umlDiagram);
			}
			
			_selectedDiagrams = [];
			
			deselectRegularNodes();
			deselectFields();
		}
		
		////////////////////////////////////////////
		
		public static function isCtrlKeyDown():Boolean
		{
			return _ctrlKeyDown;
		}
		public static function setCtrlKeyDown(value:Boolean):void
		{
			_ctrlKeyDown = value;
		}
		
		//////////////////////////////////////////////
		
		public function getSelectedContainerElements():Array
		{
			return _selectedProjects.concat(_selectedDiagrams, _selectedPackages);
		}
		
		public function getSelectedRegularNodes():Array
		{
			var elements:Array = new Array();
			
			elements = elements.concat
			(
				_selectedClasses, 
				_selectedInterfaces, 
				_selectedEnumeration, 
				_selectedSignals 
			);
			
			return elements;
		}
		
		public function getSelectedFeatures():Array
		{
			return _selectedAttributes.concat
			(
				_selectedOperations, 
				_selectedEnumerationLiterals, 
				_selectedSignalAttributes, 
				_selectedAssociationEnds
			);
		}
		
		public function getSelectedAssociations():Array
		{
			return _selectedAssociations;
		}
		
		public function getSelectedDiagrams():Array
		{
			return _selectedDiagrams;
		}
		
		public function getSelectedClasses():Array
		{
			return _selectedClasses;
		}
		
		public function getSelectedInterfaces():Array
		{
			return _selectedInterfaces;
		}
		
		public function getSelectedOperation():Array
		{
			return _selectedOperations;
		}
		
		public function getSelectedAttributes():Array
		{
			return _selectedAttributes;
		}
		
	}
	
}


class Lock
{
	public function Lock()
	{
		
	}
}
