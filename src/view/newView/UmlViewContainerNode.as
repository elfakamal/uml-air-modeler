package view.newView
{
	import model.IUmlModelElement;
	
	import mx.containers.Canvas;
	import mx.core.ScrollPolicy;
	import mx.events.FlexEvent;
	
	public class UmlViewContainerNode extends UmlViewElement
	{
		
		
		protected var _numNodes				:uint			= 0;
		
		/**
		 * 
		 */
		protected var _globalHolder			:Canvas		= null;
		
		/**
		 * 
		 * @param xml
		 * @param parentUID
		 * 
		 */
		public function UmlViewContainerNode(modelElement:IUmlModelElement, parentUID:String)
		{
			super(modelElement,  parentUID);
			
			_globalHolder		= new Canvas();
			
			_globalHolder.horizontalScrollPolicy	= ScrollPolicy.OFF;
			_globalHolder.verticalScrollPolicy		= ScrollPolicy.OFF;
			
			_isSuperDragAllowed = false;
		}
		
		/*******************************************************************************************
		 * 
		 * overriden functions 
		 * 
		 ******************************************************************************************/
		
		protected override function createChildren():void
		{
			super.createChildren();
			
			super.addChild(_globalHolder);
		}
		
		protected override function paint(p_width:Number, p_height:Number):void
		{
			super.paint(p_width, p_height);
			
			with (_background.graphics)
			{
//				clear();
//				beginFill(0x222222, 1);
//				drawRect(0, 0, _background.width, _background.height);
//				endFill();
			}
		}
		
		public override function showSelectionColor():void
		{
			
		}
		
		public override function hideSelectionColor():void
		{
			
		}
		
		/*******************************************************************************************
		 * 
		 * overriden callback functions 
		 * 
		 ******************************************************************************************/
		
		protected override function onCreationComplete(e:FlexEvent):void
		{
			// rien pour l'instant 
		}
		
		/*******************************************************************************************
		 * 
		 * regular functions 
		 * 
		 ******************************************************************************************/
		
		
		
	}
	
}
