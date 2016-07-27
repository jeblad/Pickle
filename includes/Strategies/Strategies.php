<?php

namespace Spec;

/**
 * Singleton with strategies
 */
class Strategies implements IStrategies {

	private static $instances = [];

	private function __construct() {
		$this->strategies = [];
	}

	/**
	 * Who am I
	 */
	public static function who() {
		return __CLASS__;
	}

	/**
	 * Initialize the singleton
	 * This does an injection of the class name to make it possible to instantiate a subclass.
	 */
	public static function init( $class = null ) {
		if ( $class === null ) {
			$class = static::who();
		}
		if ( ! array_key_exists( $class, self::$instances ) ) {
			self::$instances[$class] = new $class();
		}
		return self::$instances[$class];
	}

	/**
	 * @see \Spec\IStrategy::export()
	 */
	public function export() {
		return $this->strategies;
	}

	/**
	 * @see \Spec\IStrategy::import()
	 */
	public function import( array $arr = null ) {
		$this->strategies = $arr;
		return $this->strategies;
	}

	/**
	 * @see \Spec\IStrategy::reset()
	 */
	public function reset() {
		$this->strategies = [];
	}

	/**
	 * @see \Spec\IStrategy::registerStrategy()
	 */
	public function registerStrategy( array $struct ) {
		$strategy = new $struct['class']( $struct );
		$this->strategies[] = $strategy;
		return $strategy;
	}
}
