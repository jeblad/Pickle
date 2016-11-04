<?php

namespace Spec\Tests;

use MediaWikiTestCase;
use \Spec\ExtractStatusStrategies;

/**
 * @group Spec
 *
 * @covers \Spec\ExtractStatusStrategies
 */
class ExtractStatusStrategiesTest extends StrategiesTestCase {

	public static function stratClass() {
		return 'Spec\ExtractStatusStrategies';
	}

	public function testOnCodeToInterface() {
		$test = ExtractStatusStrategies::getInstance();
		$this->assertInstanceOf( 'Spec\\IStrategies', $test );
	}

	public function testWho() {
		$test = ExtractStatusStrategies::who();
		$this->assertEquals( 'Spec\ExtractStatusStrategies', $test );
	}

	public function testInit() {
		$testA = ExtractStatusStrategies::getInstance();
		$testB = ExtractStatusStrategies::getInstance();
		$this->assertEquals( ExtractStatusStrategies::who(), get_class( $testA ) );
		$this->assertEquals( $testA, $testB );
	}

	public function testRegister() {
		$struct = [ 'class' => 'Spec\ExtractStatusByPattern' ];
		$test = ExtractStatusStrategies::getInstance();
		$instance = $test->register( $struct );
		$this->assertEquals( get_class( $instance ), $struct['class'] );
	}

	public function provideFindState() {
		return [
			[ 'ping', 'foo bar baz' ],
			[ 'ping', 'baz foo bar' ],
			[ 'ping', 'bar baz foo' ],
			[ 'pong', 'baz bar' ],
			[ 'pong', 'bar baz' ],
			[ null, 'baz' ],
			[ null, '' ]
		];
	}

	/**
	 * @dataProvider provideFindState
	 */
	public function testFindState( $expect, $str ) {
		$test = ExtractStatusStrategies::getInstance();
		$test->register(
			[
				'class' => 'Spec\ExtractStatusByPattern',
				'name' => 'ping',
				'pattern' => '/\bfoo\b/'
			]
		);
		$test->register(
			[
				'class' => 'Spec\ExtractStatusByPattern',
				'name' => 'pong',
				'pattern' => '/\bbar\b/'
			]
		);
		$strategy = $test->find( $str );
		$this->assertEquals( $expect,
			method_exists( $strategy, 'getName' ) ? $strategy->getName() : $strategy );
	}
}
