package view.umlView
{
	import controler.UmlControler;
	import controler.events.UmlEvent;
	
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	
	import model.IUmlModelElement;
	
	import mx.events.FlexEvent;
	
	import view.newView.UmlViewField;
	import view.panels.UmlViewFieldForm;
	
	/**
	 * 
	 * @author kamal
	 * 
	 */
	public class UmlViewAttribute extends UmlViewField
	{
		
		/**
		 * 
		 * @param xml
		 * @param parentUID
		 * 
		 */
		public function UmlViewAttribute(modelElement:IUmlModelElement, parentUID:String)
		{
			super(modelElement,  parentUID);
		}
		
		/*******************************************************************************************
		 * 
		 * overriden functions 
		 * 
		 ******************************************************************************************/
		
		protected override function initListeners():void
		{
			super.initListeners();
			addEventListener(MouseEvent.CLICK, onAttributeClick);
			
			addEventListener(MouseEvent.DOUBLE_CLICK, onAttributeDoubleClick);
		}
		
		protected override function getFormattedName():String
		{
			var formattedContent:String = "";
			formattedContent = getVisibilitySymbol() + name + ":" + getType();
			return formattedContent;
		}
		
		protected override function updateDisplayList(w:Number, h:Number):void
		{
			super.updateDisplayList(w, h);
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
		
		/**
		 * 
		 * @param e
		 * 
		 */
		protected override function onViewFieldFormReady(e:UmlEvent):void
		{
			if (e.currentTarget is UmlViewFieldForm)
			{
				var fieldForm:UmlViewFieldForm = e.target as UmlViewFieldForm;
				UmlControler.getInstance().editAttribute
				(
					getParentId(), 
					uid, 
					fieldForm.getName(), 
					fieldForm.getVisibility(), 
					fieldForm.getType()
				);
				
				fieldForm.removeEventListener(UmlEvent.VIEW_FIELD_FORM_READY, onViewFieldFormReady);
				
				// TODO : détruire le fieldform (dans la mémoire biensur)
			}
		}
		
		/*******************************************************************************************
		 * 
		 * regular functions 
		 * 
		 ******************************************************************************************/
		
		public function setFieldsByXml(xml:XML):void
		{
			name = String(xml.@name);
			
			_nameLabel.text = name + " : " + getType();
		}
		
		protected function getVisibilitySymbole():String
		{
			var visibilitySymbole:String = "";//(_visibility == "public") ? "+" : (_visibility == "private") ? "-" : "#";
			return visibilitySymbole;
		}
		
		/*******************************************************************************************
		 * 
		 * callback functions 
		 * 
		 ******************************************************************************************/
		
		protected function onAttributeClick(e:MouseEvent):void
		{
			if (UmlControler.getInstance().getMode() == "normal")
			{
				e.stopPropagation();
			}
		}
		
		protected function onAttributeDoubleClick(e:MouseEvent):void
		{
			trace (modelElement.xmi.toXMLString());
			e.stopPropagation();
		}
		
		protected function onStageKeyDown(e:KeyboardEvent):void
		{
//			if (e.keyCode == Keyboard.F2)
//			{
//				var selectedNodesCount:int = 	UmlSelectionControler.getInstance().getSelectedAttributes().length 
//												+ 
//												UmlSelectionControler.getInstance().getSelectedFunctions().length;
//				if (selectedNodesCount == 1)
//				{
//					onEditAttributeClick();
//				}
//			}
		}
		
		protected override function onMouseDown(e:MouseEvent):void
		{
			super.onMouseDown(e);
//			if (!e.altKey && UmlControler.getInstance().getMode() == "normal")
//			{
//				e.stopPropagation();
//			}
		}
		
	}
	
}
