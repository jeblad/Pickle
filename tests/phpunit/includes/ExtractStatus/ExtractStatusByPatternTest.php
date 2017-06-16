<?php

namespace Pickle\Tests;

use MediaWikiTestCase;
use \Pickle\ExtractStatusByPattern;

/**
 * @group Pickle
 *
 * @covers \Pickle\ExtractStatusByPattern
 */
class ExtractStatusByPatternTest extends MediaWikiTestCase {

	protected $conf = [
		"class" => "Pickle\\ExtractStatusByPattern",
		"name" => "good",
		"pattern" => "/\\bgood\\b/"
	];

	public function testOnCodeToInterface() {
		$test = new ExtractStatusByPattern( $this->conf );
		$this->assertInstanceOf( 'Pickle\\ExtractStatus', $test );
	}

	public function testOnGetName() {
		$test = new ExtractStatusByPattern( $this->conf );
		$this->assertEquals( 'good', $test->getName() );
	}

	public function provideCheckState() {
		// Note that cases are limited to whats interesting
		return [
			[ true, 'foo bar good baz' ],
			[ true, 'good' ],
			[ false, 'foo bar baz' ],
			[ false, '' ]
		];
	}

	/**
	 * @dataProvider provideCheckState
	 */
	public function testCheckState( $expect, $str ) {
		$test = new ExtractStatusByPattern( $this->conf );
		$this->assertSame( $expect, $test->checkState( $str ) );
	}
}
