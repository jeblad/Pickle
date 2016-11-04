<?php

namespace Spec\Tests;

use MediaWikiTestCase;
use \Spec\TrackLogEntryStrategies;

/**
 * @group Spec
 *
 * @covers \Spec\TrackLogEntryStrategies
 */
class TrackLogEntryStrategiesTest extends StrategiesTestCase {

	public static function stratClass() {
		return 'Spec\TrackLogEntryStrategies';
	}

	public function testOnCodeToInterface() {
		$test = TrackLogEntryStrategies::getInstance();
		$this->assertInstanceOf( 'Spec\\IStrategies', $test );
	}

	public function testWho() {
		$test = TrackLogEntryStrategies::who();
		$this->assertEquals( 'Spec\TrackLogEntryStrategies', $test );
	}

	public function testInit() {
		$testA = TrackLogEntryStrategies::getInstance();
		$testB = TrackLogEntryStrategies::getInstance();
		$this->assertEquals( TrackLogEntryStrategies::who(), get_class( $testA ) );
		$this->assertEquals( $testA, $testB );
	}

	public function testRegister() {
		$struct = [ 'class' => 'Spec\TrackLogEntryCommonStrategy' ];
		$test = TrackLogEntryStrategies::getInstance();
		$instance = $test->register( $struct );
		$this->assertEquals( get_class( $instance ), $struct['class'] );
	}

	public function provideFind() {
		return [
			[ 'Spec\TrackLogEntryCommonStrategy', 'foo' ],
			[ 'Spec\TrackLogEntryDefaultStrategy', 'bar' ]
		];
	}

	/**
	 * @dataProvider provideFind
	 */
	public function testFind( $expect, $name ) {

		$title = $this->getMockBuilder( '\Title' )
			->getMock();

		$test = TrackLogEntryStrategies::getInstance();
		$test->register(
			[
				'class' => 'Spec\TrackLogEntryCommonStrategy',
				'name' => 'foo'
			]
		);
		$test->register(
			[
				'class' => 'Spec\TrackLogEntryDefaultStrategy'
			]
		);
		$Strategy = $test->find( $name );
		$this->assertEquals( $expect, get_class( $Strategy ) );
	}
}
