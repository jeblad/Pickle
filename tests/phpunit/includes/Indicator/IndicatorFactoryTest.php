<?php

namespace Pickle\Tests;

use \Pickle\IndicatorFactory;

/**
 * @group Pickle
 *
 * @covers \Pickle\IndicatorFactory
 */
class IndicatorFactoryTest extends StrategiesTestCase {

	public static function stratClass() {
		return 'Pickle\IndicatorFactory';
	}

	public function testOnCodeToInterface() {
		$test = IndicatorFactory::getInstance();
		$this->assertInstanceOf( 'Pickle\\IStrategies', $test );
	}

	public function testWho() {
		$test = IndicatorFactory::who();
		$this->assertEquals( 'Pickle\IndicatorFactory', $test );
	}

	public function testInit() {
		$testA = IndicatorFactory::getInstance();
		$testB = IndicatorFactory::getInstance();
		$this->assertEquals( IndicatorFactory::who(), get_class( $testA ) );
		$this->assertEquals( $testA, $testB );
	}

	public function testRegister() {
		$struct = [ 'class' => 'Pickle\IndicatorCommon' ];
		$test = IndicatorFactory::getInstance();
		$instance = $test->register( $struct );
		$this->assertEquals( get_class( $instance ), $struct['class'] );
	}

	public function provideFind() {
		return [
			[ 'Pickle\IndicatorCommon', 'foo' ],
			[ 'Pickle\IndicatorDefault', 'bar' ]
		];
	}

	/**
	 * @dataProvider provideFind
	 */
	public function testFind( $expect, $name ) {
		// @todo cleanup later on…
		// $title = $this->getMockBuilder( '\Title' )
		// ->getMock();

		$test = IndicatorFactory::getInstance();
		$test->register(
			[
				'class' => 'Pickle\IndicatorCommon',
				'name' => 'foo'
			]
		);
		$test->register(
			[
				'class' => 'Pickle\IndicatorDefault'
			]
		);
		$strategy = $test->find( $name );
		$this->assertEquals( $expect, get_class( $strategy ) );
	}
}
