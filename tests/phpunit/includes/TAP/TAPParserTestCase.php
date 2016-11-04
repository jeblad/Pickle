<?php

namespace Spec\Tests;

abstract class TAPParserTestCase extends \MediaWikiTestCase {

	abstract protected function newInstance( $conf );

	/**
	 * @dataProvider provideGetName
	 */
	public function testOnGetName( $expect, $conf ) {
		$test = $this->newInstance( $conf );
		$this->assertNotNull( $test );

		$this->assertEquals( $expect, $test->getName() );
	}

	public function testOnCodeToInterface() {
		$test = $this->newInstance( $this->conf );
		$this->assertInstanceOf( 'Spec\\ITAPParser', $test );
	}

	public function providerForVersionAndCount() {
		return [
			[ false, false, 'foo' ],
			[ 13, false, 'TAP version 13' ],
			[ false, 2, '1..2' ],
			[ 13, 2, "TAP version 13\n1..2" ]
		];
	}

	/**
	 * @dataProvider providerForVersionAndCount
	 */
	public function testOnVersion( $version, $count, $str ) {
		$test = $this->newInstance( $this->conf );
		$this->assertEquals( $version, $test->getVersion( $str ) );
	}

	/**
	 * @dataProvider providerForVersionAndCount
	 */
	public function testOnCount( $version, $count, $str ) {
		$test = $this->newInstance( $this->conf );
		$this->assertEquals( $count, $test->getCount( $str ) );
	}

	public function providerForChecks() {
		return [
			[ [ false, false, false, false, false, false, false ], "foo\nbar" ],                //  0
			[ [ false, false, false, false, false, false, false ], 'TAP version 13' ],          //  1
			[ [ false, false, false, false, false, false, false ], '1..2' ],                    //  2
			[ [ false, false, false, false, false, false, false ], "TAP version 13\n1..2" ],    //  3
			[ [ true, false, false, false, false, false, false ], "ok" ],                       //  4
			[ [ true, false, false, false, false, false, false ], "ok and some text" ],         //  5
			[ [ false, true, false, false, false, false, false ], "not ok" ],                   //  6
			[ [ false, true, false, false, false, false, false ], "not ok and some text" ],     //  7
			[ [ false, true, false, false, 1, false, false ], "not ok 1" ],                     //  8
			[ [ false, true, false, false, 2, false, false ], "not ok 2 and some text" ],       //  9
			[ [ true, false, true, false, false, false, false ], "ok # SKIPPED" ],              // 10
			[ [ true, false, true, false, false, false, false ], "ok # SKIPPED and some text" ],// 11
			[ [ true, false, false, true, false, false, false ], "ok # TODO" ],                 // 12
			[ [ true, false, false, true, false, false, false ], "ok # TODO and some text" ],   // 13
			[ [ false, false, false, false, false, false, true ], " ok" ],                     // 14
			[ [ false, false, false, false, false, true, false ], "#ok" ]                      // 15
		];
	}

	/**
	 * @dataProvider providerForChecks
	 */
	public function testOnChecks( $expect, $str ) {
		$test = $this->newInstance( $this->conf );
		$this->assertEquals( $expect[0], $test->isOk( $str ) );
		$this->assertEquals( $expect[1], $test->isNotOk( $str ) );
		$this->assertEquals( $expect[2], $test->isSkip( $str ) );
		$this->assertEquals( $expect[3], $test->isTodo( $str ) );
		$this->assertEquals( $expect[4], $test->isIndex( $str ) );
		$this->assertEquals( $expect[5], $test->isComment( $str ) );
		$this->assertEquals( $expect[6], $test->isText( $str ) );
	}

}
