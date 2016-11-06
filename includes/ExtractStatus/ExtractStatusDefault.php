<?php

namespace Spec;

use \Spec\IExtractStatus;

/**
 * Concrete strategy to extract stratus
 * Encapsulates a default extract status as a strategy. The default extract strategy is used when
 * no other matching entry can be found.
 *
 * @ingroup Extensions
 */
class ExtractStatusDefault implements IExtractStatus {

	/**
	 * @param array structure from extension setup
	 */
	public function __construct( array $opts ) {
		// empty
	}

	/**
	 * @see \Spec\IExtractStatus::checkState()
	 */
	public function checkState( $str ) {
		return 1;
	}

	 /**
	 * @see \Spec\IExtractStatus::getName()
	 */
	public function getName() {
		return 'unknown';
	}

}
