<?php

namespace Pickle\Tests;

use MediaWikiTestCase;
use \Pickle\ExtractStatusDefault;

/**
 * @group Pickle
 *
 * @covers \Pickle\ExtractStatusDefault
 */
class ExtractStatusDefaultTest extends MediaWikiTestCase {

	protected $conf = [];

	public function testOnCodeToInterface() {
		$test = new ExtractStatusDefault( $this->conf );
		$this->assertInstanceOf( 'Pickle\\ExtractStatus', $test );
	}

	public function testOnGetName() {
		$test = new ExtractStatusDefault( $this->conf );
		$this->assertEquals( 'unknown', $test->getName() );
	}

	public function provideCheckState() {
		// Note that cases are limited to whats interesting
		return [
			[ true, 'foo bar baz' ],
			[ true, '' ],
		];
	}

	/**
	 * @dataProvider provideCheckState
	 */
	public function testCheckState( $expect, $str ) {
		$test = new ExtractStatusDefault( $this->conf );
		$this->assertSame( $expect, $test->checkState( $str ) );
	}
}
