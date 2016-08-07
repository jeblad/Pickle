<?php

namespace Spec;

/**
 * Strategies to squash tap reports
 *
 * @ingroup Extensions
 */
class TestAnythingProtocolStrategies extends Singletons {

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
		global $wgSpecTestAnythingProtocol;

		$results = TestAnythingProtocolStrategies::getInstance();
		foreach ( $wgSpecTestAnythingProtocol as $struct ) {
			$results->register( $struct );
		}

		return true;
	}

	/**
	 * Checks if the string has any of the strategies stored patterns
	 *
	 * @param String $str
	 *
	 * @return string
	 */
	public function find( $str ) {
		if ( $this->isEmpty() ) {
			TestAnythingProtocolStrategies::init();
		}
		foreach ( $this->instances as $strategy ) {
			if ( $strategy->checkValid( $str ) ) {
				return $strategy;
			}
		}
		return null;
	}
}
