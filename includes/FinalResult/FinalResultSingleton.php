<?php

namespace Spec;

use \Spec\FinalResultByPatternStrategy;

/**
 * Identification of final result from specs
 */
class FinalResultSingleton {

	private static $instance;

	private function __construct() {
		$this->strategies = [];
	}

	/**
	 * Initialize the singleton
	 */
	public static function init() {
		if ( self::$instance === null ) {
			self::$instance = new self();
		}
		return self::$instance;
	}

	/**
	 * Export the strategies of the singleton
	 * The exported structure should be treated as oblique.
	 * Should only be used during test!
	 *
	 * @param array holding the new strategies
	 */
	public function export( array $arr = null ) {
		return $this->strategies;
	}

	/**
	 * Import the strategies of the singleton
	 * The imported structure should be treated as oblique.
	 * Should only be used during test!
	 *
	 * @param array holding the new strategies
	 */
	public function import( array $arr = null ) {
		$this->strategies = $arr;
		return $this->strategies;
	}

	/**
	 * Reset the singleton
	 * Should only be used during test!
	 */
	public function reset() {
		$this->strategies = [];
	}

	/**
	 * Register a strategy
	 *
	 * @param array describing the result
	 * @return IFinalResultStrategy
	 */
	public function registerStrategy( array $struct ) {
		$strategy = new $struct['class']( $struct );
		$this->strategies[] = $strategy;
		return $strategy;
	}

	/**
	 * Checks if the string has any of the strategies stored patterns
	 *
	 * @see \Spec\IFinalResultStrategy::checkState()
	 *
	 * @param string $str
	 *
	 * @return string
	 */
	public function findState( $str ) {
		foreach ( $this->strategies as $strategy ) {
			if ( $strategy->checkState( $str ) ) {
				return $strategy->getName();
			}
		}
		return null;
	}
}
