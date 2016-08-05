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
		$invokeStrategy = InvokeSubpageStrategies::getInstance()->find( $title );
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
			$baseInvokeStrategy = InvokeSubpageStrategies::getInstance()->find( $baseTitle );
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
		$statusStrategy = ExtractStatusStrategies::getInstance()->find( $invokeMsg->parse() );
		if ( $statusStrategy === null ) {
			return true;
		}

		// keep the current state and forward data
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

		return true;
	}

	/**
	 * Setup for the extension
	 */
	public static function onExtensionSetup() {
		global $wgDebugComments;

		// turn on comments while in development
		$wgDebugComments = true;
	}

	/**
	 * @param string[] $files
	 */
	public static function onUnitTestsList( array &$files ) {
		$files[] = __DIR__ . '/../tests/phpunit/';
	}

}
