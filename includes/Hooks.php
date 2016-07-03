<?php

namespace Spec;

use Html;

/**
 * Hook handlers for the Spec extension
 *
 * @file
 * @ingroup Extensions
 *
 * @license GNU GPL v2+
 * @author John Erling Blad
 */


class Hooks {
	/**
	 * Page indicator for module with spec tests
	 *
	 * @param string $engine
	 * @param array[] &$extraLibraries
	 */
	public static function onArticleViewHeader( &$article, &$outputDone, &$pcache ) {
		global $wgOut, $wgSpecFinalStates, $wgParser;

		if ( $article->getTitle() === null ) {
			// No title, exit
			return true;
		}

		if ( $article->getTitle()->getContentModel() !== CONTENT_MODEL_SCRIBUNTO ) {
			// Wrong content model, exit
			return true;
		}

		$wgOut->addModuleStyles( 'ext.spec.defaultDisplay' );

		// Get spec, if any
		$spec = Common::getSpecPage( $article->getTitle() );

		if ( $spec->getContentModel() === CONTENT_MODEL_SCRIBUNTO ) {
			$code = wfMessage(
				$spec->exists() ? 'spec-test-page-exist' : 'spec-test-page-not-exist',
				$spec->getBaseText()
			)->inContentLanguage();
			if ( $code->isDisabled() ) {
				return true;
			}

			$text = $code->parse();
			$state = 'unknown';
			if ( preg_match( $wgSpecFinalStates, $text, $matches ) ) {
				if ( $matches !== null && count( $matches ) !== 0 ) {
					$class = $matches[0];
				}
			}

			$msg = wfMessage( 'spec-test-page-' . $class )->inContentLanguage();
			if ( $msg->isDisabled() ) {
				return true;
			}

			$link = Html::rawElement(
				'a',
				[
					'href' => $spec->getLocalURL(),
					'target' => '_blank',
					'class' => [ 'mw-speclink', 'mw-speclink-' . $class ]
				],
				$msg->parse()
			);
			$wgOut->setIndicators( [ 'mw-speclink' => $link ] );
		} else {
			$msg = wfMessage( 'spec-test-page-other' )->inContentLanguage();
			if ( $msg->isDisabled() ) {
				return true;
			}
			$wgOut->setIndicators( [ 'mw-speclink' => $text->msg() ] );
		}

		return true;
	}

	/**
	 * Styling of page indicators
	 *
	 * @param string $engine
	 * @param array[] &$extraLibraries
	 */
	public static function onBeforePageDisplay( \OutputPage &$out, \Skin &$skin ) {}

}
