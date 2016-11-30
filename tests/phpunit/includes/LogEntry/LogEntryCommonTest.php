<?php

namespace Spec\Tests;

use MediaWikiTestCase;
use \Spec\LogEntryCommon;

/**
 * @group Spec
 *
 * @covers \Spec\LogEntryCommon
 */
class LogEntryCommonTest extends LogEntryTestCase {

	protected $conf = [
		"class" => "Spec\\LogEntryCommon",
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
					"class" => "Spec\\LogEntryCommon",
					"name" => "foo"
				]
			],
			[
				'none',
				[
					"class" => "Spec\\LogEntryCommon"
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
					"class" => "Spec\\LogEntryCommon",
					"name" => "foo"
				]
			],
			[
				[
					'type' => 'track',
					'subtype' => 'none'
				],
				[
					"class" => "Spec\\LogEntryCommon"
				]
			]
		];
	}
}
