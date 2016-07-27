<?php

namespace Spec;

/**
 * Hook handlers for the status indicators in the Spec extension
 *
 * This is a form for adaptor, with the message passing done as extension data and the output page
 * provided by the hook.
 *
 * @file
 * @ingroup Extensions
 *
 * @license GNU GPL v2+
 * @author John Erling Blad
 */

class StatusIndicator {

	/**
	 * Make a page status indicator link given status and url
	 *
	 * @param string $status representing the state
	 * @param string $url to the internal or external page
	 * @return Html|null
	 */
	public static function makeLink( $status, $url ) {

		// Get the message containing the text to use for the link
		// @message spec-test-text-good
		// @message spec-test-text-pending
		// @message spec-test-text-failing
		// @message spec-test-text-missing
		// @message spec-test-text-unknown
		$msg = wfMessage( 'spec-test-text-' . $status )->inContentLanguage();
		if ( $msg->isDisabled() ) {
			return null;
		}

		// Build a link for the page status indicator
		$elem = \Html::rawElement(
			'a',
			[
				'href' => $url,
				'target' => '_blank',
				'class' => [ 'mw-speclink', 'mw-speclink-' . $status ]
			],
			$msg->parse()
		);

		return $elem;
	}

	/**
	 * Make a page status indicator note given status
	 *
	 * @param string $status representing the state
	 * @return Html|null
	 */
	public static function makeNote( $status ) {

		// Get the message containing the text to use for the link
		// @message spec-test-text-good
		// @message spec-test-text-pending
		// @message spec-test-text-failing
		// @message spec-test-text-missing
		// @message spec-test-text-unknown
		$msg = wfMessage( 'spec-test-text-' . $status )->inContentLanguage();
		if ( $msg->isDisabled() ) {
			return null;
		}

		// Build a link for the page status indicator
		$elem = \Html::rawElement(
			'span',
			[
				'class' => [ 'mw-speclink', 'mw-speclink-' . $status ]
			],
			$msg->parse()
		);

		return $elem;
	}

	/**
	 * Add page status indicator for tested module
	 * This is a callback for a hook registered in extensions.json
	 */
	public static function onOutputPageParserOutput(
		\OutputPage &$out,
		\ParserOutput $parserOutput
	) {
		$statusName = $parserOutput->getExtensionData( 'spec-status-current' );
		$subpageMsg = $parserOutput->getExtensionData( 'spec-subpage-message' );

		if ( $statusName !== null ) {
			$elem = null;

			if ( $subpageMsg !== null && ! $subpageMsg->isDisabled() ) {
				$subpage = \Title::newFromText( $subpageMsg->plain() );
				$elem = self::makeLink( $statusName, $subpage->getLocalURL() );
			} else {
				$elem = self::makeNote( $statusName );
			}

			if ( $elem !== null ) {
				$out->addModuleStyles( 'ext.spec.defaultDisplay' );
				$res = $out->setIndicators( [ 'mw-speclink' => $elem ] );
			}
		}

		return true;
	}
}
