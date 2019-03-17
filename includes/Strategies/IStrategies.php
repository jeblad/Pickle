<?php

namespace Pickle;

/**
 * Set of strategies
 * This is the interface for a factory for strategy patterns, allowing strategies to be registered
 * and the factory to be tested by providing methods for exporting and importing definitions.
 *
 * @ingroup Extensions
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
	 * @param array|null $arr holding the new strategies (optional)
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
	 * @param array $struct describing the result
	 * @return Object
	 */
	public function register( array $struct );

	/**
	 * Check if a class has no instances
	 *
	 * @return bool
	 */
	public function isEmpty();
}
