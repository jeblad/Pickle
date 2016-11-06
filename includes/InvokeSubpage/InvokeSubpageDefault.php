<?php

namespace Spec;

use \Spec\IInvokeSubpage;

/**
 * Concrete strategy to invoke subpage
 * Encapsulates a default invoke subpage as a strategy. The default invoke subpage is used when
 * no other matching entry can be found.
 *
 * @ingroup Extensions
 */
class InvokeSubpageDefault implements IInvokeSubpage {

	protected $opts;

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
	 * @see \Spec\IInvokeSubpage::checkType()
	 */
	public function checkType( \Title &$title ) {
		return true;
	}

	/**
	 * @see \Spec\IInvokeSubpage::checkSubpageType()
	 */
	public function checkSubpageType( \Title &$title, $type = null ) {
		return true;
	}

	/**
	 * @see \Spec\IInvokeSubpage::getInvoke()
	 */
	public function getInvoke( \Title &$title ) {
		$subpage = $this->getSubpageBaseText( $title );
		return wfMessage( 'spec-default-invoke', $subpage->plain() );
	}

	/**
	 * @see \Spec\IInvokeSubpage::getSubpageText()
	 */
	public function getSubpagePrefixedText( \Title &$title ) {
		$text = $title->getPrefixedText();
		return wfMessage( 'spec-default-subpage', $text );
	}

	/**
	 * @see \Spec\IInvokeSubpage::getSubpageBaseText()
	 */
	public function getSubpageBaseText( \Title &$title ) {
		$baseText = $title->getBaseText();
		return wfMessage( 'spec-default-subpage', $baseText );
	}

	/**
	 * @see \Spec\IInvokeSubpage::getSubpageTitle()
	 */
	public function getSubpageTitle( \Title &$title ) {
		return \Title::newFromText( $this->getSubpagePrefixedText( $title )->plain() );
	}

	/**
	 * @see \Spec\IInvokeSubpage::getTesterQuestion()
	 */
	public function getTesterQuestion( \Title &$title ) {
		return $this->opts['testerQuestion'];
	}

	/**
	 * @see \Spec\IInvokeSubpage::getTesteeQuestion()
	 */
	public function getTesteeQuestion( \Title &$title ) {
		$prefixedText = $this->getSubpagePrefixedText( $title );
		return sprintf( $this->opts['testeeQuestion'], $prefixedText->plain() );
	}

}
