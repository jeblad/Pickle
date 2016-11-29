<?php

namespace Spec\Tests;

use MediaWikiTestCase;
use \Spec\ExtractStatusDefault;

/**
 * @group Spec
 *
 * @covers \Spec\ExtractStatusDefault
 */
class ExtractStatusDefaultTest extends MediaWikiTestCase {

	protected $conf = [];

	public function testOnCodeToInterface() {
		$test = new ExtractStatusDefault( $this->conf );
		$this->assertInstanceOf( 'Spec\\AExtractStatus', $test );
	}

	public function testOnGetName() {
		$test = new ExtractStatusDefault( $this->conf );
		$this->assertEquals( 'unknown', $test->getName() );
	}

	public function provideCheckState() {
		// Note that cases are limited to whats interesting
		return [
			[ 1, 'foo bar baz' ],
			[ 1, '' ],
		];
	}

	/**
	 * @dataProvider provideCheckState
	 */
	public function testCheckState( $expect, $str ) {
		$test = new ExtractStatusDefault( $this->conf );
		$this->assertEquals( 1, $test->checkState( $str ) );
	}
}
