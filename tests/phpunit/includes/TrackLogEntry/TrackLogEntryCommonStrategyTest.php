<?php

namespace Spec\Tests;

use MediaWikiTestCase;
use \Spec\TrackLogEntryCommonStrategy;

/**
 * @group Spec
 *
 * @covers \Spec\TrackLogEntryStrategy
 */
class TrackLogEntryCommonStrategyTest extends TrackLogEntryStrategyTestCase {

	protected $conf = [
		"class" => "Spec\\TrackLogEntryCommonStrategy",
		"name" => "test"
	];

	protected function newInstance( $conf ) {
		return new TrackLogEntryCommonStrategy( $conf );
	}

	public function provideGetName() {
		return [
			[
				'foo',
				[
					"class" => "Spec\\TrackLogEntryCommonStrategy",
					"name" => "foo"
				]
			],
			[
				'',
				[
					"class" => "Spec\\TrackLogEntryCommonStrategy"
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
					"class" => "Spec\\TrackLogEntryCommonStrategy",
					"name" => "foo"
				]
			],
			[
				[
					'type' => 'track',
					'subtype' => ''
				],
				[
					"class" => "Spec\\TrackLogEntryCommonStrategy"
				]
			]
		];
	}
}
