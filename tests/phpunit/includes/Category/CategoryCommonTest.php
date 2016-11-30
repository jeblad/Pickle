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
					"class" => "Spec\\CategoryCommon",
					"name" => "foo",
					"key" => "baz"
				]
			],
			[
				'none',
				[
					"class" => "Spec\\CategoryCommon"
				]
			]
		];
	}

	public function provideGetKey() {
		return [
			[
				'spec-tracking-category-baz',
				[
					"class" => "Spec\\CategoryCommon",
					"name" => "foo",
					"key" => "baz"
				]
			],
			[
				'spec-tracking-category-unknown',
				[
					"class" => "Spec\\CategoryCommon"
				]
			]
		];
	}
}
