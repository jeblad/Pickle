<?php

namespace Pickle\Tests;

abstract class IndicatorTestCase extends \MediaWikiTestCase {

	protected $stubTitle;
	protected $stubPOut;

	/**
	 */
	public function setUp() {
		parent::setUp();
		$this->stubTitle = $this->getMockBuilder( '\Title' )
			->getMock();
		$this->stubPOut = $this->getMockBuilder( '\ParserOutput' )
			->disableOriginalConstructor()
			->setMethods( [ 'setIndicators' ] )
			->getMock();
		$this->stubPOut
			->expects( $this->any() )
			->method( 'setIndicators' )
			->will( $this->returnValue( true ) );
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
	 */
	public function testOnCodeToInterface() {
		$test = $this->newInstance( $this->conf );
		$this->assertInstanceOf( 'Pickle\\Indicator', $test );
	}

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
	public function testOnGetKey() {
		$test = $this->newInstance( $this->conf );
		$this->assertNotNull( $test );

		$this->assertRegExp( '/^[-\w]+$/', $test->getKey() );
		$this->assertContains( $test->getName(), $test->getKey() );
	}

	/**
	 */
	public function testOnGetIcon() {
		$test = $this->newInstance( $this->conf );
		$this->assertNotNull( $test );

		$this->assertRegExp( '/^[-\w]+$/', $test->getIcon() );
		$this->assertContains( 'bar', $test->getIcon() );
	}

	/**
	 */
	public function testOnGetMessageKey() {
		$test = $this->newInstance( $this->conf );
		$this->assertNotNull( $test );

		$this->assertRegExp( '/^[-\w]+$/', $test->getMessageKey() );
		$this->assertContains( $test->getName(), $test->getMessageKey() );
	}

	/**
	 */
	public function testOnGetClassKey() {
		$test = $this->newInstance( $this->conf );
		$this->assertNotNull( $test );

		$this->assertRegExp( '/^[-\w]+$/', $test->getClassKey() );
	}

	/**
	 */
	public function testOnAddIndicator() {
		$test = $this->newInstance( $this->conf );
		$this->assertNotNull( $test );

		$result = $test->addIndicator( $this->stubTitle, $this->stubPOut );
		$this->assertNotNull( $result );
	}

	/**
	 */
	public function testOnMakeLink() {
		$test = $this->newInstance( $this->conf );
		$this->assertNotNull( $test );

		$elem = $test->makeLink( 'http://example.com', 'qqx' );
		$this->assertNotNull( $elem );
		$this->assertContains( '<a ', $elem );
		$this->assertContains( 'http://example.com', $elem );
		$this->assertContains( $test->getMessageKey(), $elem );
	}

	/**
	 */
	public function testOnMakeNote() {
		$test = $this->newInstance( $this->conf );
		$this->assertNotNull( $test );

		$elem = $test->makeNote( 'qqx' );
		$this->assertNotNull( $elem );
		$this->assertContains( '<span ', $elem );
		$this->assertContains( $test->getMessageKey(), $elem );
	}
}
