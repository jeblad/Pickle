<?php

namespace Pickle\Tests;

use \Pickle\Strategies;

/**
 * @group Pickle
 *
 * @covers \Pickle\Strategies
 */
class StrategiesTest extends StrategiesTestCase {

	public static function stratClass() {
		return 'Pickle\Strategies';
	}

	public function testOnCodeToInterface() {
		$test = Strategies::getInstance();
		$this->assertInstanceOf( 'Pickle\\IStrategies', $test );
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
