<?php

namespace Spec;

/**
 * Hook handlers for the Spec extension
 *
 * @ingroup Extensions
 */

class Hooks {

	/**
	 * Get final strategy
	 */
	public static function getFinalStrategy(
		IInvokeSubpage $strategy,
		\Title $title
	) {
		// try to squash the text into submission
		$text = $strategy->getInvoke( $title )->parse();
		$tapStrategy = TAPStrategies::getInstance()->find( $text );
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
	 * @todo design debt
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

							// start collecting args for the hook
							$args = [
								// at this point the page type is test"
								'page-type' => 'normal',
							];

							// if invocation is disabled, then the state will be set to "exists" or "missing"
							if ( $baseInvokeStrategy->getInvoke( $baseTitle )->isDisabled() ) {
								$args[ 'status-current' ] = 'unknown';
							} else {
								// if status isn't found, then the state will be set to "unknown"
								$statusStrategy = self::getFinalStrategy( $baseInvokeStrategy, $baseTitle );
								if ( $statusStrategy === null ) {
									$args[ 'status-current' ] = 'unknown';
								} else {
									$args[ 'status-current' ] = $statusStrategy->getName();
								}
							}

							// add the usual help link
							HelpView::build();

							// run registered callbacks to create testee gadgets
							\Hooks::run( 'SpecTesterGadgets', [ $title, $parserOutput, $args ] );

							return true;
						}
					}
				}
			}
		}

		// keep the current state as page property for later
		$pageProps = \PageProps::getInstance()->getProperties( $title, 'spec-status' );
		$previousStatus = unserialize( $pageProps[$title->getArticleId()] );
		$statusStrategy = self::getFinalStrategy( $invokeStrategy, $title );
		$parserOutput->setProperty( 'spec-status', serialize( $statusStrategy->getName() ) );

		// start collecting args for the hook
		$args = [
			// at this point the page type is "normal"
			'page-type' => 'normal',
			// at this point it is safe to expect the subpage
			'subpage-message' => $invokeStrategy->getSubpagePrefixedText( $title ),
		];
		// if invocation is disabled, then the state will be set to "exists" or "missing"
		if ( $invokeStrategy->getInvoke( $title )->isDisabled() ) {
			$args[ 'status-current' ] =
				$invokeStrategy->getSubpageTitle( $title )->exists() ? 'exists' : 'missing';
		} else {
			// if status isn't found, then the state will be set to "unknown"
			if ( $statusStrategy === null ) {
				$args[ 'status-current' ] = 'unknown';
			} else {
				// should be safe to set these now
				$args[ 'status-previous' ] = $previousStatus === null ? '' : $previousStatus;
				$args[ 'status-current' ] = $statusStrategy->getName();
			}
		}

		// run registered callbacks to create testee gadgets
		\Hooks::run( 'SpecTesteeGadgets', [ $title, $parserOutput, $args ] );
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
