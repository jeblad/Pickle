<?php

namespace Spec\Tests;

use MediaWikiTestCase;
use \Spec\TrackIndicatorCommonStrategy;

/**
 * @group Spec
 *
 * @covers \Spec\TrackIndicatorCommonStrategy
 */
class TrackIndicatorCommonStrategyTest extends TrackIndicatorStrategyTestCase {

	protected $conf = [
		"class" => "Spec\\TrackIndicatorStrategy",
		"name" => "good"
	];

	protected function newInstance( $conf ) {
		return new TrackIndicatorCommonStrategy( $conf );
	}

	public function provideGetName() {
		return [
			[
				'foo',
				[
					"class" => "Spec\\TrackCategoryCommonStrategy",
					"name" => "foo"
				]
			],
			[
				'',
				[
					"class" => "Spec\\TrackCategoryCommonStrategy"
				]
			]
		];
	}
}
