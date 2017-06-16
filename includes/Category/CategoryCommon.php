<?php

namespace Pickle;

/**
 * Concrete strategy for categories
 * Encapsulates the common category as an adapter. The common category is used when recognized
 * entries are found.
 *
 * @ingroup Extensions
 */
class CategoryCommon extends Category {

	/**
	 * @param array $opts structure from extension setup
	 */
	public function __construct( array $opts ) {
		$this->opts = array_merge( [ 'name' => 'none', 'key' => 'unknown' ], $opts );
	}
}
