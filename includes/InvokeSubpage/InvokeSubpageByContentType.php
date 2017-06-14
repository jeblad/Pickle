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
	 * @param array $opts structure from extension setup
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
	 * @param \Title &$title to be used as source
	 * @return boolean
	 */
	public function checkType( \Title &$title ) {
		return $title->exists() && $title->getContentModel() === $this->opts['type'];
	}

	/**
	 * @see \Pickle\AInvokeSubpage::checkSubpageType()
	 * @param \Title &$title to be used as source
	 * @param boolean $type of content model (optional)
	 * @return boolean
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
	 * @param \Title &$title to be used as source
	 * @return \Message
	 */
	public function getInvoke( \Title &$title ) {
		$subpage = $this->getSubpageBaseText( $title );
		// @message pickle-spectype-invoke
		return wfMessage( 'pickle-' . $this->opts['name'] . '-invoke', $subpage->plain() );
	}

	/**
	 * @see \Pickle\AInvokeSubpage::getSubpagePrefixedText()
	 * @param \Title &$title to be used as source
	 * @return \Message
	 */
	public function getSubpagePrefixedText( \Title &$title ) {
		$text = $title->getPrefixedText();
		// @message pickle-spectype-subpage
		return wfMessage( 'pickle-' . $this->opts['name'] . '-subpage', $text );
	}

	/**
	 * @see \Pickle\AInvokeSubpage::getSubpageBaseText()
	 * @param \Title &$title to be used as source
	 * @return \Message
	 */
	public function getSubpageBaseText( \Title &$title ) {
		$baseText = $title->getBaseText();
		// @message pickle-spectype-subpage
		return wfMessage( 'pickle-' . $this->opts['name'] . '-subpage', $baseText );
	}

	/**
	 * @see \Pickle\AInvokeSubpage::getSubpageTitle()
	 * @param \Title &$title to be used as source
	 * @return \Title
	 */
	public function getSubpageTitle( \Title &$title ) {
		return \Title::newFromText( $this->getSubpagePrefixedText( $title )->plain() );
	}

	/**
	 * @see \Pickle\AInvokeSubpage::getTesterQuestion()
	 * @param \Title &$title to be used as source
	 * @return simplexml_load_string
	 */
	public function getTesterQuestion( \Title &$title ) {
		return $this->opts['testerQuestion'];
	}

	/**
	 * @see \Pickle\AInvokeSubpage::getTesteeQuestion()
	 * @param \Title &$title to be used as source
	 * @return simplexml_load_string
	 */
	public function getTesteeQuestion( \Title &$title ) {
		$prefixedText = $this->getSubpagePrefixedText( $title );
		return sprintf( $this->opts['testeeQuestion'], $prefixedText->plain() );
	}

}
