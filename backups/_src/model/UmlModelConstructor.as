package model
{
	
	internal class UmlModelConstructor extends UmlModelOperation
	{
		
		public function UmlModelConstructor(id:String, name:String, parameterList:Array = null)
		{
			super(id, name, "public", "", true, parameterList);
		}
		
		public override function get xml():XML
		{
			_xml =	<umlConstructor 
						id				={uid} 
						name			={name} />;
						/* visibility		={getVisibility()} 
						returnType		={getType()} 
						isMember		={isMember()}  */
					
			
			// ajout de l'xml des paramètres 
			if (ownedElements && ownedElements.length > 0)
			{
				var parametersXml:XML = <umlParameters />;
				for (var i:int = 0; i < ownedElements.length; i++)
				{
					var parametre:UmlModelParameter = UmlModelParameter(ownedElements[i]);
					parametersXml.appendChild(parametre.xml);
				}
				_xml.appendChild(parametersXml);
			}
			
			return _xml;
		}
	}
}