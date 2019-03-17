<?php

namespace Pickle\Tests;

use \Pickle\LogEntryFactory;

/**
 * @group Pickle
 *
 * @covers \Pickle\LogEntryFactory
 */
class LogEntryFactoryTest extends StrategiesTestCase {

	public static function stratClass() {
		return 'Pickle\LogEntryFactory';
	}

	public function testOnCodeToInterface() {
		$test = LogEntryFactory::getInstance();
		$this->assertInstanceOf( 'Pickle\\IStrategies', $test );
	}

	public function testWho() {
		$test = LogEntryFactory::who();
		$this->assertEquals( 'Pickle\LogEntryFactory', $test );
	}

	public function testInit() {
		$testA = LogEntryFactory::getInstance();
		$testB = LogEntryFactory::getInstance();
		$this->assertEquals( LogEntryFactory::who(), get_class( $testA ) );
		$this->assertEquals( $testA, $testB );
	}

	public function testRegister() {
		$struct = [ 'class' => 'Pickle\LogEntryCommon' ];
		$test = LogEntryFactory::getInstance();
		$instance = $test->register( $struct );
		$this->assertEquals( get_class( $instance ), $struct['class'] );
	}

	public function provideFind() {
		return [
			[ 'Pickle\LogEntryCommon', 'foo' ],
			[ 'Pickle\LogEntryDefault', 'bar' ]
		];
	}

	/**
	 * @dataProvider provideFind
	 */
	public function testFind( $expect, $name ) {
		// @todo cleanup later on…
		// $title = $this->getMockBuilder( '\Title' )
		// ->getMock();

		$test = LogEntryFactory::getInstance();
		$test->register(
			[
				'class' => 'Pickle\LogEntryCommon',
				'name' => 'foo'
			]
		);
		$test->register(
			[
				'class' => 'Pickle\LogEntryDefault'
			]
		);
		$strategy = $test->find( $name );
		$this->assertEquals( $expect, get_class( $strategy ) );
	}
}
