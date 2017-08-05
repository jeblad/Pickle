<?php

namespace Pickle;

use MediaWiki\Logger\LoggerFactory;

/**
 * Hook handlers for the Pickle extension
 *
 * @ingroup Extensions
 */

class Hooks {

	/**
	 * Get final strategy
	 *
	 *  @SuppressWarnings(PHPMD.StaticAccess)
	 *
	 * @param \Pickle\InvokeSubpage $strategy to act upon
	 * @param \Title $title header information
	 * @return any|null
	 */
	public static function getFinalStrategy(
		InvokeSubpage $strategy,
		\Title $title
	) {
		$logger = LoggerFactory::getInstance( 'Pickle' );

		// try to squash the text into submission
		$text = $strategy->getInvoke( $title )->parse();
		$logger->debug( 'Raw text: {text}', [
			'text' => $text,
			'title' => $title->getFullText(),
			'method' => __METHOD__
		] );
		$tapStrategy = TAPStrategies::getInstance()->find( $text );
		if ( $tapStrategy !== null ) {
			$text = $tapStrategy->parse( $text );
			$logger->debug( 'Found TAP, optional parse: {text}', [
				'text' => $text,
				'title' => $title->getFullText(),
				'method' => __METHOD__
			] );
		}

		// try to find the final status strategy
		$statusStrategy = ExtractStatusStrategies::getInstance()->find( $text );
		if ( $statusStrategy === null ) {
			return null;
		}
		$logger->debug( 'Extracted status: {text}', [
			'text' => $statusStrategy->getName(),
			'title' => $title->getFullText(),
			'method' => __METHOD__
		] );

		return $statusStrategy;
	}

	/**
	 * Is Scribunto
	 *
	 * @param \Title|null $title header information
	 * @return bool
	 */
	 protected static function isScribunto( \Title $title = null ) {
		return ( $title !== null
			&& $title->getArticleID() !== 0
			&& $title->getContentModel() === CONTENT_MODEL_SCRIBUNTO );
	 }

	/**
	 * Is neglected
	 * This only scans for similar text fragments, and can fail badly.
	 *
	 * @SuppressWarnings(PHPMD.LongVariable)
	 *
	 * @param \Title $title header information
	 * @return bool
	 */
	 protected static function isNeglected( \Title $title = null ) {
		global $wgPickleNeglectSubpages;

		// just to handle null without croaking
		if ( $title === null ) {
			return true;
		}

		$text = $title->getSubpageText();
		foreach ( $wgPickleNeglectSubpages as $pattern ) {
			// @todo https://github.com/jeblad/Pickle/issues/2
			if ( preg_match( $pattern, $text ) ) {
				return true;
			}
		}

		return false;
	 }

	/**
	 * Page indicator for module with pickle tests
	 *
	 * @SuppressWarnings(PHPMD.StaticAccess)
	 * @SuppressWarnings(PHPMD.UnusedFormalParameter)
	 *
	 * @todo design debt
	 * @param \Content $content destination for changes
	 * @param \Title $title header information
	 * @param \ParserOutput $parserOutput to be passed on
	 * @return bool
	 */
	public static function onContentAlterParserOutput(
		\Content $content,
		\Title $title,
		\ParserOutput $parserOutput
	) {
		// Try to bail out early
		if ( !self::isScribunto( $title ) || self::isNeglected( $title ) ) {
			return true;
		}

		// try to find a subpage to invoke
		$invokeStrategy = InvokeSubpageStrategies::getInstance()->find( $title );
		if ( $invokeStrategy === null ) {
			return true;
		}

		// It is probably safe to assume this will be used
		$logger = LoggerFactory::getInstance( 'Pickle' );

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
							$statusStrategy = self::getFinalStrategy( $baseInvokeStrategy, $baseTitle );

							// collect args for the hook
							$args = [];
							$args[ 'page-type' ] = 'normal';
							if ( !$baseInvokeStrategy->getInvoke( $baseTitle )->isDisabled() ) {
								$args[ 'status-current' ] =
									isset( $statusStrategy ) ? $statusStrategy->getName() : 'unknown';
							}

							$logger->debug( 'Current status: {text}', [
								'text' => $args[ 'status-current' ],
								'title' => $title->getFullText(),
								'method' => __METHOD__
							] );

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

		// keep the current page props for later
		$pageProps = \PageProps::getInstance()->getProperties( $title, 'pickle-status' );
		$statusStrategy = self::getFinalStrategy( $invokeStrategy, $title );
		$parserOutput->setProperty( 'pickle-status', serialize( $statusStrategy->getName() ) );

		// collect args for the hook
		$args = [];
		$args[ 'page-type' ] = 'normal';
		$args[ 'subpage-message' ] = $invokeStrategy->getSubpagePrefixedText( $title );
		if ( !$invokeStrategy->getInvoke( $title )->isDisabled() ) {
			$args[ 'status-current' ] =
				isset( $statusStrategy ) ? $statusStrategy->getName() : 'unknown';
			$args[ 'status-previous' ] =
				isset( $pageProps[$title->getArticleId()] ) ? $pageProps[$title->getArticleId()]: '';
		}

		$logger->debug( 'Current status: {text}', [
			'text' => $args[ 'status-current' ],
			'title' => $title->getFullText(),
			'method' => __METHOD__
		] );

		// run registered callbacks to create testee gadgets
		\Hooks::run( 'SpecTesteeGadgets', [ $title, $parserOutput, $args ] );
		return true;
	}

	/**
	 * Render the pickle
	 * This is the function that evaluate {{#pickle:}} and stringifies the result.
	 *
	 * @SuppressWarnings(PHPMD.LongVariable)
	 * @SuppressWarnings(PHPMD.StaticAccess)
	 * @SuppressWarnings(PHPMD.UnusedFormalParameter)
	 *
	 * @param any $parser the object that triggered the call
	 * @param string $text for page name
	 * @return string
	 */
	public static function renderPickle( $parser, $text ) {
		global $wgPickleDefaultNamespace;

		// Get the assumed title object
		$title = \Title::newFromText( $text, $wgPickleDefaultNamespace );

		// Try to bail out early
		if ( !self::isScribunto( $title ) ) {
			$msg = wfMessage( 'pickle-test-text-invalid' );
			isset( $lang ) ? $msg->inLanguage( $lang ) : $msg->inContentLanguage();
			return $msg->plain();
		}
		if ( self::isNeglected( $title ) ) {
			$msg = wfMessage( 'pickle-test-text-missing' );
			isset( $lang ) ? $msg->inLanguage( $lang ) : $msg->inContentLanguage();
			return $msg->plain();
		}

		// try to find a subpage to invoke
		$invokeStrategy = InvokeSubpageStrategies::getInstance()->find( $title );
		if ( $invokeStrategy === null ) {
			$msg = wfMessage( 'pickle-test-text-invalid' );
			isset( $lang ) ? $msg->inLanguage( $lang ) : $msg->inContentLanguage();
			return $msg->plain();
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
							$statusStrategy = self::getFinalStrategy( $baseInvokeStrategy, $baseTitle );

							// collect args for the hook (but we don't use the hook in this case…)
							$args = [];
							$args[ 'page-type' ] = 'normal';

							// if invocation is disabled, then the state will be set to "exists" or "missing"
							if ( ! $baseInvokeStrategy->getInvoke( $baseTitle )->isDisabled() ) {
								$args[ 'status-current' ] =
									isset( $statusStrategy ) ? $statusStrategy->getName() : 'unknown';
							}

							$msg = wfMessage( 'pickle-test-text-subpage' );
							$msg = $lang === null ? $msg->inContentLanguage() : $msg->inLanguage( $lang );
							return $msg->plain();
						}
					}
				}
			}
		}

		$statusStrategy = self::getFinalStrategy( $invokeStrategy, $title );
		return $title->getPrefixedText();
	}

	/**
	 * Setup for the parser
	 * @param any &$parser the place to inject the new function
	 */
	public static function onParserSetup( &$parser ) {
		$parser->setFunctionHook( 'pickle', [ __CLASS__, 'Pickle\\Hooks::renderPickle' ] );
	}

	/**
	 *
	 * @SuppressWarnings(PHPMD.LongVariable)
	 *
	 * Setup for the extension
	 */
	public static function onExtensionSetup() {
		global $wgDebugComments;

		// turn on comments while in development
		$wgDebugComments = true;
	}

	/**
	 * @param string[] &$files to be tested
	 */
	public static function onUnitTestsList( array &$files ) {
		$files[] = __DIR__ . '/../tests/phpunit/';
	}

	/**
	 * External Lua library paths for Scribunto
	 *
	 * @param any $engine to be used for the call
	 * @param array &$extraLibraryPaths additional libs
	 * @return bool
	 */
	public static function onRegisterScribuntoExternalLibraryPaths(
		$engine,
		array &$extraLibraryPaths
	) {
		if ( $engine !== 'lua' ) {
			return true;
		}

		// Path containing pure Lua libraries that don't need to interact with PHP
		$extraLibraryPaths[] = __DIR__ . '/LuaLibrary/lua/pure';

		return true;
	}

	/**
	 * Extra Lua libraries for Scribunto
	 *
	 * @param any $engine to be used for the call
	 * @param array &$extraLibraries additional libs
	 * @return bool
	 */
	public static function onRegisterScribuntoLibraries( $engine, array &$extraLibraries ) {
		if ( $engine !== 'lua' ) {
			return true;
		}

		$extraLibraries['pickle'] = [
			'class' => '\Pickle\LuaLibPickle',
			'deferLoad' => false
		];

		return true;
	}
}
