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

	/**
	 * Find some kind of representation of the string
	 *
	 * @todo state is not a good name for this…
	 *
	 * @param string $str representing the heystack
	 * @return string for the recognized state
	 */
	public static function findState( $str ) {
		global $wgSpecFinalStates;

		// Extract state information from result
		$state = null;
		foreach ( $wgSpecFinalStates as $name => $pattern ) {
			if ( preg_match( $pattern, $str ) ) {
				$state = $name;
				break;
			}
		}
		return $state;
	}

	/**
	 * Make a page indicator given a state and url
	 *
	 * @param string $state representing the state
	 * @param string $url to the internal or external page
	 * @return Html|null
	 */
	public static function makeIndicatorLink( $state, $url ) {

		// Get the message containing the text to use for the link
		$msg = wfMessage( 'spec-test-text-' . $state )->inContentLanguage();
		if ( $msg->isDisabled() ) {
			return null;
		}

		// Build a link for the page indicator
		$link = Html::rawElement(
			'a',
			[
				'href' => $url,
				'target' => '_blank',
				'class' => [ 'mw-speclink', 'mw-speclink-' . $state ]
			],
			$msg->parse()
		);

		return $link;
	}
}
