package model
{
	
	
	/**
	 * 
	 * @author kamal
	 * 
	 */
	internal class	UmlModelClassifier 
		extends		UmlModelNamespace 
		implements	IUmlModelClassifier, 
					IUmlModelType
	{
		
		protected var _isAbstract				:Boolean		= false;
		protected var _isLeaf					:Boolean		= false;
		
		protected var _generalizations			:Array			= null;
		protected var _redefinedClassifier		:Array			= null;
		protected var _substitutions			:Array			= null;
		
		protected var _redefinedElements		:Array			= null;
		protected var _redefinitionContexts		:Array			= null;
		
		/**
		 * 
		 * @param id
		 * @param name
		 * 
		 */
		public function UmlModelClassifier(
							p_uid				:String, 
							p_name				:String, 
							p_visibility		:UmlModelVisibilityKind = null)
		{
			super(p_uid, p_name, p_visibility);
		}
		
		public override function get xml():XML
		{
			return null;
		}
		
		/* INTERFACE model.IUmlModelPackageableElement */
		
		public function get packageableElementVisibility():UmlModelVisibilityKind
		{
			return visibility;
		}
		
		/* INTERFACE model.IUmlModelType */
		
		public function conformsTo(type:UmlModelType):Boolean
		{
			return false;
		}
		
		public function toString():String
		{
			return name;
		}
		
		/***********************************************************************
		 * 
		 * IUmlModelClassifier functions
		 * 
		 */
		public function set isAbstract(value:Boolean):void
		{
			_isAbstract = value;
		}
		public function get isAbstract():Boolean
		{
			return _isAbstract;
		}
		
		public function get attributes():Array
		{
			return null;
		}
		
		public function get features():Array
		{
			var elements:Array = [];
			
			if (attributes != null)
			{
				elements = elements.concat(attributes);
			}
			
			return elements;
		}
		
		override public function get members():Array
		{
			var elements:Array = [];
			
			if (super.members)
			{
				elements = elements.concat(super.members);
			}
			
			if (features != null)
			{
				elements = elements.concat(features);
			}
			
			if (inheritedMembers != null)
			{
				elements = elements.concat(inheritedMembers);
			}
			
			return elements;
		}
		
		public function get generals():Array
		{
			return null;
		}
		
		override public function get ownedElements():Array
		{
			var elements:Array = [];
			
			if (super.ownedElements != null)
			{
				elements = elements.concat(super.ownedElements);
			}
			
			if (generalizations != null)
			{
				elements = elements.concat(generalizations);
			}
			
			if (substitutions != null)
			{
				elements = elements.concat(substitutions);
			}
			
			return elements;
		}
		
		public function get generalizations():Array
		{
			return _generalizations;
		}
		
		public function get inheritedMembers():Array
		{
			return null;
		}
		
		public function get redefinedClassifiers():Array
		{
			return _redefinedClassifier;
		}
		
		public function get powerTypeExtent():UmlModelGeneralizationSet
		{
			return null;
		}
		
		override public function get clientDependencies():Array
		{
			var elements:Array = [];
			
			if (super.clientDependencies)
			{
				elements = elements.concat(super.clientDependencies);
			}
			
			if (substitutions != null)
			{
				elements = elements.concat(substitutions);
			}
			
			return elements;
		}
		
		public function get substitutions():Array
		{
			return _substitutions;
		}
		
		public function getAllFeatures():Array
		{
			return null;
		}
		
		public function getParents():Array
		{
			return null;
		}
		
		public function getAllParents():Array
		{
			return null;
		}
		
		public function getInheritableMembersOf(classifier:IUmlModelClassifier):Array
		{
			return null;
		}
		
		public function hasVisibilityOf(element:IUmlModelNamedElement):Boolean
		{
			return false;
		}
		
		public function inherit(elements:Array):Array
		{
			return null;
		}
		
		public function maySpecializeType(classifier:IUmlModelClassifier):Boolean
		{
			return false;
		}
		
		/***********************************************************************
		 * 
		 * IUmlModelRedefinableElement members
		 * 
		 */
		public function set isLeaf(value:Boolean):void
		{
			_isLeaf = value;
		}
		public function get isLeaf():Boolean
		{
			return _isLeaf;
		}
		
		public function get redefinedElements():Array
		{
			return redefinedClassifiers;
		}
		
		public function get redefinitionContexts():Array
		{
			return null;
		}
		
		public function isConsistentWith(redefinee:IUmlModelRedefinableElement):Boolean
		{
			return false;
		}
		
		public function isRedefinitionContextValid(redefined:IUmlModelRedefinableElement):Boolean
		{
			return false;
		}
		
	}
	
}
