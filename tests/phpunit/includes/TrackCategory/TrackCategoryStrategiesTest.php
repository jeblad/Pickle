<?php

namespace Spec\Tests;

use MediaWikiTestCase;
use \Spec\TrackCategoryStrategies;

/**
 * @group Spec
 *
 * @covers \Spec\TrackCategoryStrategies
 */
class TrackCategoryStrategiesTest extends SingletonsTestCase {

	public static function stratClass() {
		return 'Spec\TrackCategoryStrategies';
	}

	public function testOnCodeToInterface() {
		$test = TrackCategoryStrategies::getInstance();
		$this->assertInstanceOf( 'Spec\\ISingletons', $test );
	}

	public function testWho() {
		$test = TrackCategoryStrategies::who();
		$this->assertEquals( 'Spec\TrackCategoryStrategies', $test );
	}

	public function testInit() {
		$testA = TrackCategoryStrategies::getInstance();
		$testB = TrackCategoryStrategies::getInstance();
		$this->assertEquals( TrackCategoryStrategies::who(), get_class( $testA ) );
		$this->assertEquals( $testA, $testB );
	}

	public function testRegister() {
		$struct = [ 'class' => 'Spec\TrackCategoryCommonStrategy' ];
		$test = TrackCategoryStrategies::getInstance();
		$instance = $test->register( $struct );
		$this->assertEquals( get_class( $instance ), $struct['class'] );
	}

	public function provideFind() {
		return [
			[ 'Spec\TrackCategoryCommonStrategy', 'foo' ],
			[ 'Spec\TrackCategoryDefaultStrategy', 'bar' ]
		];
	}

	/**
	 * @dataProvider provideFind
	 */
	public function testFind( $expect, $name ) {

		$title = $this->getMockBuilder( '\Title' )
			->getMock();

		$test = TrackCategoryStrategies::getInstance();
		$test->register(
			[
				'class' => 'Spec\TrackCategoryCommonStrategy',
				'name' => 'foo'
			]
		);
		$test->register(
			[
				'class' => 'Spec\TrackCategoryDefaultStrategy'
			]
		);
		$Strategy = $test->find( $name );
		$this->assertEquals( $expect, get_class( $Strategy ) );
	}
}
