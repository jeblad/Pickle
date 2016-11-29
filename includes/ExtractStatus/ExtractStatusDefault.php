<?php

namespace Spec;

use \Spec\AExtractStatus;

/**
 * Concrete strategy to extract stratus
 * Encapsulates a default extract status as a strategy. The default extract strategy is used when
 * no other matching entry can be found.
 *
 * @ingroup Extensions
 */
class ExtractStatusDefault extends AExtractStatus {

	/**
	 * @param array structure from extension setup
	 */
	public function __construct( array $opts ) {
		$this->opts = array_merge( [], $opts );
	}

	/**
	 * @see \Spec\AExtractStatus::checkState()
	 */
	public function checkState( $str ) {
		return 1;
	}

	 /**
	 * @see \Spec\AExtractStatus::getName()
	 */
	public function getName() {
		return 'unknown';
	}

}
