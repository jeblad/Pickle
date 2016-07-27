<?php

namespace Spec;

/**
 * Singleton with strategies
 */
interface IStrategies {

	/**
	 * Export the strategies of the singleton
	 * The exported structure should be treated as oblique.
	 * Should only be used during test!
	 *
	 * @param array holding the new strategies
	 */
	public function export();

	/**
	 * Import the strategies of the singleton
	 * The imported structure should be treated as oblique.
	 * Should only be used during test!
	 *
	 * @param array holding the new strategies
	 */
	public function import( array $arr = null );

	/**
	 * Reset the singleton
	 * Should only be used during test!
	 */
	public function reset();

	/**
	 * Register a strategy
	 *
	 * @param array describing the result
	 * @return ISubpageStrategy
	 */
	public function registerStrategy( array $struct );
}
