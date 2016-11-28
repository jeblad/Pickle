<?php

namespace Spec;

use \Spec\IExtractStatus;

/**
 * Concrete strategy to extract status
 * Encapsulates an extract status as a strategy. This extract status is used when a matching
 * entry can be found.
 * Identify final test state from a set of specs as seen from a message.
 *
 * @ingroup Extensions
 */
class ExtractStatusByPattern implements IExtractStatus {

	// protected $opts;

	/**
	 * @param array structure from extension setup
	 */
	public function __construct( array $opts ) {
		$this->opts = array_merge( [ 'name' => '', 'pattern' => '/^$/' ], $opts );
	}

	/**
	 * @see \Spec\IExtractStatus::checkState()
	 */
	public function checkState( $str ) {
		return preg_match( $this->opts['pattern'], $str );
	}

	 /**
	 * @see \Spec\IExtractStatus::getName()
	 */
	public function getName() {
		return $this->opts['name'];
	}

}
