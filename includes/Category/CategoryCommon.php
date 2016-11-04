<?php

namespace Spec;

/**
 * Concrete strategy for categories
 * Encapsulates a common category as an adapter. The common category is used when recognized
 * entries are found.
 *
 * @ingroup Extensions
 *
 * @license GNU GPL v2+
 * @author John Erling Blad
 */
class CategoryCommon extends CategoryBase {

	/**
	 * @param array structure from extension setup
	 */
	public function __construct( array $opts ) {
		$this->opts = array_merge( [ 'name' => '' ], $opts );
	}
}
