<?php

namespace Spec\Tests;

use MediaWikiTestCase;
use \Spec\TrackLogEntryDefaultStrategy;

/**
 * @group Spec
 *
 * @covers \Spec\TrackLogEntryDefaultStrategy
 */
class TrackLogEntryDefaultStrategyTest extends TrackLogEntryStrategyTestCase {

	protected $conf = [
		"class" => "Spec\\TrackLogEntryDefaultStrategy",
		"name" => "test"
	];

	protected function newInstance( $conf ) {
		return new TrackLogEntryDefaultStrategy( $conf );
	}

	public function provideGetName() {
		return [
			[
				'unknown',
				[
					"class" => "Spec\\TrackLogEntryDefaultStrategy"
				]
			],
			[
				'unknown',
				[
					"class" => "Spec\\TrackLogEntryDefaultStrategy",
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
					"class" => "Spec\\TrackLogEntryCommonStrategy",
					"name" => "foo"
				]
			],
			[
				[
					'type' => 'track',
					'subtype' => 'unknown'
				],
				[
					"class" => "Spec\\TrackLogEntryCommonStrategy"
				]
			]
		];
	}
}
