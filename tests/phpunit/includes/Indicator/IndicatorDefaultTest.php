<?php

namespace Pickle\Tests;

use \Pickle\IndicatorDefault;

/**
 * @group Pickle
 *
 * @covers \Pickle\IndicatorDefault
 */
class IndicatorDefaultTest extends IndicatorTestCase {

	protected $conf = [
		"class" => "Pickle\\IndicatorDefault",
		"name" => "test",
		"icon" => "bar"
	];

	protected function newInstance( $conf ) {
		return new IndicatorDefault( $conf );
	}

	public function provideGetName() {
		return [
			[
				'unknown',
				[
					"class" => "Pickle\\IndicatorDefault"
				]
			],
			[
				'unknown',
				[
					"class" => "Pickle\\IndicatorDefault",
					"name" => "foo"
				]
			]
		];
	}
}
