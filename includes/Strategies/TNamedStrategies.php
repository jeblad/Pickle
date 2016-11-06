<?php

namespace Spec;

/**
 *
 * @ingroup Extensions
 * @group Spec
 */
trait TNamedStrategies {

	/**
	 * Creates and register a new strategy
	 *
	 * @param array structure to define the new instance
	 *
	 * @return Any instance created
	 */
	public function register( array $struct ) {
		$instance = new $struct['class']( $struct );
		if ( $instance === null or $instance->getName() === null ) {
			return null;
		}
		$this->instances[$instance->getName()] = $instance;
		return $instance;
	}

	/**
	 * Checks if there is any strategy with this name
	 *
	 * @param string name of the instance
	 *
	 * @return Any|null depending on the type of found instance
	 */
	public function find( $name ) {
		if ( $this->isEmpty() ) {
			self::init();
		}
		if ( array_key_exists( $name, $this->instances ) ) {
			return $this->instances[$name];
		} else {
			return $this->instances['unknown'];
		}
	}

}
