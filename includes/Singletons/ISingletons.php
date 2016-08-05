<?php

namespace Spec;

/**
 * Set of singletons
 */
interface ISingletons {

	/**
	 * Export the singletons
	 * The exported structure should be treated as oblique.
	 * Should only be used during test!
	 */
	public function export();

	/**
	 * Import the singletons
	 * The imported structure should be treated as oblique.
	 * Should only be used during test!
	 *
	 * @param array holding the new singletons
	 */
	public function import( array $arr = null );

	/**
	 * Reset the singletons
	 * Should only be used during test!
	 */
	public function reset();

	/**
	 * Register a class
	 *
	 * @param array describing the result
	 * @return Object
	 */
	public function register( array $struct );

	/**
	 * Check if a class has no instances
	 *
	 * @return boolean
	 */
	public function isEmpty();
}
