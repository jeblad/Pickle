<?php

namespace Pickle;

use \Pickle\AInvokeSubpage;

/**
 * Concrete strategy to invoke subpage
 * Encapsulates an invoke subpage as a strategy. This invoke subpage is used when a matching
 * entry can be found.
 * Identifies the subpage to invoke by message from a given title.
 *
 * @ingroup Extensions
 */
class InvokeSubpageByContentType extends AInvokeSubpage {

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
	 * @see \Pickle\AInvokeSubpage::checkType()
	 */
	public function checkType( \Title &$title ) {
		return $title->exists() && $title->getContentModel() === $this->opts['type'];
	}

	/**
	 * @see \Pickle\AInvokeSubpage::checkSubpageType()
	 */
	public function checkSubpageType( \Title &$title, $type = null ) {
		// this will be cached
		$subpage = \Title::newFromText( $this->getSubpagePrefixedText( $title )->plain() );
		return ( $type === null
			? ( $subpage->exists() && $subpage->getContentModel() === $this->opts['type'] )
			: ( $subpage->getContentModel() === $type ) );
	}

	/**
	 * @see \Pickle\AInvokeSubpage::getInvoke()
	 */
	public function getInvoke( \Title &$title ) {
		$subpage = $this->getSubpageBaseText( $title );
		// @message pickle-spectype-invoke
		return wfMessage( 'pickle-' . $this->opts['name'] . '-invoke', $subpage->plain() );
	}

	/**
	 * @see \Pickle\AInvokeSubpage::getSubpagePrefixedText()
	 */
	public function getSubpagePrefixedText( \Title &$title ) {
		$text = $title->getPrefixedText();
		// @message pickle-spectype-subpage
		return wfMessage( 'pickle-' . $this->opts['name'] . '-subpage', $text );
	}

	/**
	 * @see \Pickle\AInvokeSubpage::getSubpageBaseText()
	 */
	public function getSubpageBaseText( \Title &$title ) {
		$baseText = $title->getBaseText();
		// @message pickle-spectype-subpage
		return wfMessage( 'pickle-' . $this->opts['name'] . '-subpage', $baseText );
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
