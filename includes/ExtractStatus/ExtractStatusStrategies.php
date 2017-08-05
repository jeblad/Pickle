<?php

namespace Pickle;

use MediaWiki\Logger\LoggerFactory;

/**
 * Strategies to find an extract status strategy
 * This is a factory for the extracted statuses implemented as a common set of strategies. The
 * entries will be found according to the current result.
 *
 * @ingroup Extensions
 */
class ExtractStatusStrategies extends Strategies {

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
		global $wgPickleExtractStatus;

		$results = self::getInstance();
		foreach ( $wgPickleExtractStatus as $struct ) {
			$results->register( $struct );
		}

		return true;
	}

	/**
	 * Checks if the string has any of the strategies stored patterns
	 *
	 * @param string $str used as key
	 * @return string
	 */
	public function find( $str ) {
		if ( $this->isEmpty() ) {
			self::init();
		}
		foreach ( $this->instances as $strategy ) {
			$state = $strategy->checkState( $str );
			if ( is_bool( $state ) ? $state : true ) {
				LoggerFactory::getInstance( 'Pickle' )
					->debug( 'Found extract status strategy: {name}',
						array_merge(
							[ 'method' => __METHOD__ ],
							$strategy->cloneOpts() ?: [] ) );
				return $strategy;
			}
		}
		return null;
	}
}
