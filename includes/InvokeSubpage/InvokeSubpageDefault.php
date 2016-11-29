<?php

namespace Spec;

use \Spec\AInvokeSubpage;

/**
 * Concrete strategy to invoke subpage
 * Encapsulates a default invoke subpage as a strategy. The default invoke subpage is used when
 * no other matching entry can be found.
 *
 * @ingroup Extensions
 */
class InvokeSubpageDefault extends AInvokeSubpage {

	// protected $opts;

	/**
	 * @param array structure from extension setup
	 */
	public function __construct( array $opts ) {
		$this->opts = array_merge(
			[
				'testerQuestion' => "= p ( p ) :tap()",
				'testeeQuestion' => "= require '%s' ( p ) :tap()"
			],
			$opts,
			[
				'name' => 'default',
				'type' => null
			] );
	}

	/**
	 * @see \Spec\AInvokeSubpage::checkType()
	 */
	public function checkType( \Title &$title ) {
		return true;
	}

	/**
	 * @see \Spec\AInvokeSubpage::checkSubpageType()
	 */
	public function checkSubpageType( \Title &$title, $type = null ) {
		return true;
	}

	/**
	 * @see \Spec\AInvokeSubpage::getInvoke()
	 */
	public function getInvoke( \Title &$title ) {
		$subpage = $this->getSubpageBaseText( $title );
		return wfMessage( 'spec-default-invoke', $subpage->plain() );
	}

	/**
	 * @see \Spec\AInvokeSubpage::getSubpageText()
	 */
	public function getSubpagePrefixedText( \Title &$title ) {
		$text = $title->getPrefixedText();
		return wfMessage( 'spec-default-subpage', $text );
	}

	/**
	 * @see \Spec\AInvokeSubpage::getSubpageBaseText()
	 */
	public function getSubpageBaseText( \Title &$title ) {
		$baseText = $title->getBaseText();
		return wfMessage( 'spec-default-subpage', $baseText );
	}

	/**
	 * @see \Spec\AInvokeSubpage::getSubpageTitle()
	 */
	public function getSubpageTitle( \Title &$title ) {
		return \Title::newFromText( $this->getSubpagePrefixedText( $title )->plain() );
	}

	/**
	 * @see \Spec\AInvokeSubpage::getTesterQuestion()
	 */
	public function getTesterQuestion( \Title &$title ) {
		return $this->opts['testerQuestion'];
	}

	/**
	 * @see \Spec\AInvokeSubpage::getTesteeQuestion()
	 */
	public function getTesteeQuestion( \Title &$title ) {
		$prefixedText = $this->getSubpagePrefixedText( $title );
		return sprintf( $this->opts['testeeQuestion'], $prefixedText->plain() );
	}

}
