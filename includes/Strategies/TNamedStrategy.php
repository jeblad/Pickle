<?php

namespace Pickle;

/**
 *
 * @ingroup Extensions
 * @group Pickle
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
