<?php

namespace Pickle;

use MediaWiki\Logger\LoggerFactory;

/**
 * Strategies to find an invoke subpage strategy
 * This is a factory for the invoke subpages implemented as a common set of strategies. The
 * entries will be found according to the title.
 *
 * @ingroup Extensions
 */
class InvokeSubpageStrategies extends Strategies {

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
		global $wgPickleInvokeSubpage;

		$results = self::getInstance();
		foreach ( $wgPickleInvokeSubpage as $struct ) {
			$results->register( $struct );
		}

		return true;
	}

	/**
	 * Checks if the string has any of the strategies stored patterns
	 *
	 * @param Title $title used as key
	 * @return string
	 */
	public function find( \Title $title ) {
		if ( $this->isEmpty() ) {
			self::init();
		}
		foreach ( $this->instances as $strategy ) {
			if ( $strategy->checkSubpageType( $title ) ) {
				LoggerFactory::getInstance( 'Pickle' )
					->debug( 'Found invoke subpage strategy: {name}',
						array_merge(
							[ 'method' => __METHOD__ ],
							$strategy->cloneOpts() ?: [] ) );
				return $strategy;
			}
		}
		return null;
	}
}
