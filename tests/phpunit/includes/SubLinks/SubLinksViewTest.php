<?php

namespace Pickle\Tests;

use \Pickle\SubLinksView;

/**
 * @group Pickle
 *
 * @covers \Pickle\SubLinksView
 */
class SubLinksViewTest extends \MediaWikiTestCase {

	public function testOnMakeLink() {
		$title = $this->getMockBuilder( '\Title' )
			->setMethods( [ 'getPrefixedText' ] )
			->getMock();
		$title
			->expects( $this->any() )
			->method( 'getPrefixedText' )
			->will( $this->returnValue( 'foo' ) );

		$link = SubLinksView::makeLink( $title, 'qqx' );
		$this->assertContains( '<a ', $link );
		// $this->assertContains( 'Special:Log', $link );
		$this->assertContains( '(viewpagelogs)', $link );
	}
}
