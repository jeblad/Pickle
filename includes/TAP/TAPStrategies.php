<?php

namespace Spec;

/**
 * Strategies to squash tap reports
 *
 * @ingroup Extensions
 */
class TAPStrategies extends Strategies {

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
		global $wgSpecTAP;

		$results = TAPStrategies::getInstance();
		foreach ( $wgSpecTAP as $struct ) {
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
			TAPStrategies::init();
		}
		foreach ( $this->instances as $parser ) {
			if ( $parser->checkValid( $str ) ) {
				return $parser;
			}
		}
		return null;
	}
}
