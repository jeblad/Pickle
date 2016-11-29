<?php

namespace Spec;

/**
 * Extract status base
 * Encapsulates the extracted status as a strategy.
 * Identifies the final test state from a set of specs as seen from a message.
 *
 * @ingroup Extensions
 */
abstract class AExtractStatus {

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
	 * Checks if the string has the strategys stored pattern
	 *
	 * @param string $str
	 * @return boolean
	 */
	abstract public function checkState( $str );

	/**
	 * Get member name
	 *
	 * @return string
	 */
	abstract public function getName();

}
