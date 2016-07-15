<?php

namespace Spec;

use \Spec\IdentifyResultByPatternStrategy;

/**
 * Singleton for access to identification of final test states from specs
 */
class IdentifyResultSingleton {

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
	 * @return IIdentifyResultStrategy
	 */
	public function registerStrategy( array $struct ) {
		$strategy = new $struct['class']( $struct );
		$this->strategies[] = $strategy;
		return $strategy;
	}

	public function peek() {
		$t = [];
		foreach ( $this->strategies as $strategy ) {
			$t[] = $strategy->getName();
		}
		return $t;
	}

	/**
	 * Checks if the string has any of the strategies stored patterns
	 *
	 * @see \Spec\IIdentifyStateStrategy::findState()
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
