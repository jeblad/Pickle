<?php

namespace Pickle;

/**
 *
 * @ingroup Extensions
 */
trait TNamedStrategy {

	/**
	 * Get the name
	 *
	 * @return string
	 */
	public function getName() {
		return $this->opts['name'];
	}

}
