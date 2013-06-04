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
	public class UmlViewOperation extends UmlViewField
	{
		
		protected var _parameters			:Array			= null;
		protected var _strParams			:String			= "";
		
		/**
		 * 
		 * @param xml
		 * @param parentUID
		 * 
		 */
		public function UmlViewOperation(modelElement:IUmlModelElement, parentUID:String)
		{
			super(modelElement,  parentUID);
			
			_parameters = new Array();
			
			//updateContent();
			initListeners();
		}
		
		/*******************************************************************************************
		 * 
		 * overriden functions 
		 * 
		 ******************************************************************************************/
		
		protected override function initListeners():void
		{
			super.initListeners();
		}
		
		protected override function getFormattedName():String
		{
			var formattedContent	:String		= "";
			var paramsXmlList		:XMLList	= _modelElement.xml.children();
			
			// vide le tableau 
			//while (_parameters[0]) delete _parameters[0]; // foutage de gueule 
			_parameters		= [];
			_strParams		= "";
			
			if (paramsXmlList != null && paramsXmlList.length() > 0)
			{
				for (var i:int = 0; i < paramsXmlList[0].children().length(); i++)
				{
					var xparam:XML = paramsXmlList[0].children()[i] as XML;
					_strParams += String(xparam.@name) + ":" + String(xparam.@type) + ", ";
					_parameters.push(xparam);
				}
				
				if (_strParams.charAt(_strParams.length - 2) == ',')
				{
					_strParams = _strParams.substr(0, _strParams.length - 2);
				}
			}
			
			formattedContent = getVisibilitySymbol() + name + "(" + _strParams + "):" + getType();
			return formattedContent;
		}
		
		protected override function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
		}
		
		/*******************************************************************************************
		 * 
		 * overriden callback functions 
		 * 
		 ******************************************************************************************/
		
		protected override function onMouseDown(e:MouseEvent):void
		{
			super.onMouseDown(e);
			
//			if (!e.altKey && UmlControler.getInstance().getMode() == "normal")
//			{
//				UmlSelectionControler.setCtrlKeyDown(e.ctrlKey);
//				UmlSelectionControler.getInstance().selectNode(this);
//				
//				var event:UmlEvent = new UmlEvent(UmlEvent.NODE_SELECTED);
//				event.setSelectedNode(this);
//				dispatchEvent(event);
//				
//				UmlControler.getInstance().addListenerToApplication(KeyboardEvent.KEY_DOWN, onStageKeyDown);
//				
//				e.stopPropagation();
//			}
		}
		
		protected override function onCreationComplete(e:FlexEvent):void
		{
			super.onCreationComplete(e);
		}
		
		protected override function onViewFieldFormReady(e:UmlEvent):void
		{
			if (e.currentTarget is UmlViewFieldForm)
			{
				var fieldForm:UmlViewFieldForm = e.target as UmlViewFieldForm;
				
				UmlControler.getInstance().editFunction
				(
					getParentId(), 
					uid, 
					fieldForm.getName(), 
					fieldForm.getVisibility(), 
					fieldForm.getType(), 
					fieldForm.getParameters() 
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
		
		private function setFieldsByXml(xml:XML):void
		{
			name = String(xml.@name);
			
			var paramsXmlList		:XMLList		= xml.children();
			
			if (paramsXmlList && paramsXmlList.length() > 0)
			{
				// vide le tableau 
				_parameters = [];
				_strParams = "";
				
				for (var i:int = 0; i < paramsXmlList[0].children().length(); i++)
				{
					var xparam:XML = paramsXmlList[0].children()[i] as XML;
					_strParams += String(xparam.@name) + ":" + String(xparam.@type) + ", ";
					_parameters.push(xparam);
				}
				
				if (_strParams.charAt(_strParams.length - 2) == ',')
				{
					_strParams = _strParams.substr(0, _strParams.length - 2);
				}
			}
			
			/* getAccessorSymbole() + " " +  */
			_nameLabel.text	= name + "(" + _strParams + "):" + getType();
		}
		
		private function getAccessorSymbole():String
		{
			var accessorSymbole:String = (getVisibility() == "public") ? "+" : (getVisibility() == "private") ? "-" : "#";
			return accessorSymbole;
		}
		
		public function getParameters():Array
		{
			return _parameters;
		}
		
		/*******************************************************************************************
		 * 
		 * callback functions 
		 * 
		 ******************************************************************************************/
		
		protected function onFunctionClick(e:MouseEvent):void
		{
			if (UmlControler.getInstance().getMode() == "normal")
			{
				e.stopPropagation();
			}
		}
		
		protected function onStageKeyDown(e:KeyboardEvent):void
		{
//			if (e.keyCode == Keyboard.F2)
//			{
//				var selectedNodesCount:int = UmlSelectionControler.getInstance().getSelectedAttributes().length 
//											+ 
//											UmlSelectionControler.getInstance().getSelectedFunctions().length;
//				if (selectedNodesCount == 1)
//				{
//					onEditFunctionClick();
//				}
//			}
			
		}
		
	}
	
}
