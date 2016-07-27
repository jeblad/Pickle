<?php

namespace Spec;

/**
 * Strategies to identify message from specsbase page type
 */
class InvokeSubpageStrategies extends Strategies {

	/**
	 * Who am I
	 */
	public static function who() {
		return __CLASS__;
	}

	/**
	 * Checks if the string has any of the strategies stored patterns
	 *
	 * @see \Spec\IInvokeSubpageStrategy::findInvoke()
	 *
	 * @param Title $title
	 *
	 * @return string
	 */
	public function find( \Title $title ) {
		foreach ( $this->strategies as $strategy ) {
			if ( $strategy->checkType( $title ) ) {
				return $strategy;
			}
		}
		return null;
	}
}
