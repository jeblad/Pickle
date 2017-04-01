<?php

namespace Pickle;

use \Pickle\AInvokeSubpage;

/**
 * Concrete strategy to invoke subpage
 * Encapsulates a default invoke subpage as a strategy. The default invoke subpage is used when
 * no other matching entry can be found.
 *
 * @ingroup Extensions
 */
class InvokeSubpageDefault extends AInvokeSubpage {

	/**
	 * @param array structure from extension setup
	 */
	public function __construct( array $opts ) {
		$this->opts = array_merge(
			[
				'testerQuestion' => "= p:tap('vivid')",
				'testeeQuestion' => "= require '%s' ( p ) :tap()"
			],
			$opts,
			[
				'name' => 'default',
				'type' => null
			] );
	}

	/**
	 * @see \Pickle\AInvokeSubpage::checkType()
	 */
	public function checkType( \Title &$title ) {
		return true;
	}

	/**
	 * @see \Pickle\AInvokeSubpage::checkSubpageType()
	 */
	public function checkSubpageType( \Title &$title, $type = null ) {
		return true;
	}

	/**
	 * @see \Pickle\AInvokeSubpage::getInvoke()
	 */
	public function getInvoke( \Title &$title ) {
		$subpage = $this->getSubpageBaseText( $title );
		return wfMessage( 'pickle-default-invoke', $subpage->plain() );
	}

	/**
	 * @see \Pickle\AInvokeSubpage::getSubpageText()
	 */
	public function getSubpagePrefixedText( \Title &$title ) {
		$text = $title->getPrefixedText();
		return wfMessage( 'pickle-default-subpage', $text );
	}

	/**
	 * @see \Pickle\AInvokeSubpage::getSubpageBaseText()
	 */
	public function getSubpageBaseText( \Title &$title ) {
		$baseText = $title->getBaseText();
		return wfMessage( 'pickle-default-subpage', $baseText );
	}

	/**
	 * @see \Pickle\AInvokeSubpage::getSubpageTitle()
	 */
	public function getSubpageTitle( \Title &$title ) {
		return \Title::newFromText( $this->getSubpagePrefixedText( $title )->plain() );
	}

	/**
	 * @see \Pickle\AInvokeSubpage::getTesterQuestion()
	 */
	public function getTesterQuestion( \Title &$title ) {
		return $this->opts['testerQuestion'];
	}

	/**
	 * @see \Pickle\AInvokeSubpage::getTesteeQuestion()
	 */
	public function getTesteeQuestion( \Title &$title ) {
		$prefixedText = $this->getSubpagePrefixedText( $title );
		return sprintf( $this->opts['testeeQuestion'], $prefixedText->plain() );
	}

}
