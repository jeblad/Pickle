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

	public function testInit() {
		$testA = Strategies::init();
		$testB = Strategies::init();
		$this->assertEquals( $testA, $testB );
	}

	public function testOnExport() {
		$instance = Strategies::init();
		$this->assertEquals( [], $instance->export() );
	}

	public function testOnImport() {
		$instance = Strategies::init();
		$instance->import( [ 1, 2, 3 ] );
		$this->assertEquals( [ 1, 2, 3 ], $instance->export() );
	}

	public function testOnReset() {
		$instance = Strategies::init();
		$instance->import( [ 1, 2, 3 ] );
		$instance->reset();
		$this->assertEquals( [], $instance->export() );
	}
}
