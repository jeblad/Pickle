<?php

namespace Pickle\Tests;

use \Pickle\TAPStrategies;

/**
 * @group Pickle
 *
 * @covers \Pickle\TAPStrategies
 */
class TAPStrategiesTest extends StrategiesTestCase {

	public static function stratClass() {
		return 'Pickle\TAPStrategies';
	}

	public function testOnCodeToInterface() {
		$test = TAPStrategies::getInstance();
		$this->assertInstanceOf( 'Pickle\\IStrategies', $test );
	}

	public function testWho() {
		$test = TAPStrategies::who();
		$this->assertEquals( 'Pickle\TAPStrategies', $test );
	}

	public function testInit() {
		$testA = TAPStrategies::getInstance();
		$testB = TAPStrategies::getInstance();
		$this->assertEquals( TAPStrategies::who(), get_class( $testA ) );
		$this->assertEquals( $testA, $testB );
	}

	public function testRegister() {
		$struct = [ 'class' => 'Pickle\TAPCommonParser' ];
		$test = TAPStrategies::getInstance();
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
		$test = TAPStrategies::getInstance();
		$test->register(
			[
				'class' => 'Pickle\TAP13Parser',
				'name' => 'tap-13'
			]
		);
		$test->register(
			[
				'class' => 'Pickle\TAPCommonParser',
				'name' => 'tap'
			]
		);
		$parser = $test->find( $str );
		if ( $name === null ) {
			$this->assertNull( $parser );
			return;
		}
		$this->assertEquals( $name, $parser->getName() );
		$this->assertEquals( $expect, $parser->parse( $str ) );
	}
}
