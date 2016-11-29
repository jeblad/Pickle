<?php

namespace Spec;

use \Spec\AInvokeSubpage;

/**
 * Concrete strategy to invoke subpage
 * Encapsulates an invoke subpage as a strategy. This invoke subpage is used when a matching
 * entry can be found.
 * Identifies the subpage to invoke by message from a given title.
 *
 * @ingroup Extensions
 */
class InvokeSubpageByContentType extends AInvokeSubpage {

	// protected $opts;

	/**
	 * @param array structure from extension setup
	 */
	public function __construct( array $opts ) {
		$this->opts = array_merge(
			[
				'name' => '',
				'type' => 'Scribunto',
				'testerQuestion' => "= p ( p ) :tap()",
				'testeeQuestion' => "= require '%s' ( p ) :tap()"
			],
			$opts );
	}

	/**
	 * @see \Spec\AInvokeSubpage::checkType()
	 */
	public function checkType( \Title &$title ) {
		return $title->exists() && $title->getContentModel() === $this->opts['type'];
	}

	/**
	 * @see \Spec\AInvokeSubpage::checkSubpageType()
	 */
	public function checkSubpageType( \Title &$title, $type = null ) {
		// this will be cached
		$subpage = \Title::newFromText( $this->getSubpagePrefixedText( $title )->plain() );
		return ( $type === null
			? ( $subpage->exists() && $subpage->getContentModel() === $this->opts['type'] )
			: ( $subpage->getContentModel() === $type ) );
	}

	/**
	 * @see \Spec\AInvokeSubpage::getInvoke()
	 */
	public function getInvoke( \Title &$title ) {
		$subpage = $this->getSubpageBaseText( $title );
		// @message spec-spectype-invoke
		return wfMessage( 'spec-' . $this->opts['name'] . '-invoke', $subpage->plain() );
	}

	/**
	 * @see \Spec\AInvokeSubpage::getSubpagePrefixedText()
	 */
	public function getSubpagePrefixedText( \Title &$title ) {
		$text = $title->getPrefixedText();
		// @message spec-spectype-subpage
		return wfMessage( 'spec-' . $this->opts['name'] . '-subpage', $text );
	}

	/**
	 * @see \Spec\AInvokeSubpage::getSubpageBaseText()
	 */
	public function getSubpageBaseText( \Title &$title ) {
		$baseText = $title->getBaseText();
		// @message spec-spectype-subpage
		return wfMessage( 'spec-' . $this->opts['name'] . '-subpage', $baseText );
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
