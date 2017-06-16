<?php

namespace Pickle;

/**
 * Category base
 * Encapsulates the abstract base class category as an adapter.
 *
 * @ingroup Extensions
 */
class Category {

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
		return 'pickle-tracking-category-' . $this->opts['key'];
	}

	/**
	 * Add a new track category
	 *
	 * @param \Title $title target of the categorization
	 * @param \ParserOutput $parserOutput parser resoult from the parsing process
	 *
	 * @return Message
	 */
	public function addCategorization( \Title $title, \ParserOutput $parserOutput ) {
		return $parserOutput->addTrackingCategory( $this->getKey(), $title );
	}
}
