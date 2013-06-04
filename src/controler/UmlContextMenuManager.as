package controler
{
	
	import flash.events.MouseEvent;
	
	import view.newView.AioViewContextMenu;
	import view.newView.AioViewContextMenuItem;
	
	
	public class UmlContextMenuManager
	{
		
		
		private var _currentContextMenu		:AioViewContextMenu		= null;
		private var _items					:Array					= null;
		private var _isContextMenuVisible	:Boolean				= false;
		
		
		public function UmlContextMenuManager()
		{
			
		}
		
		public function initialize():void
		{
			
		}
		
		internal function dispose():void
		{
			if (_items != null)
			{
				while (_items.length > 0)
				{
					delete _items[0];
				}
			}
			
			if (_currentContextMenu != null)
			{
				//_currentContextMenu.dispose(destroyContextMenu);
				_currentContextMenu.dispose();
			}
			
			_isContextMenuVisible = false;
		}
		
		private function destroyContextMenu():void
		{
			_currentContextMenu = null;
		}
		
		public function createContextMenuByItems():void
		{
			if (_currentContextMenu != null && _items != null && _items.length > 0)
			{
				for each (var item:* in _items)
				{
					if (item != null)
					{
						if (item is AioViewContextMenuItem)
						{
							_currentContextMenu.addItem(item);
						}
						else if (item is String)
						{
							_currentContextMenu.addSeparator();
						}
					}
				}
			}
		}
		
		public function showContextMenu(menuItems:Array):void
		{
			hideCurrentContextMenu();
			
			if (menuItems != null)
			{
				_items = menuItems;
				
				if (_currentContextMenu == null)
				{
					_currentContextMenu = new AioViewContextMenu();
				}
				else
				{
					_currentContextMenu.removeAllItems();
				}
				
				createContextMenuByItems();
				
				if (!UmlViewControler.getApplication().contains(_currentContextMenu))
				{
					UmlViewControler.getApplication().addChild(_currentContextMenu);
				}
				
				UmlViewControler.getApplication().addEventListener
				(
					MouseEvent.MOUSE_DOWN, 
					onApplicationMouseDown
				);
				
				_currentContextMenu.x = UmlViewControler.getApplication().mouseX;
				_currentContextMenu.y = UmlViewControler.getApplication().mouseY;
				
				_currentContextMenu.show();
				
				_isContextMenuVisible = true;
			}
			else
			{
				trace ("error : the menu is Null");
			}
		}
		
		private function interalShowContextMenu():void
		{
			if (_currentContextMenu != null)
			{
				if (!UmlViewControler.getApplication().contains(_currentContextMenu))
				{
					UmlViewControler.getApplication().addChild(_currentContextMenu);
				}
				
				UmlViewControler.getApplication().addEventListener
				(
					MouseEvent.MOUSE_DOWN, 
					onApplicationMouseDown
				);
				
				_currentContextMenu.x = UmlViewControler.getApplication().mouseX;
				_currentContextMenu.y = UmlViewControler.getApplication().mouseY;
				
				_currentContextMenu.show();
			}
		}
		
		private function onApplicationMouseDown(event:MouseEvent):void
		{
			disposeCurrentContextMenu();
			
			UmlViewControler.getApplication().removeEventListener
			(
				MouseEvent.MOUSE_DOWN, 
				onApplicationMouseDown
			);
		}
		
		public function hideCurrentContextMenu():void
		{
			if (_currentContextMenu != null && _currentContextMenu.parent != null)
			{
				_currentContextMenu.parent.removeChild(_currentContextMenu);
			}
			
			_isContextMenuVisible = false;
		}
		
		public function isThereAContextMenu():Boolean
		{
			return _isContextMenuVisible;
		}
		
		public function disposeCurrentContextMenu():void
		{
			if (_currentContextMenu != null)
			{
				_currentContextMenu.dispose(hideCurrentContextMenu);
			}
			
			_isContextMenuVisible = false;
		}
		
	}
	
}
