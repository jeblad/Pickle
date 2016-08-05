<?php

namespace Spec\Tests;

abstract class TrackCategoryStrategyTestCase extends \MediaWikiTestCase {

	protected $stubTitle;
	protected $stubPOut;

	public function setUp() {
		parent::setUp();
		$this->stubTitle = $this->getMockBuilder( '\Title' )
			->getMock();
		$this->stubPOut = $this->getMockBuilder( '\ParserOutput' )
			->setMethods( [ 'addTrackingCategory' ] )
			->getMock();
		$this->stubPOut
			->expects( $this->any() )
			->method( 'addTrackingCategory' )
			->will( $this->returnValue( true ) );
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

	public function testOnGetKey() {
		$test = $this->newInstance( $this->conf );
		$this->assertNotNull( $test );

		$this->assertRegExp( '/^[-\w]+$/', $test->getKey() );
		$this->assertContains( $test->getName(), $test->getKey() );
	}

	public function testOnCodeToInterface() {
		$test = $this->newInstance( $this->conf );
		$this->assertInstanceOf( 'Spec\\ITrackCategoryStrategy', $test );
	}

	public function testOnAddCategory() {
		$test = $this->newInstance( $this->conf );
		$this->assertNotNull( $test );

		$result = $test->addCategorization( $this->stubTitle, $this->stubPOut );
		$this->assertTrue( $result );
	}
}
