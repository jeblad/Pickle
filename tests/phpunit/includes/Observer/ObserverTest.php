<?php

namespace Pickle\Tests;

use \Pickle\Observer;

/**
 * @group Pickle
 *
 * @covers \Pickle\Observer
 */
class ObserverTest extends \MediaWikiTestCase {

	public function testGetUser() {
		global $wgPickleObserverID;

		$user = Observer::getUser();
		$this->assertNotNull( $user );
		$this->assertInstanceOf( '\User', $user );
		$this->assertEquals( $wgPickleObserverID, $user->getID() );
	}

}
