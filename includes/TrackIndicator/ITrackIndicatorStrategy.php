<?php

namespace Spec;

/**
 * Track indicator strategy
 */
interface ITrackIndicatorStrategy {

	/**
	 * Add a new track indicator
	 *
	 * @param \Title target for the indicator
	 * @param \OutputPage output page where the indicator should be put
	 *
	 * @return Message
	 */
	public function addIndicator( \Title $title = null, \OutputPage &$out );
}
