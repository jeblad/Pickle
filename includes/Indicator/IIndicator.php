<?php

namespace Spec;

/**
 * Indicator interface
 * Encapsulates the indicator as an adapter.
 *
 * @ingroup Extensions
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
