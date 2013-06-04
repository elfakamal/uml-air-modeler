package model
{
	
	/**
	 * A data type is a type whose instances are identified only by their value. 
	 * A DataType may contain attributes to support the modeling of structured 
	 * data types. 
	 * 
	 * A typical use of data types would be to represent programming language 
	 * primitive types or CORBA basic types. For example, integer and string 
	 * types are often treated as data types
	 * 
	 * @author kamal
	 * 
	 */
	internal class UmlModelDataType extends UmlModelClassifier
	{
		
		/**
		 * The Attributes owned by the DataType. This is an ordered collection. 
		 * Subsets Classifier::attribute and Element::ownedElement
		 */
		protected var _ownedAttributes			:Array			= null;
		
		/**
		 * The Operations owned by the DataType. This is an ordered collection. 
		 * Subsets Classifier::feature and Element::ownedElement
		 */
		protected var _ownedOperations			:Array			= null;
		
		/**
		 * 
		 * @param	p_uid
		 * @param	p_name
		 * @param	p_visibility
		 */
		public function UmlModelDataType(
								p_uid			:String, 
								p_name			:String, 
								p_visibility	:UmlModelVisibilityKind=null)
		{
			super(p_uid, p_name, p_visibility);
		}
		
		/**
		 * 
		 */
		public override function get xml():XML
		{
			_xml = <umlDataType 
						id = { uid } 
						name = { name } 
						visibility = { visibility.toString() } /> ;
			
			return _xml;
		}
		
		public function get ownedAttributes():Array
		{
			return _ownedAttributes;
		}
		public function set ownedAttributes(value:Array):void 
		{
			_ownedAttributes = value;
		}
		
		public function get ownedOperations():Array
		{
			return _ownedOperations;
		}
		public function set ownedOperations(value:Array):void 
		{
			_ownedOperations = value;
		}
		
		// from classifier
		override public function get attributes():Array
		{
			var elements:Array = [];
			
			if (super.attributes != null)
			{
				elements = elements.concat(super.attributes);
			}
			
			if (ownedAttributes != null)
			{
				return elements.concat(ownedAttributes);
			}
			
			return elements;
		}
		
		// from classifier
		override public function get features():Array
		{
			var elements:Array = [];
			
			if (super.features != null)
			{
				elements = elements.concat(super.features);
			}
			
			if (ownedOperations != null)
			{
				return elements.concat(ownedOperations);
			}
			
			return elements;
		}
		
		// from Element
		override public function get ownedElements():Array
		{
			var elements:Array = [];
			
			if (super.ownedElements)
			{
				elements = elements.concat(super.ownedElements);
			}
			
			if (ownedAttributes != null)
			{
				elements = elements.concat(ownedAttributes);
			}
			
			if (ownedOperations != null)
			{
				elements = elements.concat(ownedOperations);
			}
			
			return elements;
		}
		
	}
	
}
