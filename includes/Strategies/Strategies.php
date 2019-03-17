<?php

namespace Pickle;

/**
 * Set of strategies
 * This is the base class for a factory for strategy patterns, allowing strategies to be registered
 * and the factory to be tested by providing methods for exporting and importing definitions.
 *
 * @ingroup Extensions
 */
class Strategies implements IStrategies {

	private static $classes = [];

	private function __construct() {
		$this->instances = [];
	}

	/**
	 * Who (am I)
	 *
	 * @return class
	 */
	public static function who() {
		return __CLASS__;
	}

	/**
	 * Get the instance and if necessary initialize the strategy
	 * This does an injection of the class name to make it possible to instantiate a subclass.
	 *
	 * @param any|null $className holding the name of the class (optional)
	 * @return any|null
	 */
	public static function getInstance( $className = null ) {
		if ( $className === null ) {
			$className = static::who();
		}
		if ( ! array_key_exists( $className, self::$classes ) ) {
			self::$classes[$className] = new $className();
		}
		return self::$classes[$className];
	}

	/**
	 * @see \Pickle\IStrategy::export()
	 * @return array
	 */
	public function export() {
		return $this->instances;
	}

	/**
	 * @see \Pickle\IStrategy::import()
	 * @param array|null $arr holding the new strategies (optional)
	 * @return array
	 */
	public function import( array $arr = null ) {
		$this->instances = $arr;
		return $this->instances;
	}

	/**
	 * @see \Pickle\IStrategy::reset()
	 */
	public function reset() {
		$this->instances = [];
	}

	/**
	 * @see \Pickle\IStrategy::register()
	 * @param array $struct for a new singleton
	 * @return any
	 */
	public function register( array $struct ) {
		$instance = new $struct['class']( $struct );
		$this->instances[] = $instance;
		return $instance;
	}

	/**
	 * @see \Pickle\IStrategy::isEmpty()
	 * @return bool
	 */
	public function isEmpty() {
		return ( $this->instances === [] );
	}
}
