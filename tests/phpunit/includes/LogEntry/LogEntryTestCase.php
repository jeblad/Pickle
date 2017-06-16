<?php

namespace Pickle\Tests;

abstract class LogEntryTestCase extends \MediaWikiTestCase {

	protected $stubTitle;

	/**
	 */
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

	/**
	 */
	public function tearDown() {
		unset( $this->stub );
		parent::tearDown();
	}

	/**
	 * @param any $conf for general configuration
	 */
	abstract protected function newInstance( $conf );

	/**
	 * @dataProvider provideGetName
	 * @param any $expect to get this
	 * @param any $conf for this
	 */
	public function testOnGetName( $expect, $conf ) {
		$test = $this->newInstance( $conf );
		$this->assertNotNull( $test );

		$this->assertEquals( $expect, $test->getName() );
	}

	/**
	 */
	public function testOnCodeToInterface() {
		$test = $this->newInstance( $this->conf );
		$this->assertNotNull( $test );

		$this->assertInstanceOf( 'Pickle\\LogEntry', $test );
	}

	/**
	 * @dataProvider provideNewLogEntry
	 * @param any $expect to get this
	 * @param any $conf for this
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
