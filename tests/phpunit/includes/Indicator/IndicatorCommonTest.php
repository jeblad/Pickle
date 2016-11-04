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
		"class" => "Spec\\Indicatory",
		"name" => "good"
	];

	protected function newInstance( $conf ) {
		return new IndicatorCommon( $conf );
	}

	public function provideGetName() {
		return [
			[
				'foo',
				[
					"class" => "Spec\\CategoryCommon",
					"name" => "foo"
				]
			],
			[
				'',
				[
					"class" => "Spec\\CategoryCommon"
				]
			]
		];
	}
}
