<?php

namespace Spec;

use \Spec\FinalResultByPatternStrategy;

/**
 * Singleton for access to identification of final test states from specs
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
	 * Access the strategies of the singleton
	 * Should only be used during test!
	 *
	 * @param array holding the new strategies
	 */
	public function strategies( array $arr = null ) {
		if ( $arr !== null ) {
			$this->strategies = $arr;
		}
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
	 * @see \Spec\IFinalResultStrategy::findState()
	 *
	 * @param string $str
	 *
	 * @return string
	 */
	public function findState( $str ) {
		foreach ( $this->strategies as $strategy ) {
			if ( $strategy->findState( $str ) ) {
				return $strategy->getName();
			}
		}
		return null;
	}
}
