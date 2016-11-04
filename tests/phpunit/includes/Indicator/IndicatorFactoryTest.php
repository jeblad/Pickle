<?php

namespace Spec\Tests;

use MediaWikiTestCase;
use \Spec\IndicatorFactory;

/**
 * @group Spec
 *
 * @covers \Spec\IndicatorFactory
 */
class IndicatorFactoryTest extends StrategiesTestCase {

	public static function stratClass() {
		return 'Spec\IndicatorFactory';
	}

	public function testOnCodeToInterface() {
		$test = IndicatorFactory::getInstance();
		$this->assertInstanceOf( 'Spec\\IStrategies', $test );
	}

	public function testWho() {
		$test = IndicatorFactory::who();
		$this->assertEquals( 'Spec\IndicatorFactory', $test );
	}

	public function testInit() {
		$testA = IndicatorFactory::getInstance();
		$testB = IndicatorFactory::getInstance();
		$this->assertEquals( IndicatorFactory::who(), get_class( $testA ) );
		$this->assertEquals( $testA, $testB );
	}

	public function testRegister() {
		$struct = [ 'class' => 'Spec\IndicatorCommon' ];
		$test = IndicatorFactory::getInstance();
		$instance = $test->register( $struct );
		$this->assertEquals( get_class( $instance ), $struct['class'] );
	}

	public function provideFind() {
		return [
			[ 'Spec\IndicatorCommon', 'foo' ],
			[ 'Spec\IndicatorDefault', 'bar' ]
		];
	}

	/**
	 * @dataProvider provideFind
	 */
	public function testFind( $expect, $name ) {

		$title = $this->getMockBuilder( '\Title' )
			->getMock();

		$test = IndicatorFactory::getInstance();
		$test->register(
			[
				'class' => 'Spec\IndicatorCommon',
				'name' => 'foo'
			]
		);
		$test->register(
			[
				'class' => 'Spec\IndicatorDefault'
			]
		);
		$Strategy = $test->find( $name );
		$this->assertEquals( $expect, get_class( $Strategy ) );
	}
}
