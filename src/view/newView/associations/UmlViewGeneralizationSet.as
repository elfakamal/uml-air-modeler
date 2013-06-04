package view.newView.associations
{
	import model.IUmlModelElement;
	
	import view.newView.UmlViewClassifier;
	import view.newView.UmlViewDiagram;
	import view.newView.UmlViewElement;
	import view.umlView.UmlViewClass;
	
	public class UmlViewGeneralizationSet extends UmlViewElement
	{
		
		private var _superClass		:UmlViewClass		= null;
		private var _subClasses		:Array				= null;
		private var _ownerDiagram	:UmlViewDiagram		= null;
		
		public function UmlViewGeneralizationSet(owner:UmlViewDiagram)
		{
			super(null, "");
		}
		
		public function set superClass(value:UmlViewClass):void
		{
			_superClass = value;
		}
		public function get superClass():UmlViewClass
		{
			return _superClass;
		}
		
		public function addSubClass(subClass:UmlViewClass):void
		{
			if (_subClasses		!= null && 
				subClass		!= null && 
				_subClasses.indexOf(subClass) < 0 )
			{
				_subClasses.push(subClass);
			}
		}
		
		public function removeSubClass(subClass:UmlViewClass):void
		{
			if (_subClasses		!= null && 
				subClass		!= null && 
				_subClasses.indexOf(subClass) >= 0 )
			{
				_subClasses.push(subClass);
			}
		}
		
	}
	
}
