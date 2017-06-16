<?php

namespace Pickle;

/**
 * Concrete strategy for indicators
 * Encapsulates a default indicator as an adapter. The default indicator is used when no other
 * matching entry can be found.
 *
 * @ingroup Extensions
 */
class IndicatorDefault extends Indicator {

	/**
	 * @param array $opts structure from extension setup
	 */
	public function __construct( array $opts ) {
		$this->opts = array_merge( [], $opts, [ 'name' => 'unknown' ] );
	}
}
