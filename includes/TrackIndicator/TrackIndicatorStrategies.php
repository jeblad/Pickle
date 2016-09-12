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
	 * Add change log for tested module
	 * This is a callback for a hook registered in extensions.json
	 */
	public static function onOutputPageParserOutput(
		\OutputPage &$out,
		\ParserOutput $parserOutput
	) {

		$currentKey = $parserOutput->getExtensionData( 'spec-status-current' );
		$subpageMsg = $parserOutput->getExtensionData( 'spec-subpage-message' );
		$currentType = $parserOutput->getExtensionData( 'spec-page-type' );

		if ( $currentKey !== null
				&& in_array( $currentType, [ 'normal', 'test' ] ) ) {
			$strategy = self::getInstance()->find( $currentKey );
			if ( $strategy === null ) {
				return true;
			}
			if ( $subpageMsg !== null ) {
				$title = $subpageMsg->isDisabled() ? null : \Title::newFromText( $subpageMsg->plain() );
			}
			$strategy->addIndicator( $title, $out );
		}

		return true;
	}

}
