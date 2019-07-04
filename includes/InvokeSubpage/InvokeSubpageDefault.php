<?php

namespace Pickle;

/**
 * Concrete strategy to invoke subpage
 * Encapsulates a default invoke subpage as a strategy. The default invoke subpage is used when
 * no other matching entry can be found.
 *
 * @ingroup Extensions
 */
class InvokeSubpageDefault extends InvokeSubpage {

	/**
	 * @param array $opts structure from extension setup
	 */
	public function __construct( array $opts ) {
		$this->opts = array_merge(
			[
				// 'testerQuestion' => "= p.tap('vivid')",
				'testerQuestion' => "= p.tap( 'full' )",
				// 'testeeQuestion' => "= require '%s' ( p ) .tap()"
				'testeeQuestion' => "= require( '%s' ).tap( 'full' )"
			],
			$opts,
			[
				'name' => 'default',
				'type' => null
			] );
	}

	/**
	 * @see \Pickle\InvokeSubpage::checkType()
	 * @param \Title &$title to be used as source
	 * @return true
	 */
	public function checkType( \Title &$title ) {
		return true;
	}

	/**
	 * @see \Pickle\InvokeSubpage::checkSubpageType()
	 * @param \Title &$title to be used as source
	 * @param bool|null $type of content model (optional)
	 * @return true
	 */
	public function checkSubpageType( \Title &$title, $type = null ) {
		return true;
	}

	/**
	 * @see \Pickle\InvokeSubpage::getInvoke()
	 * @param \Title &$title to be used as source
	 * @return \Message
	 */
	public function getInvoke( \Title &$title ) {
		$subpage = $this->getSubpageBaseText( $title );
		return wfMessage( 'pickle-default-invoke', $subpage->plain() );
	}

	/**
	 * @see \Pickle\InvokeSubpage::getSubpageText()
	 * @param \Title &$title to be used as source
	 * @return \Message
	 */
	public function getSubpagePrefixedText( \Title &$title ) {
		$text = $title->getPrefixedText();
		return wfMessage( 'pickle-default-subpage', $text );
	}

	/**
	 * @see \Pickle\InvokeSubpage::getSubpageBaseText()
	 * @param \Title &$title to be used as source
	 * @return \Message
	 */
	public function getSubpageBaseText( \Title &$title ) {
		$baseText = $title->getBaseText();
		return wfMessage( 'pickle-default-subpage', $baseText );
	}
}
