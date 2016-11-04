<?php

namespace Spec\Tests;

use \Spec\Strategies;

/**
 * @group Spec
 *
 * @covers \Spec\Strategies
 */
class StrategiesTest extends StrategiesTestCase {

	public static function stratClass() {
		return 'Spec\Strategies';
	}

	public function testOnCodeToInterface() {
		$test = Strategies::getInstance();
		$this->assertInstanceOf( 'Spec\\IStrategies', $test );
	}

	public function testInit() {
		$testA = Strategies::getInstance();
		$testB = Strategies::getInstance();
		$this->assertEquals( $testA, $testB );
	}

	public function testOnExport() {
		$instance = Strategies::getInstance();
		$this->assertEquals( [], $instance->export() );
	}

	public function testOnImport() {
		$instance = Strategies::getInstance();
		$instance->import( [ 1, 2, 3 ] );
		$this->assertEquals( [ 1, 2, 3 ], $instance->export() );
	}

	public function testOnReset() {
		$instance = Strategies::getInstance();
		$instance->import( [ 1, 2, 3 ] );
		$instance->reset();
		$this->assertEquals( [], $instance->export() );
	}
}
