<?php

namespace Pickle\Tests;

use \Pickle\TAPCommonParser;

/**
 * @group Pickle
 *
 * @covers \Pickle\TAPCommonParser
 */
class TAPCommonParserTest extends TAPParserTestCase {

	protected $conf = [
		"class" => "Pickle\\TAPCommonParser",
		"name" => "test"
	];

	protected function newInstance( $conf ) {
		return new TAPCommonParser( $conf );
	}

	public function provideGetName() {
		return [
			[
				'foo',
				[
					"class" => "Pickle\\TAPCommonParser",
					"name" => "foo"
				]
			],
			[
				'tap',
				[
					"class" => "Pickle\\TAPCommonParser"
				]
			]
		];
	}

	public function providerForStats() {
		return [
			[
				[
					[ 2, 0, 0 ],
					[ 2, 0, 1 ]
				],
				"1..4\n"
				. "ok 1 - Input file opened\n"
				. "not ok 2 - First line of the input valid\n"
				. "ok 3 - Read the rest of the file\n"
				. "not ok 4 - Summarized correctly # TODO Not written yet"
			]
		];
	}

	/**
	 * @dataProvider providerForStats
	 */
	public function testOnStats( $expect, $str ) {
		$test = $this->newInstance( $this->conf );
		$this->assertEquals( $expect, $test->stats( $str ) );
	}

	public function provideValidExamples() {
		return [
			[ 'bad', false, "ok 1 - test\n" ],
			[ 'unknown', false, "ok 1 - test #todo\n" ],
			[ 'bad', true, "1..2\nok 1 - test\n" ],
			[ 'bad', true, "1..1\nok 1 - test\n" ],
			[ 'good', true, "1..1\nnot ok 1 - test\n" ],
			[ 'todo', true, "1..1\nnot ok 1 - #todo\n" ],
			[ 'skipped', true, "1..1\nnot ok 1 - #skipped\n" ]
		];
	}

	/**
	 * @todo something strange here
	 * @ dataProvider provideValidExamples
	 */
	public function parse( $type, $valid, $str ) {
		$test = $this->newInstance( $this->conf );
		$this->assertEquals( $type, $test->parse( $str ) );
	}

	/**
	 * @dataProvider provideValidExamples
	 */
	public function testOnCheckValid( $result, $valid, $str ) {
		$test = $this->newInstance( $this->conf );
		$this->assertEquals( $valid, $test->checkValid( $str ) );
	}
}
