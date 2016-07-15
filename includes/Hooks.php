<?php

namespace Spec;

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
	 * Helper to handle case when the page under test is processed
	 *
	 * @param Title $spec
	 */
	private static function whenTesterModule( &$spec ) {
		global $wgOut;
		$wgOut->addHelpLink( '//mediawiki.org/wiki/Special:MyLanguage/Help:Spec', true );
		return;

	}

	/**
	 * Helper to handle case when the page under test is processed
	 *
	 * @param Title $spec
	 */
	private static function whenTesteeModule( &$spec ) {
		global $wgOut, $wgSpecFinalResults;

		// Get the message containing the wiki code
		$key = null;
		if ( $spec->getContentModel() === CONTENT_MODEL_SCRIBUNTO ) {
			$key = $spec->exists() ? 'spec-test-page-exist' : 'spec-test-page-not-exist';
		} else {
			$key = $spec->exists() ? 'spec-other-page-exist' : 'spec-other-page-not-exist';
		}
		$code = wfMessage( $key, $spec->getBaseText() )->inContentLanguage();
		if ( $code->isDisabled() ) {
			return;
		}

		// Parse wiki code to get result
		$result = $code ? $code->parse() : '';

		// Extract state information from result
		$state = $wgSpecFinalResults->findState( $result )
			or $state = 'unknown';

		// Create and add the indicator
		$link = Common::makeIndicatorLink( $state, $spec->getLocalURL() );
		if ( $link ) {
			$wgOut->addModuleStyles( 'ext.spec.defaultDisplay' );
			$wgOut->setIndicators( [ 'mw-speclink' => $link ] );

		}

		// Add the tracking category
		// $wgParser->addTrackingCategory( 'spec-test-category-'.$state );

		return;
	}

	/**
	 * Page indicator for module with spec tests
	 *
	 * @param Article &$article
	 * @param Boolean &$outputDone
	 * @param ParserCache &$pcache
	 */
	public static function onArticleViewHeader( &$article, &$outputDone, &$pcache ) {

		// If there is no title, then bail out
		if ( $article->getTitle() === null ) {
			return true;
		}

		// If the content model is wrong, then bail out
		if ( $article->getTitle()->getContentModel() !== CONTENT_MODEL_SCRIBUNTO ) {
			return true;
		}

		// Is this on the tester or testee?
		if ( Common::isSpecPage( $article->getTitle() ) ) {
			// @todo an additional check to see if the module contains method calls
			$spec = Common::getSpecPage( $article->getTitle() );
			self::whenTesterModule( $spec );
		} else {
			self::whenTesteeModule( $article->getTitle() );
		}

		return true;
	}

	/**
	 * Setup for the extension
	 */
	public static function onExtensionLoad() {
		global $wgSpecFinalResults;
		// global $wgSpecFinalResults, $wgSpecContentTypes;

		$results = FinalResultSingleton::init();
		foreach ( $wgSpecFinalResults as $struct ) {
			$results->registerStrategy( $struct );
		}
	}

	/**
	 * @param string[] $files
	 */
	public static function onUnitTestsList( array &$files ) {
		$files[] = __DIR__ . '/../tests/phpunit/';
	}

}
