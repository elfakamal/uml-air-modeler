package model
{
	

	/**
	 * 
	 * @author kamal
	 * 
	 */
	internal class UmlModelComment extends UmlModelElement
	{
		
		protected var _body						:String			= "";
		protected var _annotatedElements		:Array			= null;
		
		/**
		 * 
		 * @param id
		 * @param name
		 * 
		 */
		public function UmlModelComment(id:String, body:String="")
		{
			super(id);
			_body = body;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public override function get xml():XML
		{
			_xml = <umlComment 
							id			= {uid} 
							body		= {body} />;
			
			if (annotatedElements != null && annotatedElements.length > 0)
			{
				var elementsXml		:XML	= <annotatedElements />;
				var elementsCount	:int	= 0;
				
				for (var i:int = 0; i < annotatedElements.length; i++)
				{
					if (annotatedElements[i] is UmlModelClass)
					{
						var element:IUmlModelElement = IUmlModelElement(annotatedElements[i]);
						elementsXml.appendChild(<annotatedElement id={element.uid} />);
						elementsCount++;
					}
				}
				
				if (elementsCount > 0)
				{
					_xml.appendChild(elementsXml);
				}
			}
			
			return _xml;
		}
		
		public function set body(value:String):void
		{
			_body = value;
		}
		public function get body():String
		{
			return _body;
		}
		
		public function get annotatedElements():Array
		{
			return _annotatedElements;
		}
		public function set annotatedElements(value:Array):void 
		{
			_annotatedElements = value;
		}
		
		public override function addElement(umlElement:IUmlModelElement) : void
		{
			if (umlElement != null)
			{
				annotatedElements.push(umlElement);
			}
		}
		
		public override function removeElement(element:IUmlModelElement) : void
		{
			if (element == null || annotatedElements == null || annotatedElements.length == 0)
			{
				return;
			}
			
			var index:int = annotatedElements.indexOf(element);
			
			if (index >= 0)
			{
				delete annotatedElements.splice(annotatedElements[index], 1);
			}
			
		}
		
	}
	
}
