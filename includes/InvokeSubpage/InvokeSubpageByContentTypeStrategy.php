<?php

namespace Spec;

use \Spec\IInvokeSubpageStrategy;

/**
 * Identify InvokeSubpage and find a message
 */
class InvokeSubpageByContentTypeStrategy implements IInvokeSubpageStrategy {

	protected $opts;

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
	 * @see \Spec\IInvokeSubpageStrategy::checkType()
	 */
	public function checkType( \Title &$title ) {
		return $title->exists() && $title->getContentModel() === $this->opts['type'];
	}

	/**
	 * @see \Spec\IInvokeSubpageStrategy::checkSubpageType()
	 */
	public function checkSubpageType( \Title &$title, $type = null ) {
		// this will be cached
		$subpage = \Title::newFromText( $this->getSubpagePrefixedText( $title )->plain() );
		return ( $type === null
			? ( $subpage->exists() && $subpage->getContentModel() === $this->opts['type'] )
			: ( $subpage->getContentModel() === $type ) );
	}

	/**
	 * @see \Spec\IInvokeSubpageStrategy::getInvoke()
	 */
	public function getInvoke( \Title &$title ) {
		$subpage = $this->getSubpageBaseText( $title );
		// @message spec-spectype-invoke
		return wfMessage( 'spec-' . $this->opts['name'] . '-invoke', $subpage->plain() );
	}

	/**
	 * @see \Spec\IInvokeSubpageStrategy::getSubpagePrefixedText()
	 */
	public function getSubpagePrefixedText( \Title &$title ) {
		$text = $title->getPrefixedText();
		// @message spec-spectype-subpage
		return wfMessage( 'spec-' . $this->opts['name'] . '-subpage', $text );
	}

	/**
	 * @see \Spec\IInvokeSubpageStrategy::getSubpageBaseText()
	 */
	public function getSubpageBaseText( \Title &$title ) {
		$baseText = $title->getBaseText();
		// @message spec-spectype-subpage
		return wfMessage( 'spec-' . $this->opts['name'] . '-subpage', $baseText );
	}

	/**
	 * @see \Spec\IInvokeSubpageStrategy::getSubpageTitle()
	 */
	public function getSubpageTitle( \Title &$title ) {
		return \Title::newFromText( $this->getSubpagePrefixedText( $title )->plain() );
	}

	/**
	 * @see \Spec\IInvokeSubpageStrategy::getTesterQuestion()
	 */
	public function getTesterQuestion( \Title &$title ) {
		return $this->opts['testerQuestion'];
	}

	/**
	 * @see \Spec\IInvokeSubpageStrategy::getTesteeQuestion()
	 */
	public function getTesteeQuestion( \Title &$title ) {
		$prefixedText = $this->getSubpagePrefixedText( $title );
		return sprintf( $this->opts['testeeQuestion'], $prefixedText->plain() );
	}

}
