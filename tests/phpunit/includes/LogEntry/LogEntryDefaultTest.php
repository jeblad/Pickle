<?php

namespace Spec\Tests;

use MediaWikiTestCase;
use \Spec\LogEntryDefault;

/**
 * @group Spec
 *
 * @covers \Spec\LogEntryDefault
 */
class LogEntryDefaultTest extends LogEntryTestCase {

	protected $conf = [
		"class" => "Spec\\LogEntryDefault",
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
					"class" => "Spec\\LogEntryDefault"
				]
			],
			[
				'unknown',
				[
					"class" => "Spec\\LogEntryDefault",
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
					"class" => "Spec\\LogEntryCommon",
					"name" => "foo"
				]
			],
			[
				[
					'type' => 'track',
					'subtype' => 'unknown'
				],
				[
					"class" => "Spec\\LogEntryCommon"
				]
			]
		];
	}
}
