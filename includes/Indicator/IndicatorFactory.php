<?php

namespace Pickle;

use MediaWiki\Logger\LoggerFactory;

/**
 * Strategy to create indicators
 * This is a factory for the indicators implemented as a common set of factories. The entries
 * will be adapted according to the current state.
 *
 * @ingroup Extensions
 */
class IndicatorFactory extends Strategies {

	use TNamedStrategies;

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
		global $wgPickleIndicator;

		$results = self::getInstance();
		foreach ( $wgPickleIndicator as $struct ) {
			$results->register( $struct );
		}

		return true;
	}

	/**
	 * Add track indicator for tested module
	 * This is a replacement for a hook registered in extensions.json
	 *
	 * @param \Title $title target of the categorization
	 * @param \ParserOutput $parserOutput parser result from the parsing process
	 * @param array|null $states additional states to be merged (optional)
	 * @return true
	 */
	public static function addIndicator(
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
				'subpage-message' => null,
				'page-type' => false
			],
			$states );

		$currentKey = $mergedStates[ 'status-current' ];
		$subpageMsg = $mergedStates[ 'subpage-message' ];
		$currentType = $mergedStates[ 'page-type' ];

		if ( $currentKey !== null
				&& in_array( $currentType, [ 'normal', 'test' ] ) ) {
			$strategy = self::getInstance()->find( $currentKey );
			if ( $strategy === null ) {
				return true;
			}
			if ( $subpageMsg !== null ) {
				$title = $subpageMsg->isDisabled() ? null : \Title::newFromText( $subpageMsg->plain() );
			}

			LoggerFactory::getInstance( 'Pickle' )
				->debug( 'Found concrete indicator: {name}',
					array_merge(
						[ 'method' => __METHOD__ ],
						$strategy->cloneOpts() ?: [] ) );

			$strategy->addIndicator( $title, $parserOutput, $states );
		}

		return true;
	}

}
