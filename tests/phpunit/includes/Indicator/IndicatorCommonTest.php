<?php

namespace Pickle\Tests;

use \Pickle\IndicatorCommon;

/**
 * @group Pickle
 *
 * @covers \Pickle\IndicatorCommon
 */
class IndicatorCommonTest extends IndicatorTestCase {

	protected $conf = [
		"class" => "Pickle\\IndicatorCommon",
		"name" => "good",
		"icon" => "bar"
	];

	protected function newInstance( $conf ) {
		return new IndicatorCommon( $conf );
	}

	public function provideGetName() {
		return [
			[
				'foo',
				[
					"class" => "Pickle\\IndicatorCommon",
					"name" => "foo"
				]
			],
			[
				'none',
				[
					"class" => "Pickle\\IndicatorCommon"
				]
			]
		];
	}
}
