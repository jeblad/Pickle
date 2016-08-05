<?php

namespace Spec\Tests;

use MediaWikiTestCase;
use \Spec\ExtractStatusByPatternStrategy;

/**
 * @group Spec
 *
 * @covers \Spec\ExtractStatusByPatternStrategy
 */
class ExtractStatusByPatternStrategyTest extends MediaWikiTestCase {

	protected $conf = [
		"class" => "Spec\\ExtractStatusByPatternStrategy",
		"name" => "good",
		"pattern" => "/\\bgood\\b/"
	];

	public function testOnCodeToInterface() {
		$test = new ExtractStatusByPatternStrategy( $this->conf );
		$this->assertInstanceOf( 'Spec\\IExtractStatusStrategy', $test );
	}

	public function testOnGetName() {
		$test = new ExtractStatusByPatternStrategy( $this->conf );
		$this->assertEquals( 'good', $test->getName() );
	}

	public function provideCheckState() {
		// Note that cases are limited to whats interesting
		return [
			[ 1, 'foo bar good baz' ],
			[ 1, 'good' ],
			[ 0, 'foo bar baz' ],
			[ 0, '' ]
		];
	}

	/**
	 * @dataProvider provideCheckState
	 */
	public function testCheckState( $expect, $str ) {
		$test = new ExtractStatusByPatternStrategy( $this->conf );
		$this->assertEquals( $expect, $test->checkState( $str ) );
	}
}
