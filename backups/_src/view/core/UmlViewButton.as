package view.core
{
	import mx.containers.Canvas;
	import mx.controls.Label;

	public class UmlViewButton extends Canvas
	{
		
		private var _umlLabel			:String;
		
		public function UmlViewButton(umlLabel:String)
		{
			super();
			
			_umlLabel = umlLabel;
			
			initListeners();
			initObjects();
		}
		
		private function initListeners():void
		{
			
		}
		
		private function initObjects():void
		{
			// le label qu'il faut ajouter
			var ButtonText:Label		= new Label();
			ButtonText.text				= _umlLabel;
			
		}
		
	}
}