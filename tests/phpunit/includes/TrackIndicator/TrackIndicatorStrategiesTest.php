<?php

namespace Spec\Tests;

use MediaWikiTestCase;
use \Spec\TrackIndicatorStrategies;

/**
 * @group Spec
 *
 * @covers \Spec\TrackIndicatorStrategies
 */
class TrackIndicatorStrategiesTest extends StrategiesTestCase {

	public static function stratClass() {
		return 'Spec\TrackIndicatorStrategies';
	}

	public function testOnCodeToInterface() {
		$test = TrackIndicatorStrategies::getInstance();
		$this->assertInstanceOf( 'Spec\\IStrategies', $test );
	}

	public function testWho() {
		$test = TrackIndicatorStrategies::who();
		$this->assertEquals( 'Spec\TrackIndicatorStrategies', $test );
	}

	public function testInit() {
		$testA = TrackIndicatorStrategies::getInstance();
		$testB = TrackIndicatorStrategies::getInstance();
		$this->assertEquals( TrackIndicatorStrategies::who(), get_class( $testA ) );
		$this->assertEquals( $testA, $testB );
	}

	public function testRegister() {
		$struct = [ 'class' => 'Spec\TrackIndicatorCommonStrategy' ];
		$test = TrackIndicatorStrategies::getInstance();
		$instance = $test->register( $struct );
		$this->assertEquals( get_class( $instance ), $struct['class'] );
	}

	public function provideFind() {
		return [
			[ 'Spec\TrackIndicatorCommonStrategy', 'foo' ],
			[ 'Spec\TrackIndicatorDefaultStrategy', 'bar' ]
		];
	}

	/**
	 * @dataProvider provideFind
	 */
	public function testFind( $expect, $name ) {

		$title = $this->getMockBuilder( '\Title' )
			->getMock();

		$test = TrackIndicatorStrategies::getInstance();
		$test->register(
			[
				'class' => 'Spec\TrackIndicatorCommonStrategy',
				'name' => 'foo'
			]
		);
		$test->register(
			[
				'class' => 'Spec\TrackIndicatorDefaultStrategy'
			]
		);
		$Strategy = $test->find( $name );
		$this->assertEquals( $expect, get_class( $Strategy ) );
	}
}
