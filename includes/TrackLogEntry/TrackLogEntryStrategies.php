<?php

namespace Spec;

/**
 * Strategy to create log entries
 *
 * @ingroup Extensions
 *
 * @license GNU GPL v2+
 * @author John Erling Blad
 */
class TrackLogEntryStrategies extends Singletons {

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
		global $wgSpecTrackLogEntry;

		$results = TrackLogEntryStrategies::getInstance();
		foreach ( $wgSpecTrackLogEntry as $struct ) {
			$results->register( $struct );
		}

		return true;
	}

	/**
	 * Add change log for tested module
	 * This is a callback for a hook registered in extensions.json
	 */
	public static function onOutputPageParserOutput( \OutputPage &$out, \ParserOutput $parserOutput ) {

		$currentKey = $parserOutput->getExtensionData( 'spec-status-current' );
		$previousKey = $parserOutput->getExtensionData( 'spec-status-previous' );

		if ( $currentKey !== null && $currentKey !== $previousKey ) {
			$strategy = self::getInstance()->find( $currentKey );
			if ( $strategy === null ) {
				return true;
			}
			$strategy->addLogEntry( $out->getTitle() );
		}

		return true;
	}
}
