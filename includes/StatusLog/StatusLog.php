<?php

namespace Spec;

/**
 * Hook handlers for the change log in the Spec extension
 *
 * This is a form for adaptor, with the message passing done as extension data and the parser output
 * provided by the hook.
 *
 * @file
 * @ingroup Extensions
 *
 * @license GNU GPL v2+
 * @author John Erling Blad
 */

class StatusLog {

	/**
	 * Add change log for tested module
	 * This is a callback for a hook registered in extensions.json
	 */
	public static function onOutputPageParserOutput( \OutputPage &$out, \ParserOutput $parserOutput ) {
		global $wgTrackObserverUser;

		$currentLogKey = $parserOutput->getExtensionData( 'spec-status-current' );
		$previousLogKey = $parserOutput->getExtensionData( 'spec-status-previous' );

		if ( $currentLogKey !== $previousLogKey ) {
			$logEntry = new \ManualLogEntry( 'track', $currentLogKey );

			$logEntry->setPerformer( $wgTrackObserverUser );
			$logEntry->setTarget( $out->getTitle() );
			$logid = $logEntry->insert();
			$logEntry->publish( $logid );
		}

		return true;
	}
}
