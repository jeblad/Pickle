<?php

namespace Spec\Tests;

use MediaWikiTestCase;
use \Spec\IndicatorDefault;

/**
 * @group Spec
 *
 * @covers \Spec\IndicatorDefault
 */
class IndicatorDefaultTest extends IndicatorTestCase {

	protected $conf = [
		"class" => "Spec\\IndicatorDefault",
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
					"class" => "Spec\\IndicatorDefault"
				]
			],
			[
				'unknown',
				[
					"class" => "Spec\\IndicatorDefault",
					"name" => "foo"
				]
			]
		];
	}
}
