<?php

namespace Pickle;

/**
 * Concrete strategy for categories
 * Encapsulates a default category as an adapter. The default category is used when no other
 * matching entry can be found.
 *
 * @ingroup Extensions
 */
class CategoryDefault extends Category {

	/**
	 * @param array $opts structure from extension setup
	 */
	public function __construct( array $opts ) {
		$this->opts = array_merge( [], $opts, [ 'name' => 'unknown', 'key' => 'unknown' ] );
	}
}
