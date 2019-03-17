<?php

namespace Pickle\Tests;

use \Pickle\CategoryDefault;

/**
 * @group Pickle
 *
 * @covers \Pickle\CategoryDefault
 */
class CategoryDefaultTest extends CategoryTestCase {

	protected $conf = [
		"class" => "Pickle\\CategoryDefault"
	];

	protected function newInstance( $conf ) {
		return new CategoryDefault( $conf );
	}

	public function provideGetName() {
		return [
			[
				'unknown',
				[
					"class" => "Pickle\\CategoryDefault"
				]
			],
			[
				'unknown',
				[
					"class" => "Pickle\\CategoryDefault",
					"name" => "foo",
					"key" => "baz"
				]
			]
		];
	}

	public function provideGetKey() {
		return [
			[
				'pickle-tracking-category-unknown',
				[
					"class" => "Pickle\\CategoryDefault",
					"name" => "foo",
					"key" => "baz"
				]
			],
			[
				'pickle-tracking-category-unknown',
				[
					"class" => "Pickle\\CategoryDefault"
				]
			]
		];
	}
}
