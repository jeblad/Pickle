<?php

namespace Pickle;

use MediaWiki\Logger\LoggerFactory;

/**
 * Strategies to squash tap reports
 *
 * @ingroup Extensions
 */
class TAPStrategies extends Strategies {

	/**
	 * Who (am I)
	 *
	 * @return class
	 */
	public static function who() {
		return __CLASS__;
	}

	/**
	 * Configure the strategies
	 *
	 * @return true
	 */
	public static function init() {
		global $wgPickleTAP;

		$results = self::getInstance();
		foreach ( $wgPickleTAP as $struct ) {
			$results->register( $struct );
		}

		return true;
	}

	/**
	 * Checks if the string has any of the strategies stored patterns
	 *
	 *
	 * @param string $str used as key
	 * @return string
	 */
	public function find( $str ) {
		if ( $this->isEmpty() ) {
			self::init();
		}
		foreach ( $this->instances as $parser ) {
			if ( $parser->checkValid( $str ) ) {
				LoggerFactory::getInstance( 'Pickle' )->debug( 'Found parser strategy: {name}',
					array_merge(
						[ 'method' => __METHOD__ ],
						$parser->cloneOpts() ?: [] ) );
				return $parser;
			}
		}
		return null;
	}
}
