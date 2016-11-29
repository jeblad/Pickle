<?php

namespace Spec;

/**
 * Invoke subpage interface
 * Encapsulates the invoke subpage as a strategy.
 * Identifies the subpage to invoke by message from a given title.
 *
 * @ingroup Extensions
 */
abstract class AInvokeSubpage {

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
	 * @param Title $title
	 * @return boolean
	 */
	abstract public function checkType( \Title &$title );

	/**
	 * Checks if the subpage title has the strategys stored type
	 *
	 * @param Title $title
	 * @return boolean
	 */
	abstract public function checkSubpageType( \Title &$title );

	/**
	 * Get the invoke
	 * It is parsed as wikitext, and will most likely contain an invoke call.
	 *
	 * @param string the base path
	 * @return Message
	 */
	abstract public function getInvoke( \Title &$title );

	/**
	 * Get the SubpagePrefixedText
	 * It is parsed as plain text, and should be a safe message.
	 *
	 * @return Message
	 */
	abstract public function getSubpagePrefixedText( \Title &$title );

	/**
	 * Get the SubpageBaseText
	 * It is parsed as plain text, and should be a safe message.
	 *
	 * @return Message
	 */
	abstract public function getSubpageBaseText( \Title &$title );

	/**
	 * Get the SubpageTitle
	 * The prefixed text is interpreted as the text for a title.
	 *
	 * @return Title
	 */
	abstract public function getSubpageTitle( \Title &$title );

	/**
	 * Get the question part of the console call for the tester
	 *
	 * @param \Title title to use while constructing the call (not in use)
	 * @return simplexml_load_string
	 */
	abstract public function getTesterQuestion( \Title &$title );

	/**
	 * Get the question part of the console call for the testee
	 *
	 * @param \Title title to use while constructing the call (not in use)
	 * @return simplexml_load_string
	 */
	abstract public function getTesteeQuestion( \Title &$title );
}
