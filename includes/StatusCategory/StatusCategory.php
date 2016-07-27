<?php

namespace Spec;

/**
 * Hook handlers for the tracking categories in the Spec extension
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

class StatusCategory {

	/**
	 * Add tracking category for tested module
	 * This is a callback for a hook registered in extensions.json
	 */
	public static function onContentAlterParserOutput(
		\Content $content,
		\Title $title,
		\ParserOutput $parserOutput
	) {
		$categoryKey = $parserOutput->getExtensionData( 'spec-tracking-category-key' );

		if ( $categoryKey !== null ) {
		    $parserOutput->addTrackingCategory( $categoryKey, $title );
		}

		return true;
	}
}
