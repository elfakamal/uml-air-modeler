package view.core
{
	import controler.events.UmlEvent;
	import controler.events.UmlViewEvent;
	
	import com.greensock.TweenMax;
	
	import mx.containers.Canvas;
	import mx.core.Application;
	import mx.core.UIComponent;
	
	import view.newView.UmlViewWindow;
	
	
	/**
	 * 
	 * @author kamal
	 * 
	 */
	public class UmlAlert
	{
		
		/**
		 * 
		 */
		protected var _modal				:Canvas				= null;
		protected var _window				:UmlViewWindow		= null;
		protected var _form					:UIComponent		= null;
		protected var _isModalAllowed		:Boolean			= true;
		
		/**
		 * 
		 * 
		 */
		public function UmlAlert(form:UIComponent, useModal:Boolean=true)
		{
			super();
			
			_form				= form;
			_isModalAllowed		= useModal;
		}
		
		/**
		 * 
		 * 
		 */
		protected function createModal():Canvas
		{
			var modal:Canvas = new Canvas();
			modal.setStyle("backgroundColor", "#000000");
			
			Application.application.getSelectedProjectWorkspace().addChild(modal);
			
			modal.x			= 0;
			modal.y			= 0;
			modal.width		= Application.application.getSelectedProjectWorkspace().width; 
			modal.height	= Application.application.getSelectedProjectWorkspace().height;
			modal.alpha		= 0.0;
			
			return modal;
		}
		
		/**
		 * 
		 * @param form
		 * 
		 */
		protected function createWindow(form:UIComponent):UmlViewWindow
		{
			var window:UmlViewWindow = new UmlViewWindow();
			window.setType(UmlViewWindow.INDEPENDENT_WINDOW);
			Application.application.getSelectedProjectWorkspace().addChild(window);
			
			if (form != null)
			{
				window.setContent(form);
			}
			
			window.alpha = 0.0;
			return window;
		}
		
		/**
		 * 
		 * @param form
		 * @return 
		 * 
		 */
		public function show():UmlViewWindow
		{
			if (_isModalAllowed)
			{
				_modal = createModal();
			}
			
			_window = createWindow(_form);
			_window.addEventListener(UmlViewEvent.WINDOW_CLOSED, onWindowClosed);
			tweenAlpha(_modal, 0.0, 0.3, 0.5, tweenWindowAlpha);
			
			return _window;
		}
		
		/**
		 * 
		 * @param startAlpha
		 * @param endAlpha
		 * 
		 */
		protected function tweenAlpha(
								firstComponent		:UIComponent, 
								startAlpha			:Number, 
								endAlpha			:Number, 
								tweenTime			:Number, 
								completeCallback	:Function = null):void
		{
			TweenMax.to
			(
				firstComponent, 
				tweenTime, 
				{
					alpha				: endAlpha, 
					onComplete			: function ():void
					{
						if (completeCallback != null)
						{
							completeCallback();
						}
					}
				}
			);
		}
		
		protected function tweenWindowAlpha():void
		{
			tweenAlpha(_window, 0.0, 1.0, 0.2);
		}
		
		/**
		 * 
		 * @param e
		 * 
		 */
		protected function onWindowClosed(e:UmlViewEvent):void
		{
			tweenAlpha(_modal, _modal.alpha, 0.0, 0.5, removeModal);
		}
		
		private function removeModal():void
		{
			if (_modal.parent != null)
			{
				_modal.parent.removeChild(_modal);
			}
		}
		
	}
	
}
