<?php

namespace Spec\Tests;

use MediaWikiTestCase;
use \Spec\TrackCategoryDefaultStrategy;

/**
 * @group Spec
 *
 * @covers \Spec\TrackCategoryDefaultStrategy
 */
class TrackCategoryDefaultStrategyTest extends TrackCategoryStrategyTestCase {

	protected $conf = [
		"class" => "Spec\\TrackCategoryDefaultStrategy"
	];

	protected function newInstance( $conf ) {
		return new TrackCategoryDefaultStrategy( $conf );
	}

	public function provideGetName() {
		return [
			[
				'unknown',
				[
					"class" => "Spec\\TrackCategoryDefaultStrategy"
				]
			],
			[
				'unknown',
				[
					"class" => "Spec\\TrackCategoryDefaultStrategy",
					"name" => "foo"
				]
			]
		];
	}
}
