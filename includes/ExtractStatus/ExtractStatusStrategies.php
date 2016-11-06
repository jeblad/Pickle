<?php

namespace Spec;

/**
 * Strategies to find an extract status strategy
 * This is a factory for the extracted statuses implemented as a common set of strategies. The
 * entries will be found according to the current result.
 *
 * @ingroup Extensions
 */
class ExtractStatusStrategies extends Strategies {

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
