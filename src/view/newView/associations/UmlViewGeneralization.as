package view.newView.associations
{
	import controler.UmlControler;
	import controler.UmlSelectionControler;
	import controler.UmlViewControler;
	
	import flash.events.MouseEvent;
	
	import view.core.UmlViewSolidLine;
	import view.newView.AioViewContextMenuItem;
	import view.newView.UmlViewDiagram;
	import view.umlView.UmlViewClass;
	
	/**
	 * 
	 * @author kamal
	 * 
	 */
	public class UmlViewGeneralization extends UmlViewAssociation
	{
		
		private var _itemMerge			:AioViewContextMenuItem		= null;
		private var _generalizationSet	:UmlViewGeneralizationSet	= null;
		
		
		/**
		 * 
		 * @param umlParent
		 * 
		 */
		public function UmlViewGeneralization(umlParent:UmlViewDiagram)
		{
			super(umlParent);
			
			_isUsingFilledArrow	= true;
			_areEndsAllowed		= false;
		}
		
		protected override function createLine():UmlViewSolidLine
		{
			return new UmlViewSolidLine();
		}
		
		protected override function onRightMouseDown(event:MouseEvent):void
		{
			if (UmlControler.getInstance().getMode() == "normal")
			{
				UmlSelectionControler.setCtrlKeyDown(event.ctrlKey);
				UmlSelectionControler.getInstance().selectElement(this);
			}
			
			createContextMenuRuntimeItems();
			super.onRightMouseDown(event);
		}
		
		protected override function createContextMenuRuntimeItems():void
		{
			super.createContextMenuRuntimeItems();
			
			var i						:int					= 0;
			var generalizationCount		:uint					= 0;
			var generalization			:UmlViewGeneralization	= null;
			var selectedAssociations	:Array					= null;
			var itemMergeIndex			:int					= 0;
			var isMergeValid			:Boolean				= true;
			
			selectedAssociations = UmlSelectionControler.getInstance().getSelectedAssociations();
			
			for (i = 0; i < selectedAssociations.length; i++)
			{
				if (selectedAssociations[i] is UmlViewGeneralization)
				{
					generalizationCount++;
					generalization = selectedAssociations[i] as UmlViewGeneralization;
					
					if (generalization.superClass != superClass)
					{
						isMergeValid = false;
					}
				}
			}
			
			if (generalizationCount == selectedAssociations.length && 
				generalizationCount >= 2 && 
				isMergeValid)
			{
				if (_contextMenuItems != null)
				{
					if (_itemMerge == null || 
						_contextMenuItems.indexOf(_itemMerge) < 0)
					{
						_itemMerge = new AioViewContextMenuItem("Merge");
						_itemMerge.addEventListener(MouseEvent.CLICK, onItemMergeClick);
						
						_contextMenuItems.push("-");
						_contextMenuItems.push(_itemMerge);
					}
				}
			}
			else
			{
				if (_itemMerge != null)
				{
					itemMergeIndex = _contextMenuItems.indexOf(_itemMerge);
					
					if (itemMergeIndex >= 0)
					{
						_contextMenuItems.splice(itemMergeIndex, 1);
					}
				}
			}
		}
		
		protected function onItemMergeClick(event:MouseEvent):void
		{
			var i						:int					= 0;
			var isMergeValid			:Boolean				= true;
			var selectedGeneralizations	:Array					= null;
			var generalizationCount		:int					= 0;
			var generalization			:UmlViewGeneralization	= null;
			
			selectedGeneralizations = UmlSelectionControler.getInstance().getSelectedAssociations();
			
			for (i = 0; i < selectedGeneralizations.length; i++)
			{
				if (selectedGeneralizations[i] is UmlViewGeneralization)
				{
					generalizationCount++;
					generalization = selectedGeneralizations[i];
					
					if (generalization.superClass != superClass)
					{
						isMergeValid = false;
					}
				}
			}
			
			if (isMergeValid && 
				generalizationCount >= 2 && 
				generalizationCount == selectedGeneralizations.length)
			{
				_ownerDiagram.verticalMergeGeneralizations(superClass, selectedGeneralizations);
			}
		}
		
		protected override function paintFirstArrow():void
		{
			//rien
		}
		
		protected override function paintLastArrow():void
		{
			drawArrow(_lastArrow);
		}
		
		public function get superClass():UmlViewClass
		{
			if (_classifiers != null && _classifiers.length >= 2)
			{
				return _classifiers[1] as UmlViewClass;
			}
			
			return null;
		}
		public function set superClass(value:UmlViewClass):void
		{
			if (_classifiers != null && _classifiers.length >= 2)
			{
				_classifiers[1] = value;
			}
		}
		
		public function get subClass():UmlViewClass
		{
			if (_classifiers != null && _classifiers.length >= 2)
			{
				return _classifiers[0] as UmlViewClass;
			}
			
			return null;
		}
		public function set subClass(value:UmlViewClass):void
		{
			if (_classifiers != null && _classifiers.length >= 2)
			{
				_classifiers[0] = value;
			}
		}
		
	}
	
}
