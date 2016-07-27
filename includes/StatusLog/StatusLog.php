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
	public static function onContentAlterParserOutput(
		\Content $content,
		\Title $title,
		\ParserOutput $parserOutput
	) {
		global $wgUser, $wgRequest;

		// if ($wgRequest->getAction !== 'view') {
		//	return true;
		// }

		$currentLogKey = $parserOutput->getExtensionData( 'spec-status-current' );
		$previousLogKey = $parserOutput->getExtensionData( 'spec-status-previous' );
		$first = $parserOutput->getExtensionData( 'spec-status-first' );

		if ( $currentLogKey !== $previousLogKey ) {
			$logEntry = new \ManualLogEntry( 'track', $currentLogKey );

			// if ( $wgRequest->getText( 'action' ) === 'edit' ) {
				$logEntry->setPerformer( $wgUser );
			// }
			$logEntry->setTarget( $title );
			$logid = $logEntry->insert();
			$logEntry->publish( $logid );
		}

		return true;
	}
}
