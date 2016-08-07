<?php

namespace Spec\Tests;

use MediaWikiTestCase;
use \Spec\TestAnythingProtocolStrategies;

/**
 * @group Spec
 *
 * @covers \Spec\TestAnythingProtocolStrategies
 */
class TestAnythingProtocolStrategiesTest extends SingletonsTestCase {

	public static function stratClass() {
		return 'Spec\TestAnythingProtocolStrategies';
	}

	public function testOnCodeToInterface() {
		$test = TestAnythingProtocolStrategies::getInstance();
		$this->assertInstanceOf( 'Spec\\ISingletons', $test );
	}

	public function testWho() {
		$test = TestAnythingProtocolStrategies::who();
		$this->assertEquals( 'Spec\TestAnythingProtocolStrategies', $test );
	}

	public function testInit() {
		$testA = TestAnythingProtocolStrategies::getInstance();
		$testB = TestAnythingProtocolStrategies::getInstance();
		$this->assertEquals( TestAnythingProtocolStrategies::who(), get_class( $testA ) );
		$this->assertEquals( $testA, $testB );
	}

	public function testRegister() {
		$struct = [ 'class' => 'Spec\TestAnythingProtocolCommonStrategy' ];
		$test = TestAnythingProtocolStrategies::getInstance();
		$instance = $test->register( $struct );
		$this->assertEquals( get_class( $instance ), $struct['class'] );
	}

	public function provideFind() {
		return [
			[ 'good', "tap-13", "TAP version 13\nok 1 - test\n" ],
			[ 'bad', "tap-13", "TAP version 13\nnot ok 1 - test\n" ],
			[ 'good', "tap", "1..1\nok 1 - test\n" ],
			[ 'bad', "tap", "1..1\nnot ok 1 - test\n" ],
			[ "ok 1 - test\n", null, "ok 1 - test\n" ],
			[ "not ok 1 - test\n", null, "not ok 1 - test\n" ]
		];
	}

	/**
	 * @dataProvider provideFind
	 */
	public function testFind( $expect, $name, $str ) {

		$test = TestAnythingProtocolStrategies::getInstance();
		$test->register(
			[
				'class' => 'Spec\TestAnythingProtocol13Strategy',
				'name' => 'tap-13'
			]
		);
		$test->register(
			[
				'class' => 'Spec\TestAnythingProtocolCommonStrategy',
				'name' => 'tap'
			]
		);
		$strategy = $test->find( $str );
		if ( $name === null ) {
			$this->assertNull( $strategy );
		} else {
			$this->assertEquals( $name, $strategy->getName() );
			$this->assertEquals( $expect, $strategy->parse( $str ) );
		}
	}
}
