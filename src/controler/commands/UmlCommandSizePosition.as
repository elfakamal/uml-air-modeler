package controler.commands
{
	import controler.namespaces.commander;
	import controler.namespaces.model;
	
	import flash.geom.Point;
	
	import model.IUmlModelClassifier;
	import model.IUmlModelElement;
	import model.IUmlModelType;
	import model.UmlModel;
	
	import view.IUmlViewElement;
	
	/**
	 * 
	 * @author kamal
	 * 
	 */
	public class UmlCommandSizePosition extends UmlCommandUndoRedoAbstract
	{
		
		protected var _viewElement			:IUmlViewElement	= null;
		
		protected var _width				:Number				= 0;
		protected var _height				:Number				= 0;
		
		protected var _position				:Point				= null;
		
		
		
		public function UmlCommandSizePosition(element:IUmlViewElement)
		{
			super();
			
			_viewElement = element;
		}
		
		
		public override function execute():void
		{
			
			super.execute();
		}
		
		
		public function set viewElement(value:IUmlViewElement):void
		{
			_viewElement = value;
		}
		public function get viewElement():IUmlViewElement
		{
			return _viewElement;
		}
		
	}
	
}
