<?php

namespace Spec;

/**
 * Builder for the help view
 *
 * @ingroup Extensions
 */
interface IHelpView {

	/**
	 * Build the help view
	 * This isn't really part of a normal MVC design pattern, it will only build a minimal view.
	 *
	 * @param OutputPage $out
	 *
	 * @return \OutputPage outcome of the call
	 */
	public static function build( \OutputPage $out = null );
}
