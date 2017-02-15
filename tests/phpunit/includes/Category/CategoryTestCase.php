<?php

namespace Pickle\Tests;

abstract class CategoryTestCase extends \MediaWikiTestCase {

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

	/**
	 * @dataProvider provideGetKey
	 */
	public function testOnGetKey( $expect, $conf ) {
		$test = $this->newInstance( $conf );
		$this->assertNotNull( $test );

		$this->assertEquals( $expect, $test->getKey() );
	}

	public function testOnCodeToInterface() {
		$test = $this->newInstance( $this->conf );
		$this->assertInstanceOf( 'Pickle\\ACategory', $test );
	}

	public function testOnAddCategory() {
		$test = $this->newInstance( $this->conf );
		$this->assertNotNull( $test );

		$result = $test->addCategorization( $this->stubTitle, $this->stubPOut );
		$this->assertTrue( $result );
	}
}
