<?php

namespace Spec;

/**
 * Indicator link according to an identified result
 */
interface IInvokeSubpageStrategy {

	/**
	 * Checks if the title has the strategys stored type
	 *
	 * @param Title $title
	 * @return boolean
	 */
	public function checkType( \Title &$title );

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
}
