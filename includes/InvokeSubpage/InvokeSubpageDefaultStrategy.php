<?php

namespace Spec;

use \Spec\IInvokeSubpageStrategy;

/**
 * Identify InvokeSubpage and find a message
 */
class InvokeSubpageDefaultStrategy implements IInvokeSubpageStrategy {

	/**
	 * @param array structure from extension setup
	 */
	public function __construct( array $opts ) {
		// empty
	}

	/**
	 * @see \Spec\IInvokeSubpageStrategy::checkType()
	 */
	public function checkType( \Title &$title ) {
		return true;
	}

	/**
	 * @see \Spec\IInvokeSubpageStrategy::getInvoke()
	 */
	public function getInvoke( \Title &$title ) {
		$subpage = $this->getSubpageBaseText( $title );
		return wfMessage( 'spec-default-invoke', $subpage->plain() );
	}

	/**
	 * @see \Spec\IInvokeSubpageStrategy::getSubpageText()
	 */
	public function getSubpagePrefixedText( \Title &$title ) {
		$text = $title->getPrefixedText();
		return wfMessage( 'spec-default-subpage', $text );
	}

	/**
	 * @see \Spec\IInvokeSubpageStrategy::getSubpageBaseText()
	 */
	public function getSubpageBaseText( \Title &$title ) {
		$baseText = $title->getBaseText();
		return wfMessage( 'spec-default-subpage', $baseText );
	}

}
