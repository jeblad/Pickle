<?php

namespace Spec;

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
	 * Who am I
	 */
	public static function who() {
		return __CLASS__;
	}

	/**
	 * Configure the strategies
	 */
	public static function init() {
		global $wgSpecInvokeSubpage;

		$results = InvokeSubpageStrategies::getInstance();
		foreach ( $wgSpecInvokeSubpage as $struct ) {
			$results->register( $struct );
		}

		return true;
	}

	/**
	 * Checks if the string has any of the strategies stored patterns
	 *
	 * @param Title $title
	 *
	 * @return string
	 */
	public function find( \Title $title ) {
		if ( $this->isEmpty() ) {
			InvokeSubpageStrategies::init();
		}
		foreach ( $this->instances as $strategy ) {
			if ( $strategy->checkSubpageType( $title ) ) {
				LoggerFactory::getInstance( 'Spec' )
					->debug( 'Found invoke subpage strategy: {name}',
						array_merge(
							[ 'method' => __METHOD__ ],
							$strategy->opts ?: [] ) );
				return $strategy;
			}
		}
		return null;
	}
}
