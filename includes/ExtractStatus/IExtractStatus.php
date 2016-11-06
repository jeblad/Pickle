<?php

namespace Spec;

/**
 * Extract status interface
 * Encapsulates the extracted status as a strategy.
 * Identifies the final test state from a set of specs as seen from a message.
 *
 * @ingroup Extensions
 */
interface IExtractStatus {

	/**
	 * Checks if the string has the strategys stored pattern
	 *
	 * @param string $str
	 * @return boolean
	 */
	public function checkState( $str );

	/**
	 * Get member name
	 *
	 * @return string
	 */
	public function getName();

}
