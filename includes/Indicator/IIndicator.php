<?php

namespace Spec;

/**
 * Track indicator strategy
 */
interface IIndicator {

	/**
	 * Add a new track indicator
	 *
	 * @param \Title target for the indicator
	 * @param \ParserOutput where the indicator should be added
	 *
	 * @return Message
	 */
	public function addIndicator( \Title $title = null, \ParserOutput &$parserOutput );
}
