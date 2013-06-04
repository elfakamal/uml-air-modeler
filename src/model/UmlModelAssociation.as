package model
{
	
	import controler.events.UmlAssociationEvent;
	import controler.events.UmlEvent;
	import controler.namespaces.creator;
	
	import flash.errors.IllegalOperationError;
	
	/**
	 * 
	 * @author kamal
	 * 
	 */
	internal class	UmlModelAssociation
		extends		UmlModelRelationship
		implements	IUmlModelAssociation
	{
		
		protected var _isDerived			:Boolean		= false;
		
		protected var _membersEnds			:Array			= null;
		protected var _ownedEnds			:Array			= null;
		protected var _navigabeOwnedEnds	:Array			= null;
		protected var _endTypes				:Array			= null;
		
		
		/**
		 * @param id
		 * @param name
		 * @param nodes
		 */
		public function UmlModelAssociation(id:String, p_name:String, elements:Array)
		{
			super(id);
			
			name = p_name;
			
			use namespace creator;
			
			_membersEnds			= new Array();
			_ownedEnds				= new Array();
			_navigabeOwnedEnds		= new Array();
			
			if (elements != null)
			{
				_endTypes = elements;
			}
			else
			{
				_endTypes = new Array();
			}
			
//			var element:IUmlModelElement = null;
//			for (var i:uint = 0; i < elements.length; i++)
//			{
//				element = elements[i] as IUmlModelElement;
//				if (element is IUmlModelType)
//				{
//					var property:IUmlModelElement = null;
//					property = UmlModelFieldFactory.createAttribute
//					(
//						"unnamed", 
//						UmlModelVisibilityKind.$public, 
//						element as IUmlModelType
//					);
//					
//					_ownedEnds.push(property);
//				}
//			}
		}
		
		/**
		 * 
		 * @param umlNode
		 * 
		 */
		public override function addElement(element:IUmlModelElement):void
		{
			if (element == null)
			{
				return;
			}
			
			use namespace creator;
			
			var event:UmlAssociationEvent = null;
			event = new UmlAssociationEvent(UmlAssociationEvent.ASSOCIATION_END_ADDED);
			
			if (element is UmlModelProperty)
			{
				if (endTypes.indexOf((element as UmlModelProperty).type) < 0)
				{
					throw new IllegalOperationError("the lower value is upper " + 
													"than the upper value");
					return;
				}
				
				var propertyElement:UmlModelProperty = element as UmlModelProperty;
				
				if (propertyElement.isNavigable())
				{
					_navigabeOwnedEnds.push(propertyElement);
				}
				else
				{
					_ownedEnds.push(propertyElement);
				}
				
				propertyElement.owner = this;
				event.setAddedElement(element);
			}
			else if (element is IUmlModelType)
			{
				
				if (endTypes.indexOf(element) < 0)
				{
					throw new IllegalOperationError("the lower value is upper " + 
													"than the upper value");
					return;
				}
				
				var property:IUmlModelElement = null;
				property = UmlModelFactoryField.createAssociationEnd
				(
					"unnamed",
					UmlModelVisibilityKind.$public, 
					element as IUmlModelType
				);
				
				_ownedEnds.push(property);
				event.setAddedElement(property);
			}
			
			if (event.getAddedElement() != null && 
				event.getAddedElement() is IUmlModelMultiplicityElement)
			{
				dispatchEvent(event);
			}
		}
		
		public override function edit(newElement:IUmlModelElement) : void
		{
			var newAssociation:UmlModelAssociation = null;
			
			if (newElement == null)
			{
				trace("the new association is NULL");
				return;
			}
			
			if (newElement is UmlModelAssociation)
			{
				newAssociation = newElement as UmlModelAssociation;
				
				this.name			= newAssociation.name;
				this._membersEnds	= newAssociation.memberEnds;
				this._isDerived		= newAssociation.isDerived;
				
				var event:UmlEvent = new UmlEvent(UmlEvent.ELEMENT_EDITED);
				event.setEditedNode(this);
				dispatchEvent(event);
			}
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */
		public override function get xml():XML
		{
			_xml = <umlAssociation id={uid} name={name} />;
			
			if (ownedElements && ownedElements.length > 0)
			{
				var nodesXml:XML = <nodes />;
				
				for (var i:uint = 0; i < ownedElements.length; i++)
				{
					var umlNode:XML = <umlNode id={(ownedElements[i] as IUmlModelElement).xml.@id} />;
					nodesXml.appendChild(umlNode);
				}
				
				_xml.appendChild(nodesXml);
			}
			
			return _xml;
		}
		
		
		
		/* INTERFACE model.IUmlModelAssociation */
		
		public function get isDerived():Boolean
		{
			return _isDerived;
		}
		
		public function get memberEnds():Array
		{
			var elements:Array = [];
			
			if (_membersEnds != null)
			{
				elements = elements.concat(_membersEnds);
			}
			
			if (ownedEnds != null)
			{
				elements = elements.concat(ownedEnds);
			}
			
			return elements;
		}
		
		public function get ownedEnds():Array
		{
			var elements:Array = [];
			
			if (_ownedEnds != null)
			{
				elements = elements.concat(_ownedEnds);
			}
			
			if (navigableOwnedEnds != null)
			{
				elements = elements.concat(navigableOwnedEnds);
			}
			
			return elements;
		}
		
		public override function get ownedElements():Array
		{
			return ownedEnds;
		}
		
		public function get navigableOwnedEnds():Array
		{
			return _navigabeOwnedEnds;
		}
		
		public function get endTypes():Array
		{
			return _endTypes;
		}
		
		/* INTERFACE model.IUmlModelClassifier */
		
		public function set isAbstract(value:Boolean):void
		{
			//rien 
		}
		
		public function get isAbstract():Boolean
		{
			return false;
		}
		
		public function get attributes():Array
		{
			return null;
		}
		
		public function get features():Array
		{
			return ownedEnds;
		}
		
		public function get generals():Array
		{
			return null;
		}
		
		public function get generalizations():Array
		{
			return null;
		}
		
		public function get inheritedMembers():Array
		{
			return null;
		}
		
		public function get redefinedClassifiers():Array
		{
			return null;
		}
		
		public function get substitutions():Array
		{
			return null;
		}
		
		public function get powerTypeExtent():UmlModelGeneralizationSet
		{
			return null;
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
		
		
		/* INTERFACE model.IUmlModelNamespace */
		
		public function get elementImports():Array
		{
			return null;
		}
		
		public function get importedMembers():Array
		{
			return null;
		}
		
		public function get members():Array
		{
			return memberEnds;
		}
		
		public function get ownedMembers():Array
		{
			return ownedEnds;
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
		
		
		/* INTERFACE model.IUmlModelNamedElement */
		
		public function set visibility(value:UmlModelVisibilityKind):void
		{
			
		}
		
		public function get visibility():UmlModelVisibilityKind
		{
			return null;
		}
		
		public function set $namespace(ns:IUmlModelNamespace):void
		{
			//rien 
		}
		
		public function get $namespace():IUmlModelNamespace
		{
			return null;
		}
		
		public function get qualifiedName():String
		{
			return name;
		}
		
		public function get clientDependencies():Array
		{
			return null;
		}
		
		public function get separator():String
		{
			return "::";
		}
		
		public function getAllNamespaces():Array // or LinkedList ;-)
		{
			return null;
		}
		
		public function isDistinguishableFrom(
									element		:IUmlModelNamedElement, 
									ns			:IUmlModelNamespace):Boolean
		{
			return false;
		}
		
		/* INTERFACE model.IUmlModelRedefinableElement */
		
		public function get isLeaf():Boolean
		{
			return false;
		}
		
		public function get redefinedElements():Array
		{
			return null;
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
