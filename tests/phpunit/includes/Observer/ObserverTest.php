<?php

namespace Pickle\Tests;

use MediaWikiTestCase;
use \Pickle\Observer;

/**
 * @group Pickle
 *
 * @covers \Pickle\Observer
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
