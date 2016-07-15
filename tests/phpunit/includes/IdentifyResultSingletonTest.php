<?php

namespace Spec\Tests;

use MediaWikiTestCase;
use \Spec\IdentifyResultSingleton;

/**
 * @group Spec
 *
 * @covers \Spec\IdentifyResultSingleton
 */
class IdentifyResultSingletonTest extends MediaWikiTestCase {

	protected $stuff = null;

	public function setUp() {
		parent::setUp();
		$thingy = IdentifyResultSingleton::init();
		$this->stuff = $thingy->strategies();
		$thingy->reset();
	}

	public function tearDown() {
		$thingy = IdentifyResultSingleton::init();
		$thingy->strategies( $this->stuff );
		parent::tearDown();
	}

	public function testInit() {
		$testA = IdentifyResultSingleton::init();
		$testB = IdentifyResultSingleton::init();
		$this->assertTrue( $testA === $testB );
	}

	public function testRegisterStrategy() {
		$struct = [ 'class' => 'Spec\\IdentifyResultByPatternStrategy' ];
		$test = IdentifyResultSingleton::init();
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
		$test = IdentifyResultSingleton::init();
		$test->registerStrategy(
			[
				'class' => 'Spec\\IdentifyResultByPatternStrategy',
				'name' => 'ping',
				'pattern' => '/\bfoo\b/'
			]
		);
		$test->registerStrategy(
			[
				'class' => 'Spec\\IdentifyResultByPatternStrategy',
				'name' => 'pong',
				'pattern' => '/\bbar\b/'
			]
		);
		$this->assertTrue( $expect === $test->findState( $str ) );
	}
}
