<?php

namespace Pickle;

/**
 * Concrete strategy to invoke subpage
 * Encapsulates an invoke subpage as a strategy. This invoke subpage is used when a matching
 * entry can be found.
 * Identifies the subpage to invoke by message from a given title.
 *
 * @ingroup Extensions
 */
class InvokeSubpageByContentType extends InvokeSubpage {

	/**
	 * @param array $opts structure from extension setup
	 */
	public function __construct( array $opts ) {
		$this->opts = array_merge(
			[
				'name' => '',
				'type' => 'Scribunto',
				// 'testerQuestion' => "= p ( p ) .tap()",
				'testerQuestion' => "= p.tap( 'full' )",
				//'testeeQuestion' => "= require '%s' ( p ) .tap()",
				'testeeQuestion' => "= require( '%s' ).tap( 'full' )"
			],
			$opts );
	}

	/**
	 * @see \Pickle\InvokeSubpage::checkType()
	 * @param \Title &$title to be used as source
	 * @return bool
	 */
	public function checkType( \Title &$title ) {
		return $title->exists() && $title->getContentModel() === $this->opts['type'];
	}

	/**
	 * @see \Pickle\InvokeSubpage::checkSubpageType()
	 * @param \Title &$title to be used as source
	 * @param bool|null $type of content model (optional)
	 * @return bool
	 */
	public function checkSubpageType( \Title &$title, $type = null ) {
		// this will be cached
		$subpage = \Title::newFromText( $this->getSubpagePrefixedText( $title )->plain() );
		return ( $type === null
			? ( $subpage->exists() && $subpage->getContentModel() === $this->opts['type'] )
			: ( $subpage->getContentModel() === $type ) );
	}

	/**
	 * @see \Pickle\InvokeSubpage::getInvoke()
	 * @param \Title &$title to be used as source
	 * @return \Message
	 */
	public function getInvoke( \Title &$title ) {
		$subpage = $this->getSubpageBaseText( $title );
		// @message pickle-spectype-invoke
		return wfMessage( 'pickle-' . $this->opts['name'] . '-invoke', $subpage->plain() );
	}

	/**
	 * @see \Pickle\InvokeSubpage::getSubpagePrefixedText()
	 * @param \Title &$title to be used as source
	 * @return \Message
	 */
	public function getSubpagePrefixedText( \Title &$title ) {
		$text = $title->getPrefixedText();
		// @message pickle-spectype-subpage
		return wfMessage( 'pickle-' . $this->opts['name'] . '-subpage', $text );
	}

	/**
	 * @see \Pickle\InvokeSubpage::getSubpageBaseText()
	 * @param \Title &$title to be used as source
	 * @return \Message
	 */
	public function getSubpageBaseText( \Title &$title ) {
		$baseText = $title->getBaseText();
		// @message pickle-spectype-subpage
		return wfMessage( 'pickle-' . $this->opts['name'] . '-subpage', $baseText );
	}

}
