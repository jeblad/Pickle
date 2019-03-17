<?php

namespace Pickle;

use MediaWiki\Logger\LoggerFactory;

/**
 * Indicator base
 * Encapsulates the abstract base class indicator as an adapter.
 *
 * @ingroup Extensions
 */
abstract class Indicator {

	use TNamedStrategy;

	protected $opts;

	/**
	 * Clone the opts
	 *
	 * @return array
	 */
	public function cloneOpts() {
		return array_merge( [], $this->opts );
	}

	/**
	 * Make a page status indicator link given status and url
	 *
	 * @param string $url to the internal or external page
	 * @param string|null $lang representing the language (optional)
	 * @return Html|null
	 */
	public function makeLink( $url, $lang = null ) {
		// Get the message containing the text to use for the link
		// @message pickle-test-text-good
		// @message pickle-test-text-fail
		// @message pickle-test-text-skip-good
		// @message pickle-test-text-skip-fail
		// @message pickle-test-text-todo-good
		// @message pickle-test-text-todo-fail
		// @message pickle-test-text-missing
		// @message pickle-test-text-unknown
		$msg = wfMessage( $this->getMessageKey() );
		$msg = $lang === null ? $msg->inContentLanguage() : $msg->inLanguage( $lang );
		if ( $msg->isDisabled() ) {
			LoggerFactory::getInstance( 'Pickle' )->debug( 'Found disabled message: {key}', [
				'key' => $this->getMessageKey(),
				'method' => __METHOD__
			] );
			return null;
		}

		// Build a link for the page status indicator
		$elem = \Html::rawElement(
			'a',
			[
				'href' => $url,
				'target' => '_blank',
				'class' => [ $this->getClassKey(), $this->getKey(), $this->getIcon() ]
			],
			$msg->parse()
		);

		return $elem;
	}

	/**
	 * Make a page status indicator note given status
	 *
	 * @param string|null $lang representing the language (optional)
	 * @return Html|null
	 */
	public function makeNote( $lang = null ) {
		// Get the message containing the text to use for the link
		// @message pickle-test-text-good
		// @message pickle-test-text-fail
		// @message pickle-test-text-skip-good
		// @message pickle-test-text-skip-fail
		// @message pickle-test-text-todo-good
		// @message pickle-test-text-todo-fail
		// @message pickle-test-text-missing
		// @message pickle-test-text-unknown
		$msg = wfMessage( $this->getMessageKey() );
		$msg = $lang === null ? $msg->inContentLanguage() : $msg->inLanguage( $lang );
		if ( $msg->isDisabled() ) {
			LoggerFactory::getInstance( 'Pickle' )->debug( 'Found disabled message: {key}', [
				'key' => $this->getMessageKey(),
				'method' => __METHOD__
			] );
			return null;
		}

		// Build a link for the page status indicator
		$elem = \Html::rawElement(
			'span',
			[
				'class' => [ $this->getClassKey(), $this->getKey(), $this->getIcon() ]
			],
			$msg->parse()
		);

		return $elem;
	}

	/**
	 * Get the key
	 *
	 * @return string
	 */
	public function getKey() {
		return $this->getClassKey() . '-' . $this->opts['name'];
	}

	/**
	 * Get the icon
	 *
	 * @return string
	 */
	public function getIcon() {
		return 'mw-speclink-icon-' . $this->opts['icon'];
	}

	/**
	 * Get the messagekey
	 *
	 * @return string
	 */
	public function getMessageKey() {
		return 'pickle-test-text-' . $this->opts['name'];
	}

	/**
	 * Get the class key
	 *
	 * @return string
	 */
	public function getClassKey() {
		return 'mw-speclink';
	}

	/**
	 * Add a new track indicator
	 *
	 * @param \Title|null $title target for the indicator
	 * @param \ParserOutput &$parserOutput where the indicator should be added
	 * @return Message
	 */
	public function addIndicator( \Title $title = null, \ParserOutput &$parserOutput ) {
		$elem = null;

		$elem = $title ? $this->makeLink( $title->getLocalURL() ) : $this->makeNote();

		if ( $elem !== null ) {
			$parserOutput->setIndicator( $this->getClassKey(), $elem );
			$parserOutput->addModuleStyles( [ 'ext.pickle.indicator.icon' ] );
		}

		return $elem;
	}
}
