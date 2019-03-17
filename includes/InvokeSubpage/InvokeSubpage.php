<?php

namespace Pickle;

/**
 * Invoke subpage interface
 * Encapsulates the invoke subpage as a strategy.
 * Identifies the subpage to invoke by message from a given title.
 *
 * @ingroup Extensions
 */
abstract class InvokeSubpage {

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
	 * Checks if the title has the strategys stored type
	 *
	 * @param \Title &$title to be used as source
	 * @return bool
	 */
	public function checkType( \Title &$title ) {
		return false;
	}

	/**
	 * Checks if the subpage title has the strategys stored type
	 *
	 * @param \Title &$title to be used as source
	 * @param bool|null $type of content model (optional)
	 * @return bool
	 */
	public function checkSubpageType( \Title &$title, $type = null ) {
		return false;
	}

	/**
	 * Get the invoke
	 * It is parsed as wikitext, and will most likely contain an invoke call.
	 *
	 * @param \Title &$title to be used as source
	 * @return \Message
	 */
	public function getInvoke( \Title &$title ) {
		return null;
	}

	/**
	 * Get the SubpagePrefixedText
	 * It is parsed as plain text, and should be a safe message.
	 *
	 * @param \Title &$title to be used as source
	 * @return \Message
	 */
	public function getSubpagePrefixedText( \Title &$title ) {
		return null;
	}

	/**
	 * Get the SubpageBaseText
	 * It is parsed as plain text, and should be a safe message.
	 *
	 * @param \Title &$title to be used as source
	 * @return \Message
	 */
	public function getSubpageBaseText( \Title &$title ) {
		return null;
	}

	/**
	 * Get the SubpageTitle
	 * The prefixed text is interpreted as the text for a title.
	 *
	 * @param \Title &$title to be used as source
	 * @return \Title
	 */
	public function getSubpageTitle( \Title &$title ) {
		return \Title::newFromText( $this->getSubpagePrefixedText( $title )->plain() );
	}

	/**
	 * Get the question part of the console call for the tester
	 *
	 * @param \Title &$title to used as source (not in use)
	 * @return simplexml_load_string
	 */
	public function getTesterQuestion( \Title &$title ) {
		return $this->opts['testerQuestion'];
	}

	/**
	 * Get the question part of the console call for the testee
	 *
	 * @param \Title &$title to used as source (not in use)
	 * @return simplexml_load_string
	 */
	public function getTesteeQuestion( \Title &$title ) {
		$prefixedText = $this->getSubpagePrefixedText( $title );
		return sprintf( $this->opts['testeeQuestion'], $prefixedText->plain() );
	}
}
