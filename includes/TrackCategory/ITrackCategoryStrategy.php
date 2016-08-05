<?php

namespace Spec;

/**
 * Track category strategy
 */
interface ITrackCategoryStrategy {

	/**
	 * Add a new track category
	 *
	 * @param \Title target of the categorization
	 * @param \ParserOutput parser resoult from the parsing process
	 *
	 * @return Message
	 */
	public function addCategorization( \Title $title, \ParserOutput $parserOutput );
}
