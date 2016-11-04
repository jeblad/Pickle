<?php

namespace Spec\Tests;

use MediaWikiTestCase;
use \Spec\LogEntryFactory;

/**
 * @group Spec
 *
 * @covers \Spec\LogEntryFactory
 */
class LogEntryFactoryTest extends StrategiesTestCase {

	public static function stratClass() {
		return 'Spec\LogEntryFactory';
	}

	public function testOnCodeToInterface() {
		$test = LogEntryFactory::getInstance();
		$this->assertInstanceOf( 'Spec\\IStrategies', $test );
	}

	public function testWho() {
		$test = LogEntryFactory::who();
		$this->assertEquals( 'Spec\LogEntryFactory', $test );
	}

	public function testInit() {
		$testA = LogEntryFactory::getInstance();
		$testB = LogEntryFactory::getInstance();
		$this->assertEquals( LogEntryFactory::who(), get_class( $testA ) );
		$this->assertEquals( $testA, $testB );
	}

	public function testRegister() {
		$struct = [ 'class' => 'Spec\LogEntryCommon' ];
		$test = LogEntryFactory::getInstance();
		$instance = $test->register( $struct );
		$this->assertEquals( get_class( $instance ), $struct['class'] );
	}

	public function provideFind() {
		return [
			[ 'Spec\LogEntryCommon', 'foo' ],
			[ 'Spec\LogEntryDefault', 'bar' ]
		];
	}

	/**
	 * @dataProvider provideFind
	 */
	public function testFind( $expect, $name ) {

		$title = $this->getMockBuilder( '\Title' )
			->getMock();

		$test = LogEntryFactory::getInstance();
		$test->register(
			[
				'class' => 'Spec\LogEntryCommon',
				'name' => 'foo'
			]
		);
		$test->register(
			[
				'class' => 'Spec\LogEntryDefault'
			]
		);
		$Strategy = $test->find( $name );
		$this->assertEquals( $expect, get_class( $Strategy ) );
	}
}
