<?php

namespace Spec;

/**
 * Track category base strategy
 * This class is abstract as it should not be instantiated on its own.
 */
abstract class TrackCategoryBaseStrategy implements ITrackCategoryStrategy {

	use TNamedStrategy;

	/**
	 * Get the name
	 *
	 * @return string
	 */
	public function getKey() {
		return 'spec-tracking-category-' . $this->opts['name'];
	}

	/**
	 * @see \Spec\ITrackCategoryStrategy::addCategorization()
	 */
	public function addCategorization( \Title $title, \ParserOutput $parserOutput ) {

		return $parserOutput->addTrackingCategory( $this->getKey(), $title );
	}
}
