<?php

namespace Spec\Tests;

use MediaWikiTestCase;
use \Spec\FinalResultSingleton;

/**
 * @group Spec
 *
 * @covers \Spec\FinalResultSingleton
 */
class FinalResultSingletonTest extends MediaWikiTestCase {

	protected $stuff = null;

	public function setUp() {
		parent::setUp();
		$thingy = FinalResultSingleton::init();
		$this->stuff = $thingy->strategies();
		$thingy->reset();
	}

	public function tearDown() {
		$thingy = FinalResultSingleton::init();
		$thingy->strategies( $this->stuff );
		parent::tearDown();
	}

	public function testInit() {
		$testA = FinalResultSingleton::init();
		$testB = FinalResultSingleton::init();
		$this->assertTrue( $testA === $testB );
	}

	public function testRegisterStrategy() {
		$struct = [ 'class' => 'Spec\\FinalResultByPatternStrategy' ];
		$test = FinalResultSingleton::init();
		$instance = $test->registerStrategy( $struct );
		$this->assertTrue( get_class( $instance ) === $struct['class'] );
	}

	public function provideFindState() {
		return [
			[ 'ping', 'foo bar baz' ],
			[ 'ping', 'baz foo bar' ],
			[ 'ping', 'bar baz foo' ],
			[ 'pong', 'baz bar' ],
			[ 'pong', 'bar baz' ],
			[ null, 'baz' ],
			[ null, '' ] // why?
		];
	}

	/**
	 * @dataProvider provideFindState
	 */
	public function testFindState( $expect, $str ) {
		$test = FinalResultSingleton::init();
		$test->registerStrategy(
			[
				'class' => 'Spec\\FinalResultByPatternStrategy',
				'name' => 'ping',
				'pattern' => '/\bfoo\b/'
			]
		);
		$test->registerStrategy(
			[
				'class' => 'Spec\\FinalResultByPatternStrategy',
				'name' => 'pong',
				'pattern' => '/\bbar\b/'
			]
		);
		$this->assertTrue( $expect === $test->findState( $str ) );
	}
}
