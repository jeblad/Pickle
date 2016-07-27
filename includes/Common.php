<?php

namespace Spec;

use Title;
use Html;

/**
 * Static function collection for general extension support.
 */
class Common {

	/**
	 * Test whether the page should be considered a spec page
	 *
	 * @ provenance virtually identical to Scribunto::isDocPage() except for the message
	 *
	 * @param Title $title
	 * @param Title &$forModule Module for which this is a spec page
	 * @return boolean
	 */
	public static function isSpecPage( Title $title, Title &$forModule = null ) {
		$specPage = wfMessage( 'spec-test-page-name' )->inContentLanguage();
		if ( $specPage->isDisabled() ) {
			return false;
		}

		// Canonicalize the input pseudo-title. The unreplaced "$1" shouldn't
		// cause a problem.
		$specTitle = Title::newFromText( $specPage->plain() );
		if ( !$specTitle ) {
			return false;
		}
		$specPage = $specTitle->getPrefixedText();

		// Make it into a regex, and match it against the input title
		$specPage = str_replace( '\\$1', '(.+)', preg_quote( $specPage, '/' ) );
		if ( preg_match( "/^$specPage$/", $title->getPrefixedText(), $m ) ) {
			$forModule = Title::makeTitleSafe( NS_MODULE, $m[1] );
			return $forModule !== null;
		} else {
			return false;
		}
	}

	/**
	 * Return the Title for the spec page
	 *
	 * @ provenance virtually identical to Scribunto::isDocPage() except for the message
	 *
	 * @param Title $title
	 * @return Title|null
	 */
	public static function getSpecPage( Title $title ) {
		$specPage = wfMessage( 'spec-test-page-name', $title->getText() )->inContentLanguage();
		if ( $specPage->isDisabled() ) {
			return null;
		}

		return Title::newFromText( $specPage->plain() );
	}
}
