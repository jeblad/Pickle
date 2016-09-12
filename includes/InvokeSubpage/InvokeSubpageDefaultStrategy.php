<?php

namespace Spec;

use \Spec\IInvokeSubpageStrategy;

/**
 * Identify InvokeSubpage and find a message
 */
class InvokeSubpageDefaultStrategy implements IInvokeSubpageStrategy {

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
	 * @see \Spec\IInvokeSubpageStrategy::checkType()
	 */
	public function checkType( \Title &$title ) {
		return true;
	}

	/**
	 * @see \Spec\IInvokeSubpageStrategy::checkSubpageType()
	 */
	public function checkSubpageType( \Title &$title, $type = null ) {
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
