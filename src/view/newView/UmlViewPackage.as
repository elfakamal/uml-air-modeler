package view.newView
{
	import model.IUmlModelElement;
	
	import mx.events.FlexEvent;
	
	/**
	 * 
	 * @author kamal
	 * 
	 */
	public class UmlViewPackage extends UmlViewContainerNode
	{
		
		protected var _title			:UmlViewNodeTitle		= null;
		
		
		/**
		 * 
		 * @param xml
		 * @param parentUID
		 * 
		 */
		public function UmlViewPackage(modelElement:IUmlModelElement, parentUID:String)
		{
			super(modelElement,  parentUID);
			
			_title = new UmlViewNodeTitle();
			_title.doNotFitToParentSize();
			_title.setBackgroundAllowed(true);
		}
		
		
		/*******************************************************************************************
		 * 
		 * overriden functions 
		 * 
		 ******************************************************************************************/
		
		protected override function createChildren():void
		{
			super.createChildren();
			
			super.addChild(_title);
			_title.setText(name);
		}
		
		protected override function measure():void
		{
			super.measure();
			
			measuredWidth = measuredMinWidth = UmlViewElement.UML_DEFAULT_WIDTH;
			measuredHeight = measuredMinHeight = UmlViewElement.UML_DEFAULT_HEIGHT;//UML_DEFAULT_WIDTH / 2;
		}
		
		protected override function layoutChildren(p_width:Number, p_height:Number):void
		{
			super.layoutChildren(p_width, p_height);
			
			_title.x		= 0;
			_title.y		= 0;
			
			_background.x		= _globalHolder.x		= 0;
			_background.y		= _globalHolder.y		= _title.y + _title.getExplicitOrMeasuredHeight();
			_background.width	= _globalHolder.width	= p_width;
			_background.height	= _globalHolder.height	= p_height - _globalHolder.y;
		}
		
		protected override function paint(p_width:Number, p_height:Number):void
		{
			super.paint(p_width, p_height);
			
			with (_globalHolder.graphics)
			{
				clear();
				beginFill(0x222222, .5);
				drawRect(0, 0, _globalHolder.width, _globalHolder.height);
				endFill();
				lineStyle(1, 0x444444, 1);
				drawRect(0, 0, _globalHolder.width, _globalHolder.height);
			}
		}
		
		/*******************************************************************************************
		 * 
		 * overriden callback functions 
		 * 
		 ******************************************************************************************/
		
		protected override function onCreationComplete(e:FlexEvent):void
		{
			//super.onCreationComplete(e);
		}
		
		/*******************************************************************************************
		 * 
		 * regular functions 
		 * 
		 ******************************************************************************************/
		
		
		
	}
	
}
