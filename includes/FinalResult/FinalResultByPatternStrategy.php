<?php

namespace Spec;

use \Spec\IFinalResultStrategy;

/**
 * Identify final test state from a set of specs as seen from a message
 */
class FinalResultByPatternStrategy implements IFinalResultStrategy {

	/**
	 * @param array structure from extension setup
	 */
	public function __construct( array $struct ) {
		$this->struct = array_merge( [ 'name' => '', 'pattern' => '/^$/' ], $struct );
	}

	/**
	 * @see \Spec\IIdentifyStateStrategy::findState()
	 */
	public function findState( $str ) {
		return preg_match( $this->struct['pattern'], $str );
	}

	 /**
	 * @see \Spec\IIdentifyStateStrategy::getName()
	 */
	public function getName() {
		return $this->struct['name'];
	}

}
