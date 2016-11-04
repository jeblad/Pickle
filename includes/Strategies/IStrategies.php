<?php

namespace Spec;

/**
 * Set of strategies
 */
interface IStrategies {

	/**
	 * Export the strategies
	 * The exported structure should be treated as oblique.
	 * Should only be used during test!
	 */
	public function export();

	/**
	 * Import the strategies
	 * The imported structure should be treated as oblique.
	 * Should only be used during test!
	 *
	 * @param array holding the new strategies
	 */
	public function import( array $arr = null );

	/**
	 * Reset the strategies
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
