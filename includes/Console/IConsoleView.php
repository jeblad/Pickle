<?php

namespace Spec;

/**
 * Builder for the view
 *
 * @ingroup Extensions
 */
interface IConsoleView {

	/**
	 * Build the view
	 * This isn't really part of a normal MVC design pattern, it will only build a minimal view.
	 *
	 * @return string representation of the html code
	 */
	public static function build( \EditPage &$editor, \OutputPage $output );
}
