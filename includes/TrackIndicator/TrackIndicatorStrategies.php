<?php

namespace Spec;

/**
 * Strategy to create indicators
 *
 * @ingroup Extensions
 *
 * @license GNU GPL v2+
 * @author John Erling Blad
 */
class TrackIndicatorStrategies extends Singletons {

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
		global $wgSpecTrackIndicator;

		$results = TrackIndicatorStrategies::getInstance();
		foreach ( $wgSpecTrackIndicator as $struct ) {
			$results->register( $struct );
		}

		return true;
	}

	/**
	 * Add track indicator for tested module
	 * This is a replacement for a hook registered in extensions.json
	 */
	public static function addIndicator(
		\Title $title,
		\ParserOutput &$parserOutput,
		array $states = null
	) {

		if ( $states == null ) {
			return true;
		}

		$currentKey = $states[ 'status-current' ];
		$subpageMsg = $states[ 'subpage-message' ];
		$currentType = $states[ 'page-type' ];

		if ( $currentKey !== null
				&& in_array( $currentType, [ 'normal', 'test' ] ) ) {
			$strategy = self::getInstance()->find( $currentKey );
			if ( $strategy === null ) {
				return true;
			}
			if ( $subpageMsg !== null ) {
				$title = $subpageMsg->isDisabled() ? null : \Title::newFromText( $subpageMsg->plain() );
			}
			$strategy->addIndicator( $title, $parserOutput, $states );
		}

		return true;
	}

}
