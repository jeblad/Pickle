<?php

namespace Spec;

use \Spec\IExtractStatus;

/**
 * Identify final test state from a set of specs as seen from a message
 */
class ExtractStatusByPattern implements IExtractStatus {

	protected $opts;

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
