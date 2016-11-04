<?php

namespace Spec\Tests;

use MediaWikiTestCase;
use \Spec\CategoryDefault;

/**
 * @group Spec
 *
 * @covers \Spec\CategoryDefault
 */
class CategoryDefaultTest extends CategoryTestCase {

	protected $conf = [
		"class" => "Spec\\CategoryDefault"
	];

	protected function newInstance( $conf ) {
		return new CategoryDefault( $conf );
	}

	public function provideGetName() {
		return [
			[
				'unknown',
				[
					"class" => "Spec\\CategoryDefault"
				]
			],
			[
				'unknown',
				[
					"class" => "Spec\\CategoryDefault",
					"name" => "foo"
				]
			]
		];
	}
}
