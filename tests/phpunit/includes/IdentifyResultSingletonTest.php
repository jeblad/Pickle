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

	protected $stuff = [];

	public function tearDown() {
		parent::tearDown();
		foreach ( $this->stuff as $thing ) {
			$thing->reset();
		}
		$this->stuff = [];
	}

	public function keepForTearDown( $thing ) {
		$this->stuff[] = $thing;
	}

	public function testInit() {
		$testA = IdentifyResultSingleton::init();
		$this->keepForTearDown( $testA );
		$testB = IdentifyResultSingleton::init();
		$this->keepForTearDown( $testB );
		$this->assertTrue( $testA === $testB );
	}

	public function testRegisterStrategy() {
		$struct = [ 'class' => 'Spec\\IdentifyResultByPatternStrategy' ];
		$test = IdentifyResultSingleton::init();
		$this->keepForTearDown( $test );
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
		$this->keepForTearDown( $test );
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
