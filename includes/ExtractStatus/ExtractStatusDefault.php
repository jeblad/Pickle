<?php

namespace Pickle;

/**
 * Concrete strategy to extract stratus
 * Encapsulates a default extract status as a strategy. The default extract strategy is used when
 * no other matching entry can be found.
 *
 * @ingroup Extensions
 */
class ExtractStatusDefault extends ExtractStatus {

	/**
	 * @param array $opts structure from extension setup
	 */
	public function __construct( array $opts ) {
		$this->opts = array_merge( [ 'name' => 'unknown' ], $opts );
	}

	/**
	 * @see \Pickle\ExtractStatus::checkState()
	 * @param string $str heystack
	 * @return number|bool
	 */
	public function checkState( $str ) {
		return true;
	}

}
