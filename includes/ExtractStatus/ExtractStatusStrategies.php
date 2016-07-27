<?php

namespace Spec;

/**
 * Strategies to identify final result from specs
 */
class ExtractStatusStrategies extends Strategies {

	/**
	 * Who am I
	 */
	public static function who() {
		return __CLASS__;
	}

	/**
	 * Checks if the string has any of the strategies stored patterns
	 *
	 * @see \Spec\IExtractStatusStrategy::checkState()
	 *
	 * @param string $str
	 *
	 * @return string
	 */
	public function find( $str ) {
		foreach ( $this->strategies as $strategy ) {
			if ( $strategy->checkState( $str ) ) {
				return $strategy;
			}
		}
		return null;
	}
}
