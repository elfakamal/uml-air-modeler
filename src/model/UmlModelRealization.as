package model
{
	
	/**
	 * Realization is a specialized abstraction relationship between 
	 * two sets of model elements, one representing a specification 
	 * (the supplier) and the other represents an implementation 
	 * of the latter (the client). Realization can be used to model 
	 * stepwise refinement, optimizations, transformations, templates, 
	 * model synthesis, framework composition, etc.
	 *  
	 * @author kamal
	 * 
	 */
	internal class UmlModelRealization extends UmlModelAbstraction
	{
		
		
		
		/**
		 * 
		 * A Realization signifies that the client set of elements 
		 * are an implementation of the supplier set, which serves as the 
		 * specification. The meaning of ‘implementation’ is not strictly 
		 * defined, but rather implies a more refined or elaborate form 
		 * in respect to a certain modeling context. It is possible 
		 * to specify a mapping between the specification and implementation 
		 * elements, although it is not necessarily computable.
		 * 
		 */
		public function UmlModelRealization(p_uid:String)
		{
			super(p_uid);
		}
		
	}
	
}
