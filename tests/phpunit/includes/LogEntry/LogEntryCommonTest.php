<?php

namespace Pickle\Tests;

use \Pickle\LogEntryCommon;

/**
 * @group Pickle
 *
 * @covers \Pickle\LogEntryCommon
 */
class LogEntryCommonTest extends LogEntryTestCase {

	protected $conf = [
		"class" => "Pickle\\LogEntryCommon",
		"name" => "test"
	];

	protected function newInstance( $conf ) {
		return new LogEntryCommon( $conf );
	}

	public function provideGetName() {
		return [
			[
				'foo',
				[
					"class" => "Pickle\\LogEntryCommon",
					"name" => "foo"
				]
			],
			[
				'none',
				[
					"class" => "Pickle\\LogEntryCommon"
				]
			]
		];
	}

	public function provideNewLogEntry() {
		return [
			[
				[
					'type' => 'track',
					'subtype' => 'foo'
				],
				[
					"class" => "Pickle\\LogEntryCommon",
					"name" => "foo"
				]
			],
			[
				[
					'type' => 'track',
					'subtype' => 'none'
				],
				[
					"class" => "Pickle\\LogEntryCommon"
				]
			]
		];
	}
}
