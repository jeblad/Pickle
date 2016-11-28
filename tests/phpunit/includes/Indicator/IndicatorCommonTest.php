<?php

namespace Spec\Tests;

use MediaWikiTestCase;
use \Spec\IndicatorCommon;

/**
 * @group Spec
 *
 * @covers \Spec\IndicatorCommon
 */
class IndicatorCommonTest extends IndicatorTestCase {

	protected $conf = [
		"class" => "Spec\\IndicatorCommon",
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
					"class" => "Spec\\IndicatorCommon",
					"name" => "foo"
				]
			],
			[
				'',
				[
					"class" => "Spec\\IndicatorCommon"
				]
			]
		];
	}
}
