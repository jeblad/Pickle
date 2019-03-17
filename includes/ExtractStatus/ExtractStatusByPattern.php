<?php

namespace Pickle;

/**
 * Concrete strategy to extract status
 * Encapsulates an extract status as a strategy. This extract status is used when a matching
 * entry can be found.
 * Identify final test state from a set of specs as seen from a message.
 *
 * @ingroup Extensions
 */
class ExtractStatusByPattern extends ExtractStatus {

	/**
	 * @param array $opts structure from extension setup
	 */
	public function __construct( array $opts ) {
		$this->opts = array_merge( [ 'name' => 'none', 'pattern' => '/^$/' ], $opts );
	}

	/**
	 * @see \Pickle\ExtractStatus::checkState()
	 * @param string $str heystack
	 * @return number|bool
	 */
	public function checkState( $str ) {
		$match = preg_match( $this->opts['pattern'], $str );
		return is_numeric( $match ) ? ( $match > 0 ) : $match;
	}

}
