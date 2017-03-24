<?php

namespace Pickle;

use MediaWiki\Logger\LoggerFactory;

/**
 * Strategy to create categories
 * This is a factory for the categories implemented as a common set of factories. The entries
 * will be adapted according to the current state.
 *
 * @ingroup Extensions
 */
class CategoryFactory extends Strategies {

	use TNamedStrategies;

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
		global $wgPickleCategory;

		$results = CategoryFactory::getInstance();
		foreach ( $wgPickleCategory as $struct ) {
			$results->register( $struct );
		}

		return true;
	}

	/**
	 * Add track category for tested module
	 * This is a callback for a hook registered in extensions.json
	 */
	public static function addCategorization(
		\Title $title,
		\ParserOutput $parserOutput,
		array $states = null
	) {

		if ( $states == null ) {
			return true;
		}

		$mergedStates = array_merge(
			[
				'status-current' => null,
				'page-type' => false
			],
			$states );

		$currentKey = $mergedStates[ 'status-current' ];
		$currentType = $mergedStates[ 'page-type' ];

		if ( $currentKey !== null
				&& in_array( $currentType, [ 'normal' ] ) ) {
			$strategy = self::getInstance()->find( $currentKey );
			if ( $strategy === null ) {
				return true;
			}

			LoggerFactory::getInstance( 'Pickle' )
				->debug( 'Found concrete category: {name}',
					array_merge(
						[ 'method' => __METHOD__ ],
						$strategy->cloneOpts() ?: [] ) );

			$strategy->addCategorization( $title, $parserOutput );
		}

		return true;
	}
}
