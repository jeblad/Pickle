<?php

namespace Spec\Tests;

use \Spec\Singletons;

/**
 * @group Spec
 *
 * @covers \Spec\Singletons
 */
class SingletonsTest extends SingletonsTestCase {

	public static function stratClass() {
		return 'Spec\Singletons';
	}

	public function testOnCodeToInterface() {
		$test = Singletons::getInstance();
		$this->assertInstanceOf( 'Spec\\ISingletons', $test );
	}

	public function testInit() {
		$testA = Singletons::getInstance();
		$testB = Singletons::getInstance();
		$this->assertEquals( $testA, $testB );
	}

	public function testOnExport() {
		$instance = Singletons::getInstance();
		$this->assertEquals( [], $instance->export() );
	}

	public function testOnImport() {
		$instance = Singletons::getInstance();
		$instance->import( [ 1, 2, 3 ] );
		$this->assertEquals( [ 1, 2, 3 ], $instance->export() );
	}

	public function testOnReset() {
		$instance = Singletons::getInstance();
		$instance->import( [ 1, 2, 3 ] );
		$instance->reset();
		$this->assertEquals( [], $instance->export() );
	}
}
