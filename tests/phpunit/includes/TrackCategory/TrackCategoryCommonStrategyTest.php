<?php

namespace Spec\Tests;

use MediaWikiTestCase;
use \Spec\TrackCategoryCommonStrategy;

/**
 * @group Spec
 *
 * @covers \Spec\TrackCategoryCommonStrategy
 */
class TrackCategoryCommonStrategyTest extends TrackCategoryStrategyTestCase {

	protected $conf = [
		"class" => "Spec\\TrackCategoryCommonStrategy",
		"name" => "test"
	];

	protected function newInstance( $conf ) {
		return new TrackCategoryCommonStrategy( $conf );
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
