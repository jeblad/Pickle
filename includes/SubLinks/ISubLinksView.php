<?php

namespace Pickle;

/**
 * Builder for the view
 *
 * @ingroup Extensions
 */
interface ISubLinksView {

	/**
	 * Make a link to the special log page
	 *
	 * @param \Title $title link destination
	 * @param any|null $lang representing the language
	 * @return Html|null
	 */
	public static function makeLink( \Title $title, $lang = null );
}
