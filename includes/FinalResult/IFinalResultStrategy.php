<?php

namespace Spec;

/**
 * Identify final test state from a set of specs as seen from a message
 */
interface IFinalResultStrategy {

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
