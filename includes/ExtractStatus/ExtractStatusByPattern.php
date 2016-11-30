<?php

namespace Spec;

use \Spec\AExtractStatus;

/**
 * Concrete strategy to extract status
 * Encapsulates an extract status as a strategy. This extract status is used when a matching
 * entry can be found.
 * Identify final test state from a set of specs as seen from a message.
 *
 * @ingroup Extensions
 */
class ExtractStatusByPattern extends AExtractStatus {

	/**
	 * @param array structure from extension setup
	 */
	public function __construct( array $opts ) {
		$this->opts = array_merge( [ 'name' => 'none', 'pattern' => '/^$/' ], $opts );
	}

	/**
	 * @see \Spec\AExtractStatus::checkState()
	 */
	public function checkState( $str ) {
		return preg_match( $this->opts['pattern'], $str );
	}

}
