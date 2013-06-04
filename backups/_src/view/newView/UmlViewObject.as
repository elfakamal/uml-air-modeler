package view.newView
{
	import flash.display.DisplayObject;
	
	import mx.containers.Canvas;
	import mx.controls.Label;
	import mx.core.ScrollPolicy;
	import mx.events.FlexEvent;
	
	/**
	 * 
	 * @author kamal
	 * 
	 */
	public class UmlViewObject extends UmlViewRegularNode
	{
		
		/**
		 * 
		 */
		protected var _holder				:Canvas		= null;
		protected var _stereotypeLabel		:Label		= null;
		protected var _nameLabel			:Label		= null;
		
		protected var _isContentDirty		:Boolean	= true;
		
		/**
		 * 
		 * @param xml
		 * @param parentUID
		 * 
		 */
		public function UmlViewObject(modelElement:IUmlModelElement, parentUID:String)
		{
			super(modelElement,  parentUID);
			
			_isTitleAllowed		= false;
			
			_holder				= new Canvas();
			_stereotypeLabel	= new Label();
			_nameLabel			= new Label();
			
			_nameLabel.setStyle("fontWeight", "bold");
			
			_holder.horizontalScrollPolicy	= ScrollPolicy.OFF;
			_holder.verticalScrollPolicy	= ScrollPolicy.OFF;
			
			_nameLabel.text			= name;
			initStereotypeLabel();
		}
		
		/*******************************************************************************************
		 * 
		 * overriden functions 
		 * 
		 ******************************************************************************************/
		
		/**
		 * 
		 * @param child
		 * @return 
		 * 
		 */
		public override function addChild(child:DisplayObject):DisplayObject
		{
			return null;
		}
		
		/**
		 * 
		 * 
		 */
		protected override function createChildren():void
		{
			super.createChildren();
			
			_holder.addChild(_stereotypeLabel);
			_holder.addChild(_nameLabel);
			
			super.addChild(_holder);
		}
		
		/**
		 * 
		 * 
		 */
		protected override function commitProperties():void
		{
			super.commitProperties();
		}
		
		/**
		 * 
		 * 
		 */
		protected override function measure():void
		{
			super.measure();
			
			var maxLabelsWidth:Number;
			maxLabelsWidth = Math.max(_stereotypeLabel.width, _nameLabel.width);
			
			measuredWidth	= measuredMinWidth	= maxLabelsWidth + 2 * HORIZONTAL_MARGIN;
			measuredHeight	= measuredMinHeight	= 50;
		}
		
		/**
		 * 
		 * @param unscaledWidth
		 * @param unscaledHeight
		 * 
		 */
		protected override function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
		}
		
		/**
		 * 
		 * @param p_width
		 * @param p_height
		 * 
		 */
		protected override function layoutChildren(p_width:Number, p_height:Number):void
		{
			super.layoutChildren(p_width, p_height);
			
			_holder.width		= p_width;
			_holder.height		= _nameLabel.height + _stereotypeLabel.height;
			_holder.x			= 0;
			_holder.y			= p_height/2 - _holder.height/2;
			
			_stereotypeLabel.x	= _holder.width/2 - _stereotypeLabel.width/2;
			_stereotypeLabel.y	= 0;
			
			_nameLabel.x		= _holder.width/2 - _nameLabel.width/2;
			_nameLabel.y		= _stereotypeLabel.y + _stereotypeLabel.height;
		}
		
		/**
		 * 
		 * 
		 */
		protected override function initListeners():void
		{
			super.initListeners();
		}
		
		/**
		 * 
		 * @param p_width
		 * @param p_height
		 * 
		 */
//		protected override function paint(p_width:Number, p_height:Number):void
//		{
//			graphics.clear();
//			var gradientMatrix:Matrix = new Matrix();
//			gradientMatrix.createGradientBox
//			(
//				p_width, 
//				p_height, 
//				UmlFormsControler.toRadians(90)
//			);
//			graphics.beginGradientFill
//			(
//				GradientType.LINEAR, 
//				[0x333333, 0x111111], 
//				[1, 1], 
//				[10, 255], 
//				gradientMatrix
//			);
//			graphics.drawRoundRect(0, 0, p_width, p_height, 2, 2);
//			graphics.endFill();
//			graphics.lineStyle(1, 0x444444, 1);
//			graphics.drawRoundRect(0, 0, p_width, p_height, 2, 2);
//		}
		
		/**
		 * 
		 * @param value
		 * 
		 */
		public override function setName(value:String):void
		{
			super.setName(value);
			updateContent();
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
			//filters = [new GlowFilter(0x000000, 1, 2, 2, 2, 10)];
		}
		
		
		/*******************************************************************************************
		 * 
		 * regular functions 
		 * 
		 ******************************************************************************************/
		
		/**
		 * 
		 * 
		 */
		protected function initStereotypeLabel():void
		{
			_stereotypeLabel.text	= "<<Object>>";
		}
		
		/**
		 * 
		 * 
		 */
		protected override function updateContent(usingXml:Boolean=true):void
		{
			super.updateContent(usingXml);
			
			_nameLabel.text = name;
			
			_isContentDirty = true;
			invalidateProperties();
		}
		
		/*******************************************************************************************
		 * 
		 * callback functions 
		 * 
		 ******************************************************************************************/
		
		
		
	}
	
}
