<?php

namespace Spec\Tests;

abstract class TrackLogEntryStrategyTestCase extends \MediaWikiTestCase {

	protected $stubTitle;

	public function setUp() {
		parent::setUp();
		$this->stubTitle = $this->getMockBuilder( '\Title' )
			->setMethods( [ 'getArticleID' ] )
			->getMock();
		$this->stubTitle
			->expects( $this->any() )
			->method( 'getArticleID' )
			->will( $this->returnValue( 123 ) );
	}

	public function tearDown() {
		unset( $this->stub );
		parent::tearDown();
	}

	abstract protected function newInstance( $conf );

	/**
	 * @dataProvider provideGetName
	 */
	public function testOnGetName( $expect, $conf ) {
		$test = $this->newInstance( $conf );
		$this->assertNotNull( $test );

		$this->assertEquals( $expect, $test->getName() );
	}

	public function testOnCodeToInterface() {
		$test = $this->newInstance( $this->conf );
		$this->assertInstanceOf( 'Spec\\ITrackLogEntryStrategy', $test );
	}

	/**
	 * @dataProvider provideNewLogEntry
	 */
	public function testOnNewLogEntry( $expect, $conf ) {
		$test = $this->newInstance( $conf );
		$this->assertNotNull( $test );
		$logEntry = $test->newLogEntry( $this->stubTitle );
		$this->assertNotNull( $logEntry );
		$this->assertEquals( $expect['type'], $logEntry->getType() );
		$this->assertEquals( $expect['subtype'], $logEntry->getSubtype() );
		$this->assertEquals( $this->stubTitle, $logEntry->getTarget() );
		$this->assertFalse( $logEntry->getIsPatrollable() );
	}
}
