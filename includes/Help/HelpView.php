<?php

namespace Pickle;

/**
 * Concrete help view
 * This is an adapter, and will keep a reference to the OutputPage. If the newly built adapter
 * isn't keept it will be garbage collected.
 *
 * @ingroup Extensions
 */
class HelpView {

	protected $out;

	/**
	 * @param \OutputPage $out target
	 */
	public function __construct( \OutputPage $out ) {
		$this->out = $out;
	}

	/**
	 * Build the help view
	 * This isn't really part of a normal MVC design pattern, it will only build a minimal view.
	 *
	 * @param \OutputPage|null $output target (optional)
	 * @return \Pickle\HelpView
	 */
	public static function build( \OutputPage $output = null ) {
		global $wgOut;

		$out = $output ? $output : $wgOut;

		$out->addHelpLink( '//mediawiki.org/wiki/Special:MyLanguage/Help:Pickle', true );

		return new HelpView( $out );
	}

}
