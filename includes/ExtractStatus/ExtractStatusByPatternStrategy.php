<?php

namespace Spec;

use \Spec\IExtractStatusStrategy;

/**
 * Identify final test state from a set of specs as seen from a message
 */
class ExtractStatusByPatternStrategy implements IExtractStatusStrategy {

	protected $opts;

	/**
	 * @param array structure from extension setup
	 */
	public function __construct( array $opts ) {
		$this->opts = array_merge( [ 'name' => '', 'pattern' => '/^$/' ], $opts );
	}

	/**
	 * @see \Spec\IExtractStatusStrategy::checkState()
	 */
	public function checkState( $str ) {
		return preg_match( $this->opts['pattern'], $str );
	}

	 /**
	 * @see \Spec\IExtractStatusStrategy::getName()
	 */
	public function getName() {
		return $this->opts['name'];
	}

}
