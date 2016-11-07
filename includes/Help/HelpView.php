<?php

namespace Spec;

/**
 * Concrete help view
 * This is an adapter, and will keep a reference to the OutputPage. If the newly built adapter
 * isn't keept it will be garbage collected.
 *
 * @ingroup Extensions
 */
class HelpView implements IHelpView {

	protected $out;

	/**
	 * @param \OutputPage
	 */
	public function __construct( \OutputPage $out ) {
		$this->out = $out;
	}

	/**
	 * @see \Spec\IHelpView::build()
	 */
	public static function build( \OutputPage $output = null ) {
		global $wgOut;

		$out = $output ? $output : $wgOut;

		$out->addHelpLink( '//mediawiki.org/wiki/Special:MyLanguage/Help:Spec', true );

		return new HelpView( $out );
	}

}
