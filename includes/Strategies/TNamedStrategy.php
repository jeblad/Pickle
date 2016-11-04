<?php

namespace Spec;

/**
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
