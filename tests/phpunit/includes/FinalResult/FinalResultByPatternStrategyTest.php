<?php

namespace Spec\Tests;

use MediaWikiTestCase;
use \Spec\FinalResultByPatternStrategy;

/**
 * @group Spec
 *
 * @covers \Spec\FinalResultByPatternStrategy
 */
class FinalResultByPatternStrategyTest extends MediaWikiTestCase {

	public function provideOnGetName() {
		// Note that cases are limited to whats interesting
		return [
			[ '', [ 'name' => '' ] ],
			[ 'foo', [ 'name' => 'foo' ] ],
			[ '', [] ]
		];
	}

	/**
	 * @dataProvider provideOnGetName
	 */
	public function testOnGetName( $expect, $actual ) {
		$test = new FinalResultByPatternStrategy( $actual );
		$this->assertTrue( $expect === $test->getName() );
	}

	public function provideFindState() {
		// Note that cases are limited to whats interesting
		return [
			[ 1, [ 'pattern' => '/\bbar\b/' ], 'foo bar baz' ],
			[ 0, [ 'pattern' => '/\bbar\b/' ], '' ],
			[ 0, [ 'pattern' => '/\btest\b/' ], 'foo bar baz' ],
			[ 0, [ 'pattern' => '/^$/' ], 'foo bar baz' ],
			[ 1, [ 'pattern' => '/^$/' ], '' ],
			[ 0, [], 'foo bar baz' ],
			[ 1, [], '' ]
		];
	}

	/**
	 * @dataProvider provideFindState
	 */
	public function testFindState( $expect, $actual, $str ) {
		$test = new FinalResultByPatternStrategy( $actual );
		$this->assertTrue( $expect === $test->findState( $str ) );
	}
}
