<?php

namespace Spec;

/**
 * Builder for the view
 *
 * @ingroup Extensions
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
