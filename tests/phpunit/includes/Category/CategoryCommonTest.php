<?php

namespace Spec\Tests;

use MediaWikiTestCase;
use \Spec\CategoryCommon;

/**
 * @group Spec
 *
 * @covers \Spec\CategoryCommon
 */
class CategoryCommonTest extends CategoryTestCase {

	protected $conf = [
		"class" => "Spec\\CategoryCommon",
		"name" => "test"
	];

	protected function newInstance( $conf ) {
		return new CategoryCommon( $conf );
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
