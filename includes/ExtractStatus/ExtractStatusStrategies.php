<?php

namespace Spec;

/**
 * Strategies to identify final result from specs
 */
class ExtractStatusStrategies extends Singletons {

	/**
	 * Who am I
	 */
	public static function who() {
		return __CLASS__;
	}

	/**
	 * Configure the strategies
	 */
	public static function init() {
		global $wgSpecExtractStatus;

		$results = ExtractStatusStrategies::getInstance();
		foreach ( $wgSpecExtractStatus as $struct ) {
			$results->register( $struct );
		}

		return true;
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
		if ( $this->isEmpty() ) {
			ExtractStatusStrategies::init();
		}
		foreach ( $this->instances as $strategy ) {
			if ( $strategy->checkState( $str ) ) {
				return $strategy;
			}
		}
		return null;
	}
}
