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

	public function testWho() {
		$test = ExtractStatusStrategies::who();
		$this->assertEquals( 'Spec\ExtractStatusStrategies', $test );
	}

	public function testInit() {
		$testA = ExtractStatusStrategies::init();
		$testB = ExtractStatusStrategies::init();
		$this->assertEquals( ExtractStatusStrategies::who(), get_class( $testA ) );
		$this->assertEquals( $testA, $testB );
	}

	public function testRegisterStrategy() {
		$struct = [ 'class' => 'Spec\\ExtractStatusByPatternStrategy' ];
		$test = ExtractStatusStrategies::init();
		$instance = $test->registerStrategy( $struct );
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
		$test = ExtractStatusStrategies::init();
		$test->registerStrategy(
			[
				'class' => 'Spec\ExtractStatusByPatternStrategy',
				'name' => 'ping',
				'pattern' => '/\bfoo\b/'
			]
		);
		$test->registerStrategy(
			[
				'class' => 'Spec\ExtractStatusByPatternStrategy',
				'name' => 'pong',
				'pattern' => '/\bbar\b/'
			]
		);
		$strategy = $test->find( $str );
		$this->assertEquals( $expect,
			method_exists( $strategy, 'getName' ) ? $strategy->getName() : $strategy );
	}
}
