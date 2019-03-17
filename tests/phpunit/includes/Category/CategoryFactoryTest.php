<?php

namespace Pickle\Tests;

use \Pickle\CategoryFactory;

/**
 * @group Pickle
 *
 * @covers \Pickle\CategoryFactory
 */
class CategoryFactoryTest extends StrategiesTestCase {

	public static function stratClass() {
		return 'Pickle\CategoryFactory';
	}

	public function testOnCodeToInterface() {
		$test = CategoryFactory::getInstance();
		$this->assertInstanceOf( 'Pickle\\IStrategies', $test );
	}

	public function testWho() {
		$test = CategoryFactory::who();
		$this->assertEquals( 'Pickle\CategoryFactory', $test );
	}

	public function testInit() {
		$testA = CategoryFactory::getInstance();
		$testB = CategoryFactory::getInstance();
		$this->assertEquals( CategoryFactory::who(), get_class( $testA ) );
		$this->assertEquals( $testA, $testB );
	}

	public function testRegister() {
		$struct = [ 'class' => 'Pickle\CategoryCommon' ];
		$test = CategoryFactory::getInstance();
		$instance = $test->register( $struct );
		$this->assertEquals( get_class( $instance ), $struct['class'] );
	}

	public function provideFind() {
		return [
			[ 'Pickle\CategoryCommon', 'foo' ],
			[ 'Pickle\CategoryDefault', 'bar' ]
		];
	}

	/**
	 * @dataProvider provideFind
	 */
	public function testFind( $expect, $name ) {
		// @todo cleanup later on…
		// $title = $this->getMockBuilder( '\Title' )
		// ->getMock();

		$test = CategoryFactory::getInstance();
		$test->register(
			[
				'class' => 'Pickle\CategoryCommon',
				'name' => 'foo'
			]
		);
		$test->register(
			[
				'class' => 'Pickle\CategoryDefault'
			]
		);
		$strategy = $test->find( $name );
		$this->assertEquals( $expect, get_class( $strategy ) );
	}
}
