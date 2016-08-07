<?php

namespace Spec;

/**
 * Strategies to identify message from specsbase page type
 *
 * @ingroup Extensions
 */
class InvokeSubpageStrategies extends Singletons {

	/**
	 * Who am I
	 */
	public static function who() {
		return __CLASS__;
	}

	/**
	 * Configure the strategies
	 */
	public static function init() {
		global $wgSpecInvokeSubpage;

		$results = InvokeSubpageStrategies::getInstance();
		foreach ( $wgSpecInvokeSubpage as $struct ) {
			$results->register( $struct );
		}

		return true;
	}

	/**
	 * Checks if the string has any of the strategies stored patterns
	 *
	 * @param Title $title
	 *
	 * @return string
	 */
	public function find( \Title $title ) {
		if ( $this->isEmpty() ) {
			InvokeSubpageStrategies::init();
		}
		foreach ( $this->instances as $strategy ) {
			if ( $strategy->checkType( $title ) ) {
				return $strategy;
			}
		}
		return null;
	}
}
