<?php

namespace Spec;

/**
 * Category base
 * Encapsulates the abstract base class category as an adapter.
 *
 * @ingroup Extensions
 */
abstract class ACategory {

	use TNamedStrategy;

	protected $opts;

	/**
	 * Clone the opts
	 *
	 * @return array
	 */
	public function cloneOpts() {
		return array_merge( [], $this->opts );
	}

	/**
	 * Get the name
	 *
	 * @return string
	 */
	public function getKey() {
		return 'spec-tracking-category-' . $this->opts['key'];
	}

	/**
	 * Add a new track category
	 *
	 * @param \Title target of the categorization
	 * @param \ParserOutput parser resoult from the parsing process
	 *
	 * @return Message
	 */
	public function addCategorization( \Title $title, \ParserOutput $parserOutput ) {
		return $parserOutput->addTrackingCategory( $this->getKey(), $title );
	}
}
