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
	 * Get final strategy
	 */
	public static function getFinalStrategy(
		IInvokeSubpageStrategy $strategy,
		\Title $title
	) {
		// try to squash the text into submission
		$text = $strategy->getInvoke( $title )->parse();
		$tapStrategy = TestAnythingProtocolStrategies::getInstance()->find( $text );
		if ( $tapStrategy !== null ) {
			$text = $tapStrategy->parse( $text );
		}

		// try to find the final status strategy
		$statusStrategy = ExtractStatusStrategies::getInstance()->find( $text );
		if ( $statusStrategy === null ) {
			return null;
		}

		return $statusStrategy;
	}

	/**
	 * Page indicator for module with spec tests
	 */
	public static function onContentAlterParserOutput(
		\Content $content,
		\Title $title,
		\ParserOutput $parserOutput
	) {
		global $wgSpecNeglectPages;

		// Try to bail out early
		if ( $title === null
			|| $title->getArticleID() === 0
			|| $title->getContentModel() !== CONTENT_MODEL_SCRIBUNTO ) {
			return true;
		}

		// @todo refactor, this is a quick fix
		$text = $title->getText();
		foreach ( $wgSpecNeglectPages as $pattern ) {
			if ( strpos( $text, $pattern ) !== false ) {
				return true;
			}
		}

		// try to find a subpage to invoke
		$invokeStrategy = InvokeSubpageStrategies::getInstance()->find( $title );
		if ( $invokeStrategy === null ) {
			return true;
		}

		// subpages need special handling
		if ( $title->isSubpage() ) {
			// check if this page is a valid subpage itself
			$baseTitle = $title->getBaseTitle();
			if ( $baseTitle !== null ) {
				$baseInvokeStrategy = InvokeSubpageStrategies::getInstance()->find( $baseTitle );
				if ( $baseInvokeStrategy !== null ) {
					$maybePageMsg = $baseInvokeStrategy->getSubpagePrefixedText( $baseTitle );
					if ( ! $maybePageMsg->isDisabled() ) {
						$maybePage = $maybePageMsg->plain();
						if ( $maybePage == $title->getPrefixedText() ) {

							// at this point the page type is "normal"
							$parserOutput->setExtensionData( 'spec-page-type', 'test' );

							// if invocation is disabled, then the state will be set to "exists" or "missing"
							if ( $baseInvokeStrategy->getInvoke( $baseTitle )->isDisabled() ) {
								$parserOutput->setExtensionData( 'spec-status-current',
									'unknown' );
								return true;
							}

							// if status isn't found, then the state will be set to "unknown"
							$statusStrategy = self::getFinalStrategy( $baseInvokeStrategy, $baseTitle );
							if ( $statusStrategy === null ) {
								$parserOutput->setExtensionData( 'spec-status-current',
									'unknown' );
								return true;
							}

							// default when nothing goes wrong
							$parserOutput->setExtensionData( 'spec-status-current',
								$statusStrategy->getName() );

							// $out->addHelpLink( '//mediawiki.org/wiki/Special:MyLanguage/Help:Spec', true );
							return true;
						}
					}
				}
			}
		}

		// at this point the page type is "normal"
		$parserOutput->setExtensionData( 'spec-page-type', 'normal' );

		// at this point it is safe to save the expected subpage
		$parserOutput->setExtensionData( 'spec-subpage-message',
			$invokeStrategy->getSubpagePrefixedText( $title ) );

		// if invocation is disabled, then the state will be set to "exists" or "missing"
		if ( $invokeStrategy->getInvoke( $title )->isDisabled() ) {
			$parserOutput->setExtensionData( 'spec-status-current',
				$invokeStrategy->getSubpageTitle( $title )->exists() ? 'exists' : 'missing' );
			return true;
		}

		// if status isn't found, then the state will be set to "unknown"
		$statusStrategy = self::getFinalStrategy( $invokeStrategy, $title );
		if ( $statusStrategy === null ) {
			$parserOutput->setExtensionData( 'spec-status-current',
				'unknown' );
			return true;
		}

		// keep the current state as page property and forward extension data
		$pageProps = \PageProps::getInstance()->getProperties( $title, 'spec-status' );
		$previousStatus = unserialize( $pageProps[$title->getArticleId()] );
		$parserOutput->setExtensionData( 'spec-status-previous',
			$previousStatus === null ? '' : $previousStatus );
		$parserOutput->setExtensionData( 'spec-status-current',
			$statusStrategy->getName() );
		$parserOutput->setProperty( 'spec-status',
			serialize( $statusStrategy->getName() ) );
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
