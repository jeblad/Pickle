<?php

namespace Spec\Tests;

use MediaWikiTestCase;
use \Spec\Observer;

/**
 * @group Spec
 *
 * @covers \Spec\Observer
 */
class ObserverTest extends \MediaWikiTestCase {

	public function testGetUser() {
		global $wgSpecObserverID;

		$user = Observer::getUser();
		$this->assertNotNull( $user );
		$this->assertInstanceOf( '\User', $user );
		$this->assertEquals( $wgSpecObserverID, $user->getID() );
	}

}
