<?php

namespace Spec\Tests;

use MediaWikiTestCase;
use \Spec\TrackUser;

/**
 * @group Spec
 *
 * @covers \Spec\TrackUser
 */
class TrackUserTest extends \MediaWikiTestCase {

	public function testGetUser() {
		global $wgSpecTrackUserID;

		$user = TrackUser::getUser();
		$this->assertNotNull( $user );
		$this->assertInstanceOf( '\User', $user );
		$this->assertEquals( $wgSpecTrackUserID, $user->getID() );
	}

}
