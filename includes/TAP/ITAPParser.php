<?php

namespace Spec;

/**
 * Squash TAP into an overall result
 *
 * @ingroup Extensions
 */
interface ITAPParser {

	/**
	 * Checks if the text is accoring to a given version
	 *
	 * @param string result from the evaluation
	 * @return boolean
	 */
	public function checkValid( $str );

	/**
	 * Get the parsed form
	 * This isn't really a parser, it just squashes the string into submission.
	 *
	 * @param string result from the evaluation
	 * @return string
	 */
	public function parse( $str );
}
