package view.core
{
	import flash.display.Sprite;
	import flash.geom.Point;
	
	import mx.collections.ArrayCollection;
	
	/**
	 * 
	 * @author kamal
	 * 
	 */
	public class UmlViewDashedLine extends UmlViewSolidLine
	{
		
		/**
		 * 
		 */
		protected var _masks			:ArrayCollection			= null;
		protected var _areMasksDirty	:Boolean					= false;
		
		/**
		 * 
		 * 
		 */
		public function UmlViewDashedLine()
		{
			super();
			
			//setLineTickness(5);
			_masks = new ArrayCollection();
		}
		
		protected override function commitProperties():void
		{
			super.commitProperties();
			
			if (_areMasksDirty)
			{
				updateMasks();
				_areMasksDirty = false;
			}
		}
		
		/**
		 * 
		 * 
		 */
		protected override function getDividedLinkIndex(link:Sprite):int
		{
			if (super.getDividedLinkIndex(link) < 0)
			{
				return _masks.getItemIndex(link);
			}
			else
			{
				return super.getDividedLinkIndex(link);
			}
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		protected override function addLink():Sprite
		{
			var addedMask:Sprite		= createMask();
			var addedLink:Sprite		= super.addLink();
			
			addedLink.cacheAsBitmap		= true;
			addedMask.cacheAsBitmap		= true;
			addedLink.mask				= addedMask;
			_areMasksDirty				= true;
			
			return addedLink;
		}
		
		protected override function removePointAt(index:int):void
		{
			super.removePointAt(index);
			
			if (index >= 1 && index < _masks.length)
			{
				delete this.removeChild(_masks.removeItemAt(index) as Sprite);
			}
			
			_areMasksDirty = true;
			invalidateProperties();
		}
		
		/**
		 * 
		 * @param link
		 * @param p1
		 * @param p2
		 * 
		 */
		protected override function drawLine(link:Sprite, p1:Point, p2:Point):void
		{
			super.drawLine(link, p1, p2);
			
			var aMask:Sprite = _masks.getItemAt(_links.getItemIndex(link)) as Sprite;
			paintMask(aMask, p1, p2);
			
			invalidateProperties();
		}
		
		/**
		 * 
		 * @param p_mask
		 * @param p1
		 * @param p2
		 * 
		 */
		protected function paintMask(p_mask:Sprite, firstPoint:Point, lastPoint:Point):void
		{
			var firstPosition	:Point = getMinPoint(firstPoint, lastPoint);
			var lastPosition	:Point = getMaxPoint(firstPoint, lastPoint);
			
			var i:uint = 0;
			
			with(p_mask.graphics)
			{
				clear();
				lineStyle(5, 0xFFFFFF, 1);
				
				if (getWidth(firstPosition, lastPosition) > getHeight(firstPosition, lastPosition))
				{
					// vertical lines 
					for (i = 0; i < (lastPosition.x - firstPosition.x) / 8; i++)
					{
						moveTo(i * 8 + firstPosition.x, firstPosition.y);
						lineTo(i * 8 + firstPosition.x, lastPosition.y);
					}
				}
				else
				{
					// horizontal lines 
					for (i = 0; i < (lastPosition.y - firstPosition.y) / 8; i++)
					{
						moveTo(firstPosition.x, i * 8 + firstPosition.y);
						lineTo(lastPosition.x, i * 8 + firstPosition.y);
					}
				}
				
				if (getWidth(firstPosition, lastPosition) <= 10)
				{
					for (i = 0; i < (lastPosition.y - firstPosition.y) / 8; i++)
					{
						moveTo(firstPosition.x - 5, i * 8 + firstPosition.y);
						lineTo(lastPosition.x + 5, i * 8 + firstPosition.y);
					}
				}
				
				if (getHeight(firstPosition, lastPosition) <= 10)
				{
					for (i = 0; i < (lastPosition.x - firstPosition.x) / 8; i++)
					{
						moveTo(i * 8 + firstPosition.x, firstPosition.y - 5);
						lineTo(i * 8 + firstPosition.x, lastPosition.y + 5);
					}
				}
			}
		}
		
		protected function getWidth(p1:Point, p2:Point):Number
		{
			return Math.abs(p1.x - p2.x);
		}
		
		protected function getHeight(p1:Point, p2:Point):Number
		{
			return Math.abs(p1.y - p2.y);
		}
		
		protected function getMinPoint(p1:Point, p2:Point):Point
		{
			return new Point(Math.min(p1.x, p2.x), Math.min(p1.y, p2.y));
		}
		
		protected function getMaxPoint(p1:Point, p2:Point):Point
		{
			return new Point(Math.max(p1.x, p2.x), Math.max(p1.y, p2.y));
		}
		
		protected function updateMasks():void
		{
			for (var i:uint = 0; i < _links.length; i++)
			{
				var l_link:Sprite = _links.getItemAt(i) as Sprite;
				var l_mask:Sprite = _masks.getItemAt(i) as Sprite;
				
				l_link.cacheAsBitmap	= true;
				l_mask.cacheAsBitmap	= true;
				l_link.mask				= l_mask;
			}
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		protected function createMask():Sprite
		{
			var aMask:Sprite = new Sprite();
			this.addChild(aMask);
			_masks.addItem(aMask);
			return aMask;
		}
		
	}
	
}
