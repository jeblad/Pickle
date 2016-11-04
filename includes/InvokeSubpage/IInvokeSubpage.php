<?php

namespace Spec;

/**
 * Indicator link according to an identified result
 */
interface IInvokeSubpage {

	/**
	 * Checks if the title has the strategys stored type
	 *
	 * @param Title $title
	 * @return boolean
	 */
	public function checkType( \Title &$title );

	/**
	 * Checks if the subpage title has the strategys stored type
	 *
	 * @param Title $title
	 * @return boolean
	 */
	public function checkSubpageType( \Title &$title );

	/**
	 * Get the invoke
	 * It is parsed as wikitext, and will most likely contain an invoke call.
	 *
	 * @param string the base path
	 * @return Message
	 */
	public function getInvoke( \Title &$title );

	/**
	 * Get the SubpagePrefixedText
	 * It is parsed as plain text, and should be a safe message.
	 *
	 * @return Message
	 */
	public function getSubpagePrefixedText( \Title &$title );

	/**
	 * Get the SubpageBaseText
	 * It is parsed as plain text, and should be a safe message.
	 *
	 * @return Message
	 */
	public function getSubpageBaseText( \Title &$title );

	/**
	 * Get the SubpageTitle
	 * The prefixed text is interpreted as the text for a title.
	 *
	 * @return Title
	 */
	public function getSubpageTitle( \Title &$title );

	/**
	 * Get the question part of the console call for the tester
	 *
	 * @param \Title title to use while constructing the call (not in use)
	 * @return simplexml_load_string
	 */
	public function getTesterQuestion( \Title &$title );

	/**
	 * Get the question part of the console call for the testee
	 *
	 * @param \Title title to use while constructing the call (not in use)
	 * @return simplexml_load_string
	 */
	public function getTesteeQuestion( \Title &$title );
}
