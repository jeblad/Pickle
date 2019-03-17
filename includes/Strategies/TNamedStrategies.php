<?php

namespace Pickle;

/**
 *
 * @ingroup Extensions
 */
trait TNamedStrategies {

	/**
	 * Creates and register a new strategy
	 *
	 * @param array $struct to define the new instance
	 * @return any instance created
	 */
	public function register( array $struct ) {
		$instance = new $struct['class']( $struct );
		if ( $instance === null || $instance->getName() === null ) {
			return null;
		}
		$this->instances[$instance->getName()] = $instance;
		return $instance;
	}

	/**
	 * Checks if there is any strategy with this name
	 *
	 * @param any $name of the instance
	 * @return any|null depending on the type of found instance
	 */
	public function find( $name ) {
		if ( $this->isEmpty() ) {
			self::init();
		}
		if ( array_key_exists( $name, $this->instances ) ) {
			return $this->instances[$name];
		}
		return $this->instances['unknown'];
	}

}
