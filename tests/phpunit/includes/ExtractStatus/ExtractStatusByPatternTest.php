<?php

namespace Spec\Tests;

use MediaWikiTestCase;
use \Spec\ExtractStatusByPattern;

/**
 * @group Spec
 *
 * @covers \Spec\ExtractStatusByPattern
 */
class ExtractStatusByPatternTest extends MediaWikiTestCase {

	protected $conf = [
		"class" => "Spec\\ExtractStatusByPattern",
		"name" => "good",
		"pattern" => "/\\bgood\\b/"
	];

	public function testOnCodeToInterface() {
		$test = new ExtractStatusByPattern( $this->conf );
		$this->assertInstanceOf( 'Spec\\AExtractStatus', $test );
	}

	public function testOnGetName() {
		$test = new ExtractStatusByPattern( $this->conf );
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
		$test = new ExtractStatusByPattern( $this->conf );
		$this->assertEquals( $expect, $test->checkState( $str ) );
	}
}
