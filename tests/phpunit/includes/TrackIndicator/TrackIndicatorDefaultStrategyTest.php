<?php

namespace Spec\Tests;

use MediaWikiTestCase;
use \Spec\TrackIndicatorDefaultStrategy;

/**
 * @group Spec
 *
 * @covers \Spec\TrackIndicatorDefaultStrategy
 */
class TrackIndicatorDefaultStrategyTest extends TrackIndicatorStrategyTestCase {

	protected $conf = [
		"class" => "Spec\\TrackIndicatorDefaultStrategy",
		"name" => "test"
	];

	protected function newInstance( $conf ) {
		return new TrackIndicatorDefaultStrategy( $conf );
	}

	public function provideGetName() {
		return [
			[
				'unknown',
				[
					"class" => "Spec\\TrackIndicatorDefaultStrategy"
				]
			],
			[
				'unknown',
				[
					"class" => "Spec\\TrackIndicatorDefaultStrategy",
					"name" => "foo"
				]
			]
		];
	}
}
