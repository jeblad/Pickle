<?php

namespace Spec;

/**
 * Strategy to create categories
 *
 * @ingroup Extensions
 *
 * @license GNU GPL v2+
 * @author John Erling Blad
 */
class TrackCategoryStrategies extends Singletons {

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
		global $wgSpecTrackCategory;

		$results = TrackCategoryStrategies::getInstance();
		foreach ( $wgSpecTrackCategory as $struct ) {
			$results->register( $struct );
		}

		return true;
	}

	/**
	 * Add change log for tested module
	 * This is a callback for a hook registered in extensions.json
	 */
	public static function onContentAlterParserOutput(
		\Content $content,
		\Title $title,
		\ParserOutput $parserOutput
	) {

		$currentKey = $parserOutput->getExtensionData( 'spec-status-current' );
		$currentType = $parserOutput->getExtensionData( 'spec-page-type' );

		if ( $currentKey !== null
				&& in_array( $currentType, [ 'normal' ] ) ) {
			$strategy = self::getInstance()->find( $currentKey );
			if ( $strategy === null ) {
				return true;
			}
			$strategy->addCategorization( $title, $parserOutput );
		}

		return true;
	}
}
