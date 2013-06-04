package controler
{
	import com.greensock.TweenMax;
	
	import flash.errors.MemoryError;
	import flash.geom.Point;
	
	import mx.containers.Canvas;
	import mx.core.Application;
	import mx.core.UIComponent;
	
	import view.newView.LayoutWindowedApplication;
	import view.newView.UmlViewElement;
	import view.newView.UmlViewWindow;
	import view.panels.UmlViewAttributeForm;
	import view.panels.UmlViewClassForm;
	import view.panels.UmlViewFunctionForm;
	import view.panels.UmlViewInterfaceForm;
	
	public class UmlViewControler 
	{
		
		private static var _instance		:UmlViewControler			= null;
		private static var _application		:LayoutWindowedApplication	= null;
		
		
		private var _isCreateClassVisible		:Boolean			= false;
		private var _isCreateInterfaceVisible	:Boolean			= false;
		private var _isCreateAttributeVisible	:Boolean			= false;
		private var _isCreateFunctionVisible	:Boolean			= false;
		private var _isCreateAssociationVisible	:Boolean			= false;
		
		private var _contextMenuManager			:UmlContextMenuManager	= null;
		
		
		public function UmlViewControler(lock:Lock)
		{
			_contextMenuManager	= new UmlContextMenuManager();
			_application		= Application.application as LayoutWindowedApplication;
		}
		
		public static function getInstance():UmlViewControler
		{
			if(_instance)
			{
				return _instance;
			}
			else
			{
				_instance = new UmlViewControler(new Lock());
				return _instance;
			}
		}
		
		public function getContextMenuManager():UmlContextMenuManager
		{
			return _contextMenuManager;
		}
		
		public static function getApplication():LayoutWindowedApplication
		{
			return _application;
		}
		
		public function showContextMenu(items:Array):void
		{
			if (_contextMenuManager != null)
			{
				_contextMenuManager.showContextMenu(items);
			}
		}
		
		public function isThereAContextMenu():Boolean
		{
			if (_contextMenuManager != null)
			{
				return _contextMenuManager.isThereAContextMenu();
			}
			
			return false;
		}
		
		public function disposeCurrentContextMenu():void
		{
			if (_contextMenuManager != null)
			{
				_contextMenuManager.disposeCurrentContextMenu();
			}
		}
		
		/**
		 * 
		 * @param form
		 * @return 
		 * 
		 */
		public function show(form:UIComponent):UmlViewWindow
		{
			var modalWindow:Canvas		= new Canvas();
			var window:UmlViewWindow	= new UmlViewWindow();
			
			window.setType(UmlViewWindow.INDEPENDENT_WINDOW);
			modalWindow.setStyle("backgroundColor", "#000000");
			modalWindow.alpha = 0.5;
			
			Application.application.getSelectedProjectWorkspace().addChild(modalWindow);
			Application.application.getSelectedProjectWorkspace().addChild(window);
			
			modalWindow.x = 0;
			modalWindow.y = 0;
			modalWindow.width	= Application.application.getSelectedProjectWorkspace().width; 
			modalWindow.height	= Application.application.getSelectedProjectWorkspace().height;
			
			window.setContent(form);
			
			return window;
		}
		
		/**
		 * 
		 * @param o
		 * 
		 */
		public function killTweenOnObject(o:Object):void
		{
			if (TweenMax.getTweensOf(o).length > 0)
			{
				//(TweenMax.getTweensOf(o)[0] as TweenMax).clear();
				(TweenMax.getTweensOf(o)[0] as TweenMax).killVars(o);
			}
		}
		
		public static function localToLocal(
								fromComponent		:UIComponent, 
								toComponent			:UIComponent, 
								origin				:Point):Point
		{
			var point:Point = origin;
			
			fromComponent.localToGlobal(point);
			toComponent.globalToLocal(point);
			
			return point;
		}
		
		/**
		 * recherche récursive vers les parents.
		 */
		public function getPanelParentFromTarget(target:Object):Object
		{
			if (target != null)
			{
				if (target is UmlViewElement)
				{
					return target;
				}
				else if (target.parent is UmlViewElement)
				{
					return target.parent as UmlViewElement;
				}
				else
				{
					return getPanelParentFromTarget(target.parent as UIComponent);
				}
			}
			else 
			{
				return null;
			}
		}
		
		public function showClassForm():UmlViewClassForm
		{
			if (!_isCreateClassVisible)
			{
				var addClassForm:UmlViewClassForm = new UmlViewClassForm();
				
				Application.application.addChild(addClassForm);
				
				addClassForm.x = Application.application.width/2 - addClassForm.width/2;
				addClassForm.y = Application.application.height/2 - addClassForm.height/2;
				
				_isCreateClassVisible = true;
				
				return addClassForm;
			}
			return null;
		}
		
		public function hideClassForm(viewAddClassForm:UmlViewClassForm):void
		{
			if (viewAddClassForm)
			{
				Application.application.removeChild(viewAddClassForm);
				viewAddClassForm			= null;
				_isCreateClassVisible		= false;
			}
		}
		
		public function showInterfaceForm():UmlViewInterfaceForm
		{
			if (!_isCreateInterfaceVisible)
			{
				var addInterfaceForm:UmlViewInterfaceForm = new UmlViewInterfaceForm();
				
				Application.application.addChild(addInterfaceForm);
				
				addInterfaceForm.x = Application.application.width/2 - addInterfaceForm.width/2;
				addInterfaceForm.y = Application.application.height/2 - addInterfaceForm.height/2;
				
				_isCreateInterfaceVisible = true;
				
				return addInterfaceForm;
			}
			return null;
		}
		
		public function hideInterfaceForm(viewInterfaceForm:UmlViewInterfaceForm):void
		{
			if (viewInterfaceForm)
			{
				Application.application.removeChild(viewInterfaceForm);
				viewInterfaceForm				= null;
				_isCreateInterfaceVisible		= false;
			}
		}
		
		public function showAttributeForm():UmlViewAttributeForm
		{
			if (!_isCreateAttributeVisible)
			{
				var addAttributeForm:UmlViewAttributeForm = new UmlViewAttributeForm();
				
				Application.application.addChild(addAttributeForm);
				
				addAttributeForm.x = Application.application.width/2 - addAttributeForm.width/2;
				addAttributeForm.y = Application.application.height/2 - addAttributeForm.height/2;
				
				_isCreateAttributeVisible = true;
				
				return addAttributeForm;
			}
			return null;
		}
		
		public function hideAttributeForm(viewAddAttributeForm:UmlViewAttributeForm):void
		{
			if (viewAddAttributeForm)
			{
				Application.application.removeChild(viewAddAttributeForm);
				viewAddAttributeForm			= null;
				_isCreateAttributeVisible		= false;
			}
		}
		
		public function showFunctionForm():UmlViewFunctionForm
		{
			if (!_isCreateFunctionVisible)
			{
				var addFunctionForm:UmlViewFunctionForm = new UmlViewFunctionForm();
				
				Application.application.addChild(addFunctionForm);
				
				addFunctionForm.x = Application.application.width/2 - addFunctionForm.width/2;
				addFunctionForm.y = Application.application.height/2 - addFunctionForm.height/2;
				
				_isCreateFunctionVisible = true;
				
				return addFunctionForm;
			}
			return null;
		}
		
		public function hideFunctionForm(viewAddFunctionForm:UmlViewFunctionForm):void
		{
			if (viewAddFunctionForm)
			{
				Application.application.removeChild(viewAddFunctionForm);
				viewAddFunctionForm				= null;
				_isCreateFunctionVisible		= false;
			}
		}
		
		public function showAssociationForm():void
		{
			
		}
		
		/**
		 * 
		 * @param p1
		 * @param p2
		 * @return 
		 * 
		 */
		public static function getAngle(point1:Point, point2:Point):Number
		{
			var coteAdjacent	:Number = 0;
			var hypotenus		:Number = 0;
			
			var cosinus			:Number = 0;
			var rotationAngle	:Number = 0;
			var direction		:int	= 1;
			
			coteAdjacent	= point2.x - point1.x;
			hypotenus		= Point.distance(point1, point2);
			
			if (hypotenus != 0)
			{
				cosinus			= coteAdjacent / hypotenus;
				rotationAngle	= Math.acos(cosinus) * 180 / Math.PI;
			}
			
			if (point1.y > point2.y)
			{
				direction = -1;
			}
			
			return rotationAngle * direction;
		}
		
		/**
		 * pitagores
		 */
		public static function getDistance(point1:Point, point2:Point):Number
		{
			var point3	:Point	= new Point(point1.x, point2.y);
			var distW	:Number	= Math.abs(point3.x - point2.x);
			var distH	:Number	= Math.abs(point3.y - point1.y);
			var dist	:Number	= Math.pow(distW, 2) + Math.pow(distH, 2);
			
			return Math.sqrt(dist);
		}
		
		/**
		 * 
		 * @param degree
		 * @return the angle in radians 
		 * 
		 */
		public static function toRadians(degree:Number):Number
		{
			return degree * Math.PI / 180;
		}
		
	}
	
}

class Lock
{
	public function Lock()
	{

	}
}
