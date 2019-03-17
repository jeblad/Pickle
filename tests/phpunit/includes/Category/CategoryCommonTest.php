<?php

namespace Pickle\Tests;

use \Pickle\CategoryCommon;

/**
 * @group Pickle
 *
 * @covers \Pickle\CategoryCommon
 */
class CategoryCommonTest extends CategoryTestCase {

	protected $conf = [
		"class" => "Pickle\\CategoryCommon",
		"name" => "test",
		"key" => "baz"
	];

	protected function newInstance( $conf ) {
		return new CategoryCommon( $conf );
	}

	public function provideGetName() {
		return [
			[
				'foo',
				[
					"class" => "Pickle\\CategoryCommon",
					"name" => "foo",
					"key" => "baz"
				]
			],
			[
				'none',
				[
					"class" => "Pickle\\CategoryCommon"
				]
			]
		];
	}

	public function provideGetKey() {
		return [
			[
				'pickle-tracking-category-baz',
				[
					"class" => "Pickle\\CategoryCommon",
					"name" => "foo",
					"key" => "baz"
				]
			],
			[
				'pickle-tracking-category-unknown',
				[
					"class" => "Pickle\\CategoryCommon"
				]
			]
		];
	}
}
