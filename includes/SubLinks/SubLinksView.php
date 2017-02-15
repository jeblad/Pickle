<?php

namespace Pickle;

/**
 * Test console view
 *
 * @ingroup Extensions
 */
class SubLinksView implements ISubLinksView {

	/**
	 * @see \Pickle\ISubLinksView::makeLink()
	 */
	public static function makeLink( $title, $lang = null ) {

		// Get the message containing the text to use for the link
		$msg = wfMessage( 'viewpagelogs' );
		$msg = $lang === null ? $msg->inContentLanguage() : $msg->inLanguage( $lang );
		if ( $msg->isDisabled() ) {
			return null;
		}

		// Creation of a subtitle link pointing to [[Special:Log]]
		$elem = \Linker::linkKnown(
			\SpecialPage::getTitleFor( 'Log' ),
			$msg->escaped(),
			[],
			[ 'page' => $title->getPrefixedText() ]
		);

		return $elem;
	}

	/**
	 * Add change log for tested module
	 * This is a callback for a hook registered in extensions.json
	 */
	public static function onOutputPageParserOutput(
		\OutputPage &$out,
		\ParserOutput $parserOutput
	) {

		$currentKey = $parserOutput->getExtensionData( 'pickle-status-current' );
		$currentType = $parserOutput->getExtensionData( 'pickle-page-type' );

		if ( $currentKey !== null && in_array( $currentType, [ 'normal' ] ) ) {
			$link = self::makeLink( $out->getTitle() );
			$out->addSubtitle( $link );
		}

		return true;
	}
}
