<?php

namespace Pickle\Tests;

abstract class TAPParserTestCase extends \MediaWikiTestCase {

	/**
	 * @param any $conf for general configuration
	 */
	abstract protected function newInstance( $conf );

	/**
	 * @dataProvider provideGetName
	 * @param any $expect to get this
	 * @param any $conf for this
	 */
	public function testOnGetName( $expect, $conf ) {
		$test = $this->newInstance( $conf );
		$this->assertNotNull( $test );

		$this->assertEquals( $expect, $test->getName() );
	}

	/**
	 */
	public function testOnCodeToInterface() {
		$test = $this->newInstance( $this->conf );
		$this->assertNotNull( $test );

		$this->assertInstanceOf( 'Pickle\\ATAPParser', $test );
	}

	/**
	 * @return provided data
	 */
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
	 * @param any $version to expect
	 * @param any $count for configuration
	 * @param any $str for configuration
	 */
	public function testOnVersion( $version, $count, $str ) {
		$test = $this->newInstance( $this->conf );
		$this->assertNotNull( $test );

		$this->assertEquals( $version, $test->getVersion( $str ) );
	}

	/**
	 * @dataProvider providerForVersionAndCount
	 * @param any $version to expect
	 * @param any $count for configuration
	 * @param any $str for configuration
	 */
	public function testOnCount( $version, $count, $str ) {
		$test = $this->newInstance( $this->conf );
		$this->assertNotNull( $test );

		$this->assertEquals( $count, $test->getCount( $str ) );
	}

	/**
	 * @return provided data
	 */
	public function providerForChecks() {
		return [
			// 0
			[ [ false, false, false, false, false, false, false ], "foo\nbar" ],
			// 1
			[ [ false, false, false, false, false, false, false ], 'TAP version 13' ],
			// 2
			[ [ false, false, false, false, false, false, false ], '1..2' ],
			// 3
			[ [ false, false, false, false, false, false, false ], "TAP version 13\n1..2" ],
			// 4
			[ [ true, false, false, false, false, false, false ], "ok" ],
			// 5
			[ [ true, false, false, false, false, false, false ], "ok and some text" ],
			// 6
			[ [ false, true, false, false, false, false, false ], "not ok" ],
			// 7
			[ [ false, true, false, false, false, false, false ], "not ok and some text" ],
			// 8
			[ [ false, true, false, false, 1, false, false ], "not ok 1" ],
			// 9
			[ [ false, true, false, false, 2, false, false ], "not ok 2 and some text" ],
			// 10
			[ [ true, false, true, false, false, false, false ], "ok # SKIPPED" ],
			// 11
			[ [ true, false, true, false, false, false, false ], "ok # SKIPPED and some text" ],
			// 12
			[ [ true, false, false, true, false, false, false ], "ok # TODO" ],
			// 13
			[ [ true, false, false, true, false, false, false ], "ok # TODO and some text" ],
			// 14
			[ [ false, false, false, false, false, false, true ], " ok" ],
			// 15
			[ [ false, false, false, false, false, true, false ], "#ok" ]
		];
	}

	/**
	 * @dataProvider providerForChecks
	 * @param any $expect to get this
	 * @param any $str for configuration
	 */
	public function testOnChecks( $expect, $str ) {
		$test = $this->newInstance( $this->conf );
		$this->assertNotNull( $test );

		$this->assertEquals( $expect[0], $test->isOk( $str ) );
		$this->assertEquals( $expect[1], $test->isNotOk( $str ) );
		$this->assertEquals( $expect[2], $test->isSkip( $str ) );
		$this->assertEquals( $expect[3], $test->isTodo( $str ) );
		$this->assertEquals( $expect[4], $test->isIndex( $str ) );
		$this->assertEquals( $expect[5], $test->isComment( $str ) );
		$this->assertEquals( $expect[6], $test->isText( $str ) );
	}

}
