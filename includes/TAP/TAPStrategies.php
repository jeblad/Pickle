<?php

namespace Spec;

use MediaWiki\Logger\LoggerFactory;

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
				LoggerFactory::getInstance( 'Spec' )->debug( 'Found parser strategy: {name}',
					array_merge( [ 'method' => __METHOD__ ], $parser->opts ?: [] ) );
				return $parser;
			}
		}
		return null;
	}
}
