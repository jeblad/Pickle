<?php

namespace Spec;

/**
 * Concrete strategy for categories
 * Encapsulates a default category as an adapter. The default category is used when no other
 * matching entry can be found.
 *
 * @ingroup Extensions
 *
 * @license GNU GPL v2+
 * @author John Erling Blad
 */
class CategoryDefault extends CategoryBase {

	/**
	 * @param array structure from extension setup
	 */
	public function __construct( array $opts ) {
		$this->opts = array_merge( [], $opts, [ 'name' => 'unknown' ] );
	}
}
