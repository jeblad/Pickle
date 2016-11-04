<?php

namespace Spec;

use \Spec\IExtractStatus;

/**
 * Default final result from a set of specs as seen from a message
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
