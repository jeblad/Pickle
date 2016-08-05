<?php

namespace Spec\Tests;

use MediaWikiTestCase;
use \Spec\TrackObserver;

/**
 * @group Spec
 *
 * @covers \Spec\TrackObserver
 */
class TrackObserverTest extends \MediaWikiTestCase {

	public function testGetUser() {
		global $wgSpecTrackObserverID;

		$user = TrackObserver::getUser();
		$this->assertNotNull( $user );
		$this->assertInstanceOf( '\User', $user );
		$this->assertEquals( $wgSpecTrackObserverID, $user->getID() );
	}

}
