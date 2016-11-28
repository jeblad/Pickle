<?php

namespace Spec;

/**
 * Concrete strategy for indicators
 * Encapsulates a common indicator as an adapter. The common indicator is used when recognized
 * entries are found.
 *
 * file
 * @ingroup Extensions
 */
class IndicatorCommon extends AIndicator {

	/**
	 * @param array structure from extension setup
	 */
	public function __construct( array $opts ) {
		$this->opts = array_merge( [ 'name' => '' ], $opts );
	}
}
