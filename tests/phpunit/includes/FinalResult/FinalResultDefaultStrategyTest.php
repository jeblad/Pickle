<?php

namespace Spec\Tests;

use MediaWikiTestCase;
use \Spec\FinalResultDefaultStrategy;

/**
 * @group Spec
 *
 * @covers \Spec\FinalResultDefaultStrategy
 */
class FinalResultDefaultStrategyTest extends MediaWikiTestCase {

	public function provideOnGetName() {
		// Note that cases are limited to whats interesting
		return [
			[ '', [ 'name' => '' ] ],
			[ 'foo', [ 'name' => 'foo' ] ],
			[ 'default', [] ]
		];
	}

	/**
	 * @dataProvider provideOnGetName
	 */
	public function testOnGetName( $expect, $actual ) {
		$test = new FinalResultDefaultStrategy( $actual );
		$this->assertTrue( $expect === $test->getName() );
	}

	public function provideCheckState() {
		// Note that cases are limited to whats interesting
		return [
			[ 1, [], 'foo bar baz' ],
			[ 1, [], '' ],
		];
	}

	/**
	 * @dataProvider provideCheckState
	 */
	public function testCheckState( $expect, $actual, $str ) {
		$test = new FinalResultDefaultStrategy( $actual );
		$this->assertTrue( $expect === $test->checkState( $str ) );
	}
}
