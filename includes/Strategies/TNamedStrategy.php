<?php

namespace Spec;

/**
 *
 * @ingroup Extensions
 * @group Spec
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
