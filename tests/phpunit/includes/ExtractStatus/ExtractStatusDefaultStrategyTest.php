<?php

namespace Spec\Tests;

use MediaWikiTestCase;
use \Spec\ExtractStatusDefaultStrategy;

/**
 * @group Spec
 *
 * @covers \Spec\ExtractStatusDefaultStrategy
 */
class ExtractStatusDefaultStrategyTest extends MediaWikiTestCase {

	protected $conf = [];

	public function testOnCodeToInterface() {
		$test = new ExtractStatusDefaultStrategy( $this->conf );
		$this->assertInstanceOf( 'Spec\\IExtractStatusStrategy', $test );
	}

	public function testOnGetName() {
		$test = new ExtractStatusDefaultStrategy( $this->conf );
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
		$test = new ExtractStatusDefaultStrategy( $this->conf );
		$this->assertEquals( 1, $test->checkState( $str ) );
	}
}
