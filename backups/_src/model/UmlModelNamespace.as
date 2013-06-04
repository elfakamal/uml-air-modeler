package model
{
	import model.IUmlModelElement;
	import model.IUmlModelNamedElement;
	/**
	 * 
	 * @author kamal
	 * 
	 */
	internal class	UmlModelNamespace 
		extends		UmlModelNamedElement 
		implements	IUmlModelNamespace 
	{
		
		protected var _elementImports		:Array		= null;
		protected var _ownedRules			:Array		= null;
		protected var _packageImports		:Array		= null;
		
		/**
		 * 
		 * @param id
		 * @param name
		 * @param visibility
		 * 
		 */
		public function UmlModelNamespace(
								p_uid				:String, 
								p_name				:String, 
								p_visibility		:UmlModelVisibilityKind = null)
		{
			super(p_uid, p_name, p_visibility);
		}
		
		override public function get ownedElements():Array
		{
			var elements:Array = [];
			
			if (super.ownedElements != null)
			{
				elements = elements.concat(super.ownedElements);
			}
			
			if (elementImports != null)
			{
				elements = elements.concat(elementImports);
			}
			
			if (ownedMembers != null)
			{
				elements = elements.concat(ownedMembers);
			}
			
			if (packageImports != null)
			{
				elements = elements.concat(packageImports);
			}
			
			return elements;
		}
		
		
		/* INTERFACE model.IUmlModelNamespace */
		
		public function get elementImports():Array
		{
			return _elementImports;
		}
		public function set elementImports(value:Array):void 
		{
			_elementImports = value;
		}
		
		public function get ownedRules():Array
		{
			return _ownedRules;
		}
		public function set ownedRules(value:Array):void 
		{
			_ownedRules = value;
		}
		
		public function get packageImports():Array
		{
			return _packageImports;
		}
		public function set packageImports(value:Array):void 
		{
			_packageImports = value;
		}
		
		public function get importedMembers():Array
		{
			return null;
		}
		
		/**
		 * this function lists the concretly owned members, 
		 * which are contained in the namespace.
		 * 
		 * @return 
		 * 
		 */
		public function get ownedMembers():Array
		{
			return ownedRules;
		}
		
		/**
		 * A collection of NamedElements identifiable within the Namespace, 
		 * either by being owned or by being introduced by importing 
		 * or inheritance. 
		 * This is a derived union.
		 * 
		 * @return 
		 * 
		 */
		public function get members():Array
		{
			var elements:Array = [];
			
			if (ownedMembers != null)
			{
				elements = elements.concat(ownedMembers);
			}
			
			if (importedMembers != null)
			{
				elements = elements.concat(importedMembers);
			}
			
			return elements;
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
