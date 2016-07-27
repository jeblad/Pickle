<?php

namespace Spec;

use \Spec\IExtractStatusStrategy;

/**
 * Default final result from a set of specs as seen from a message
 */
class ExtractStatusDefaultStrategy implements IExtractStatusStrategy {

	/**
	 * @param array structure from extension setup
	 */
	public function __construct( array $opts ) {
		// empty
	}

	/**
	 * @see \Spec\IExtractStatusStrategy::checkState()
	 */
	public function checkState( $str ) {
		return 1;
	}

	 /**
	 * @see \Spec\IExtractStatusStrategy::getName()
	 */
	public function getName() {
		return 'unknown';
	}

}
