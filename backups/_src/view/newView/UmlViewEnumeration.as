package view.newView
{
	
	import controler.UmlControler;
	import controler.events.UmlEvent;
	
	import flash.display.DisplayObject;
	
	import model.IUmlModelElement;
	import model.UmlModel;
	
	import mx.events.FlexEvent;
	
	public class UmlViewEnumeration extends UmlViewRegularNode
	{
		
		/**
		 * 
		 */
		protected var _enumerationLiterals		:Array				= null;
		
		
		/**
		 * 
		 * @param xml
		 * @param parentUID
		 * 
		 */
		public function UmlViewEnumeration(modelElement:IUmlModelElement, parentUID:String)
		{
			super(modelElement,  parentUID);
			
			_enumerationLiterals	= new Array();
		}
		
		
		/*******************************************************************************************
		 * 
		 * overriden functions 
		 * 
		 ******************************************************************************************/
		
		
		protected override function createChildren():void
		{
			super.createChildren();
			
			super.addChild(_border);
			_title.setText(name);
			_title.setStereotype("<<enumeration>>");
		}
		
		protected override function initListeners():void
		{
			super.initListeners();
		}
		
		public override function addChild(child:DisplayObject):DisplayObject
		{
			return null;
		}
		
		protected override function measure():void
		{
			super.measure();
		}
		
		protected override function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
		}
		
		protected override function layoutChildren(p_width:Number, p_height:Number):void
		{
			super.layoutChildren(p_width, p_height);
		}
		
		protected override function addField(umlField:UmlViewField):void
		{
			super.addField(umlField);
			_enumerationLiterals.push(umlField.xml);
			invalidateDisplayList();
		}
		
		public override function requestAddField():void
		{
			super.requestAddField();
			
			UmlControler.getInstance().addEnumerationLiteral
			(
				uid, 
				"myEnumLiteral" + _numFields, 
				"String", 
				"cool"
			);
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
			var umlEnumerationLiteral:UmlViewEnumerationLiteral = null;
			umlEnumerationLiteral = new UmlViewEnumerationLiteral(e.getAddedElement(), uid);
			addField(umlEnumerationLiteral);
		}
		
		/*******************************************************************************************
		 * 
		 * regular functions 
		 * 
		 ******************************************************************************************/
		
		
		
		/*******************************************************************************************
		 * 
		 * callback functions 
		 * 
		 ******************************************************************************************/
		
		
		
	}
	
}
