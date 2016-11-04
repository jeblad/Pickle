<?php

namespace Spec\Tests;

use MediaWikiTestCase;
use \Spec\CategoryFactory;

/**
 * @group Spec
 *
 * @covers \Spec\CategoryFactory
 */
class CategoryFactoryTest extends StrategiesTestCase {

	public static function stratClass() {
		return 'Spec\CategoryFactory';
	}

	public function testOnCodeToInterface() {
		$test = CategoryFactory::getInstance();
		$this->assertInstanceOf( 'Spec\\IStrategies', $test );
	}

	public function testWho() {
		$test = CategoryFactory::who();
		$this->assertEquals( 'Spec\CategoryFactory', $test );
	}

	public function testInit() {
		$testA = CategoryFactory::getInstance();
		$testB = CategoryFactory::getInstance();
		$this->assertEquals( CategoryFactory::who(), get_class( $testA ) );
		$this->assertEquals( $testA, $testB );
	}

	public function testRegister() {
		$struct = [ 'class' => 'Spec\CategoryCommon' ];
		$test = CategoryFactory::getInstance();
		$instance = $test->register( $struct );
		$this->assertEquals( get_class( $instance ), $struct['class'] );
	}

	public function provideFind() {
		return [
			[ 'Spec\CategoryCommon', 'foo' ],
			[ 'Spec\CategoryDefault', 'bar' ]
		];
	}

	/**
	 * @dataProvider provideFind
	 */
	public function testFind( $expect, $name ) {

		$title = $this->getMockBuilder( '\Title' )
			->getMock();

		$test = CategoryFactory::getInstance();
		$test->register(
			[
				'class' => 'Spec\CategoryCommon',
				'name' => 'foo'
			]
		);
		$test->register(
			[
				'class' => 'Spec\CategoryDefault'
			]
		);
		$Strategy = $test->find( $name );
		$this->assertEquals( $expect, get_class( $Strategy ) );
	}
}
