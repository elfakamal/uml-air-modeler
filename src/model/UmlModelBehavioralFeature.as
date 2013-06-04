package model
{
	
	/**
	 * 
	 * @author kamal
	 * 
	 */
	internal class	UmlModelBehavioralFeature 
		extends		UmlModelFeature 
		implements	IUmlModelNamespace
	{
		
		/**
		 * Specifies the ordered set of formal parameters owned by this 
		 * BehavioralFeature. The parameter direction can be "in", "inout", 
		 * "out", or "return" to specify input, output, or return parameters. 
		 * Subsets Namespace::ownedMember
		 */
		protected var _ownedParameters			:Array			= null;
		
		/**
		 * References the Types representing exceptions that may be raised 
		 * during an invocation of this operation.
		 */
		protected var _raisedExceptions			:Array			= null;
		
		/**
		 * 
		 * @param id
		 * @param name
		 * 
		 */
		public function UmlModelBehavioralFeature(
								p_uid				:String, 
								p_name				:String, 
								p_visibility		:UmlModelVisibilityKind = null)
		{
			super(p_uid, p_name, p_visibility);
		}
		
		/**
		 * 
		 * subsets ownedMembers
		 */
		public function get ownedParameters():Array
		{
			return _ownedParameters;
		}
		public function set ownedParameters(value:Array):void 
		{
			_ownedParameters = value;
		}
		
		/**
		 * 
		 * @return a set of UmlModelType
		 */
		public function set raisedExceptions(value:Array):void
		{
			_raisedExceptions = value;
		}
		public function get raisedExceptions():Array
		{
			return _raisedExceptions;
		}
		
		/**
		 * Determines whether two BehavioralFeatures may coexist in the same 
		 * Namespace. It specifies that they have to have different signatures
		 * 
		 * @param	element
		 * @param	ns
		 * @return
		 */
		public override function isDistinguishableFrom(
											element		:IUmlModelNamedElement, 
											ns			:IUmlModelNamespace):Boolean
		{
			return false;
		}
		
		public override function get xml():XML
		{
			return null;
		}
		
		//subsetting
		//from Element
		override public function get ownedElements():Array
		{
			var elements:Array = new Array();
			
			if (ownedMembers != null)
			{
				elements = elements.concat(ownedMembers);
			}
			
			if (elementImports != null)
			{
				elements = elements.concat(elementImports);
			}
			
			if (packageImports != null)
			{
				elements = elements.concat(packageImports);
			}
			
			return super.ownedElements.concat(elements);
		}
		
		/***********************************************************************
		 * 
		 * IUmlModelNamespace functions
		 * 
		 */
		public function get elementImports():Array
		{
			return null;
		}
		
		public function get importedMembers():Array
		{
			return null;
		}
		
		// subsetting
		public function get members():Array
		{
			var elements:Array = new Array();
			
			if (importedMembers != null)
			{
				elements = elements.concat(elements);
			}
			
			if (ownedMembers != null)
			{
				elements = elements.concat(ownedMembers);
			}
			
			return elements;
		}
		
		//subsetting 
		public function get ownedMembers():Array
		{
			var elements:Array = [];
			
			if (ownedParameters != null)
			{
				return elements.concat(ownedParameters);
			}
			
			return null;
		}
		
		public function get ownedRules():Array
		{
			return null;
		}
		
		public function get packageImports():Array
		{
			return null;
		}
		
		public function getNamesOfMember(element:IUmlModelNamedElement):Array
		{
			return null;
		}
		
		public function membersAreDistinguishable():Boolean
		{
			return false;
		}
		
		public function importMembers(elements:Array):Array
		{
			return null;
		}
		
		public function excludeCollisions(elements:Array):Array
		{
			return null;
		}
		
	}
	
}
