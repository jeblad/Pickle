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
	 * Page indicator for module with spec tests
	 */
	public static function onContentAlterParserOutput(
		\Content $content,
		\Title $title,
		\ParserOutput $parserOutput
	) {

		// If there is no title, then bail out
		if ( $title === null ) {
			return true;
		}
		if ( $title->getArticleID() === 0 ) {
			return true;
		}

		// If the content model is wrong, then bail out
		if ( $title->getContentModel() !== CONTENT_MODEL_SCRIBUNTO ) {
			return true;
		}

		// try to find a subpage to invoke
		$invokeStrategy = InvokeSubpageStrategies::init()->find( $title );
		if ( $invokeStrategy === null ) {
			return true;
		}

		// get the message containing the invoke call
		$invokeMsg = $invokeStrategy->getInvoke( $title );
		if ( $invokeMsg->isDisabled() ) {
			return true;
		}

		// check if this page can be detected as a subpage itself
		$baseTitle = $title->getBaseTitle();
		if ( $baseTitle !== null ) {
			$baseInvokeStrategy = InvokeSubpageStrategies::init()->find( $baseTitle );
			if ( $baseInvokeStrategy !== null ) {
				$maybePageMsg = $invokeStrategy->getSubpagePrefixedText( $baseTitle );
				if ( ! $maybePageMsg->isDisabled() ) {
					$maybePage = $maybePageMsg->plain();
					if ( $maybePage == $title->getPrefixedText() ) {
						// $out->addHelpLink( '//mediawiki.org/wiki/Special:MyLanguage/Help:Spec', true );
						return true;
					}
				}
			}
		}

		// try to find the final status strategy
		$statusStrategy = ExtractStatusStrategies::init()->find( $invokeMsg->parse() );
		if ( $statusStrategy === null ) {
			return true;
		}

		// keep the current state and forward data
		$parserOutput->setExtensionData( 'spec-status-first',
			$parserOutput->getProperty( 'spec-status' ) === null );
		$pageProps = \PageProps::getInstance()->getProperties( $title, 'spec-status' );
		$previousStatus = unserialize( $pageProps[$title->getArticleId()] );
		$parserOutput->setExtensionData( 'spec-status-previous',
			$previousStatus === null ? '' : $previousStatus );
		$parserOutput->setExtensionData( 'spec-status-current',
			$statusStrategy->getName() );
		$parserOutput->setProperty( 'spec-status',
			serialize( $statusStrategy->getName() ) );
		$parserOutput->setExtensionData( 'spec-subpage-message',
			$invokeStrategy->getSubpagePrefixedText( $title ) );
		$parserOutput->setExtensionData( 'spec-tracking-category-key',
			'spec-tracking-category-' . $statusStrategy->getName() );

		return true;
	}

	/**
	 * Setup for the extension
	 */
	public static function onExtensionSetup() {
		global $wgSpecExtractStatus, $wgSpecInvokeSubpages;
		global $wgDebugComments;
		$wgDebugComments = true;

		// @todo generalize
		$results = ExtractStatusStrategies::init();
		foreach ( $wgSpecExtractStatus as $struct ) {
			$results->registerStrategy( $struct );
		}
		$results->registerStrategy( [ 'class' => 'Spec\ExtractStatusDefaultStrategy' ] );

		// @todo generalize
		$results = InvokeSubpageStrategies::init();
		foreach ( $wgSpecInvokeSubpages as $struct ) {
			$results->registerStrategy( $struct );
		}
		$results->registerStrategy( [ 'class' => 'Spec\InvokeSubpageDefaultStrategy' ] );
	}

	/**
	 * @param string[] $files
	 */
	public static function onUnitTestsList( array &$files ) {
		$files[] = __DIR__ . '/../tests/phpunit/';
	}

}
