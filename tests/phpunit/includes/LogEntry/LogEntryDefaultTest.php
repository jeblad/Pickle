<?php

namespace Pickle\Tests;

use \Pickle\LogEntryDefault;

/**
 * @group Pickle
 *
 * @covers \Pickle\LogEntryDefault
 */
class LogEntryDefaultTest extends LogEntryTestCase {

	protected $conf = [
		"class" => "Pickle\\LogEntryDefault",
		"name" => "test"
	];

	protected function newInstance( $conf ) {
		return new LogEntryDefault( $conf );
	}

	public function provideGetName() {
		return [
			[
				'unknown',
				[
					"class" => "Pickle\\LogEntryDefault"
				]
			],
			[
				'unknown',
				[
					"class" => "Pickle\\LogEntryDefault",
					"name" => "foo"
				]
			]
		];
	}

	public function provideNewLogEntry() {
		return [
			[
				[
					'type' => 'track',
					'subtype' => 'unknown'
				],
				[
					"class" => "Pickle\\LogEntryDefault",
					"name" => "foo"
				]
			],
			[
				[
					'type' => 'track',
					'subtype' => 'unknown'
				],
				[
					"class" => "Pickle\\LogEntryDefault"
				]
			]
		];
	}
}
