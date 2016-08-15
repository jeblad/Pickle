<?php

namespace Spec;

/**
 * Builder for the view
 */
interface ISubLinksView {

	/**
	 * Make a link to the special log page
	 *
	 * @param string $status representing the state
	 * @return Html|null
	 */
	public static function makeLink( $title, $lang = null );
}
