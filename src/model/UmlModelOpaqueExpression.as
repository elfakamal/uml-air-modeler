package model 
{
	import model.UmlModelValueSpecification;
	import model.UmlModelVisibilityKind;
	
	/**
	 * 
	 * An opaque expression is an uninterpreted textual statement that denotes 
	 * a (possibly empty) set of values when evaluated in a context.
	 * 
	 * An expression contains language-specific text strings used to describe 
	 * a value or values, and an optional specification of the languages.
	 * 
	 * One predefined language for specifying expressions is OCL. Natural 
	 * language or programming languages may also be used.
	 * 
	 * @author EL FARSAOUI Kamal
	 * 
	 */
	internal class UmlModelOpaqueExpression extends UmlModelValueSpecification
	{
		
		/**
		 * The text of the expression, possibly in multiple languages.
		 */
		protected var _bodies				:Array			= "";
		
		/**
		 * Specifies the languages in which the expression is stated. 
		 * The interpretation of the expression body depends on the languages. 
		 * If the languages are unspecified, they might be implicit from 
		 * the expression body or the context. Languages are matched to body 
		 * strings by order
		 */
		protected var _languages			:Array			= "";
		
		
		public function UmlModelOpaqueExpression(
										p_uid			:String, 
										p_name			:String, 
										p_visibility	:UmlModelVisibilityKind = null) 
		{
			super(p_uid, p_name, p_visibility);
		}
		
		public function get bodies():Array
		{
			return _bodies;
		}
		public function set bodies(value:Array):void 
		{
			_bodies = value;
		}
		
		public function get languages():Array
		{
			return _languages;
		}
		public function set languages(value:Array):void 
		{
			_languages = value;
		}
		
		// see Uml specs
		public function value():int
		{
			if (isIntegral())
			{
				return 1;
			}
			return 0;
		}
		
		// see Uml specs
		public function isIntegral():Boolean
		{
			return false;
		}
		
		// see Uml specs
		public function isPositive():Boolean
		{
			return false;
		}
		
		// see Uml specs
		public function isNonNegative():Boolean
		{
			return false;
		}
		
	}

}