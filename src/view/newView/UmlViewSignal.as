package view.newView
{
	import controler.UmlControler;
	import controler.events.UmlEvent;
	
	import flash.display.DisplayObject;
	
	import model.IUmlModelElement;
	import model.UmlModel;
	
	import mx.events.FlexEvent;
	
	/**
	 * 
	 * @author kamal
	 * 
	 */
	public class UmlViewSignal extends UmlViewClassifier
	{
		
		/**
		 * 
		 */
		protected var _signalAttributes		:Array		= null;
		
		
		/**
		 * 
		 * @param xml
		 * @param parentUID
		 * 
		 */
		public function UmlViewSignal(modelElement:IUmlModelElement, parentUID:String)
		{
			super(modelElement,  parentUID);
			
			_signalAttributes		= new Array();
		}
		
		
		/*******************************************************************************************
		 * 
		 * overriden functions 
		 * 
		 ******************************************************************************************/
		
		/**
		 * 
		 * 
		 */
		protected override function createChildren():void
		{
			super.createChildren();
			
			_title.setText(name);
			_title.setStereotype("<<signal>>");
		}
		
		public override function addChild(child:DisplayObject):DisplayObject
		{
			return null;
		}
		
		public override function requestAddField():void
		{
			super.requestAddField();
			
			UmlControler.getInstance().addSignalAttribute
			(
				uid, 
				"mySignalAttribute" + _numFields, 
				"String", 
				"cool"
			);
		}
		
		protected override function addField(umlField:UmlViewField):void
		{
			super.addField(umlField);
			_signalAttributes.push(umlField.xml);
			invalidateDisplayList();
		}
		
		/*******************************************************************************************
		 * 
		 * overriden callback functions 
		 * 
		 ******************************************************************************************/
		
		
		/**
		 * 
		 * @param e
		 * 
		 */
		protected override function onCreationComplete(e:FlexEvent):void
		{
			super.onCreationComplete(e);
		}
		
		protected override function onFieldAdded(e:UmlEvent):void
		{
			var umlSignalAttribute:UmlViewSignalAttribute = null;
			umlSignalAttribute = new UmlViewSignalAttribute(e.getAddedElement(), uid);
			addField(umlSignalAttribute);
		}
		
		/*******************************************************************************************
		 * 
		 * regular functions 
		 * 
		 ******************************************************************************************/
		
		
	}
	
}
