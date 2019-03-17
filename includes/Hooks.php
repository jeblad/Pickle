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
	 protected static function isScribunto(
		\Title $title = null
	) {
		return ( $title !== null
			&& $title->getArticleID() !== 0
			&& $title->getContentModel() === CONTENT_MODEL_SCRIBUNTO );
	 }

	/**
	 * Is neglected
	 * This only scans for similar text fragments, and can fail badly.
	 *
	 * @param \Title|null $title header information
	 * @return bool
	 */
	 protected static function isNeglected(
		\Title $title = null
	) {
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
	 * Bulid arguments for the tester hook
	 *
	 * @param InvokeSubpage $invoke how to get the subpage
	 * @param \Title $title header information
	 * @param ExtractStatus $extract how to extract the status
	 * @return table containing the arguments
	 */
	public static function buildTesterArgs(
		InvokeSubpage $invoke,
		\Title $title,
		ExtractStatus $extract
	) {
		$args = [];

		// collect args
		$args[ 'page-type' ] = 'test';
		if ( !$invoke->getInvoke( $title )->isDisabled() ) {
			$args[ 'status-current' ] =
				isset( $extract ) ? $extract->getName() : 'unknown';
		}

		return $args;
	}

	/**
	 * Bulid arguments for the testee hook
	 *
	 * @param InvokeSubpage $invoke how to get the subpage
	 * @param \Title $title header information
	 * @param ExtractStatus $extract how to extract the status
	 * @return table containing the arguments
	 */
	public static function buildTesteeArgs(
		InvokeSubpage $invoke,
		\Title $title,
		ExtractStatus $extract
	) {
		$args = [];

		// collect args
		$args[ 'page-type' ] = 'normal';
		$args[ 'subpage-message' ] = $invoke->getSubpagePrefixedText( $title );
		if ( !$invoke->getInvoke( $title )->isDisabled() ) {
			$args[ 'status-current' ] =
				isset( $extract ) ? $extract->getName() : 'unknown';
		}

		return $args;
	}

	/**
	 * Check page and return a descriptive argument set
	 *
	 * @param \Title $title header information
	 * @return table containing the arguments
	 */
	public static function checkPageType(
		\Title $title
	) {
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
							// collect args for the hook
							$args = self::buildTesterArgs( $baseInvokeStrategy, $baseTitle,
								self::getFinalStrategy( $baseInvokeStrategy, $baseTitle ) );

							return $args;
						}
					}
				}
			}
		}

		// try to find a subpage to invoke
		$invokeStrategy = InvokeSubpageStrategies::getInstance()->find( $title );
		if ( $invokeStrategy === null ) {
			return null;
		}

		// collect args for the hook
		$args = self::buildTesterArgs( $invokeStrategy, $title,
			self::getFinalStrategy( $invokeStrategy, $title ) );

		return $args;
	}

	/**
	 * Page indicator for module with pickle tests
	 *
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

		// figure out what kind of page this is
		$args = self::checkPageType( $title );
		if ( $args === null ) {
			return true;
		}

		// log our decision about what kind of page this is
		LoggerFactory::getInstance( 'Pickle' )->debug( 'Current status: {text}', [
			'text' => array_key_exists( 'status-current', $args )
				? $args[ 'status-current' ]
				: 'no current status',
			'title' => $title->getFullText(),
			'method' => __METHOD__
		] );

		// inject a help view if it is the special tester page
		if ( $args['page-type'] === 'test' ) {
			HelpView::build();
		}

		// keep status if testee page
		if ( $args['page-type'] === 'normal' && isset( $args[ 'status-current' ] ) ) {
			// keep the current page props for later
			$pageProps = \PageProps::getInstance()->getProperties( $title, 'pickle-status' );
			$parserOutput->setProperty( 'pickle-status', serialize( $args[ 'status-current' ] ) );
			// extend the args
			$args[ 'status-previous' ] =
				isset( $pageProps[$title->getArticleId()] ) ? $pageProps[$title->getArticleId()] : '';
		}

		// run registered callbacks to create gadgets
		// @todo Seems like the callback is setup wrong somehow…
		$callbacks = [
			'test' => 'SpecTesterGadgets',
			'normal' => 'SpecTesteeGadgets'
		];
		$callback = $callbacks[$args['page-type']];
		if ( isset( $callback ) ) {
			\Hooks::run( $callback, [ $title, $parserOutput, $args ] );
		}

		return true;
	}

	/**
	 * Render the pickle
	 * This is the function that evaluate {{#pickle:}} and stringifies the result.
	 *
	 * @param any $parser the object that triggered the call
	 * @param string $text for page name
	 * @return string
	 */
	public static function renderPickle(
		$parser,
		$text
	) {
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

							// @todo fix comment, outcome is not what comment says
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

		// @todo check if $invokeStrategy is disabled
		$statusStrategy = self::getFinalStrategy( $invokeStrategy, $title );
		return $title->getPrefixedText();
	}

	/**
	 * Setup for the parser
	 * @param any &$parser the place to inject the new function
	 */
	public static function onParserSetup(
		&$parser
	) {
		$parser->setFunctionHook( 'pickle', [ __CLASS__, 'Pickle\\Hooks::renderPickle' ] );
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
	public static function onRegisterScribuntoLibraries(
		$engine,
		array &$extraLibraries
	) {
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
