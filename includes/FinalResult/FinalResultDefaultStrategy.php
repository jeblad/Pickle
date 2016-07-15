<?php

namespace Spec;

use \Spec\IFinalResultStrategy;

/**
 * Default final result from a set of specs as seen from a message
 */
class FinalResultDefaultStrategy implements IFinalResultStrategy {

	/**
	 * @param array structure from extension setup
	 */
	public function __construct( array $struct ) {
		$this->struct = array_merge( [ 'name' => 'default', 'pattern' => '/^$' ], $struct );
	}

	/**
	 * @see \Spec\IFinalResultStrategy::checkState()
	 */
	public function checkState( $str ) {
		return 1;
	}

	 /**
	 * @see \Spec\IFinalResultStrategy::getName()
	 */
	public function getName() {
		return $this->struct['name'];
	}

}
