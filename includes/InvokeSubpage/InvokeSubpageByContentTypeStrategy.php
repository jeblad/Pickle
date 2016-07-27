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
		$this->opts = array_merge( [ 'name' => '', 'type' => 'Scribunto' ], $opts );
	}

	/**
	 * @see \Spec\IInvokeSubpageStrategy::checkType()
	 */
	public function checkType( \Title &$title ) {
		return $title->exists() && $title->getContentModel() === $this->opts['type'];
	}

	/**
	 * @see \Spec\IInvokeSubpageStrategy::getInvoke()
	 */
	public function getInvoke( \Title &$title ) {
		$subpage = $this->getSubpageBaseText( $title );
		return wfMessage( 'spec-' . $this->opts['name'] . '-invoke', $subpage->plain() );
	}

	/**
	 * @see \Spec\IInvokeSubpageStrategy::getSubpagePrefixedText()
	 */
	public function getSubpagePrefixedText( \Title &$title ) {
		$text = $title->getPrefixedText();
		return wfMessage( 'spec-' . $this->opts['name'] . '-subpage', $text );
	}

	/**
	 * @see \Spec\IInvokeSubpageStrategy::getSubpageBaseText()
	 */
	public function getSubpageBaseText( \Title &$title ) {
		$baseText = $title->getBaseText();
		return wfMessage( 'spec-' . $this->opts['name'] . '-subpage', $baseText );
	}

}
