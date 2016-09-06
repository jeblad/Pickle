<?php

namespace Spec\Test;

use Scribunto_LuaEngineTestBase;

/**
 * @group Spec
 *
 * @license GNU GPL v2+
 *
 * @author John Erling Blad < jeblad@gmail.com >
 */
class ExtractorsTest extends Scribunto_LuaEngineTestBase {

	protected static $moduleName = 'ExtractorsTest';

	function getTestModules() {
		return parent::getTestModules() + [
			'ExtractorsTest' => __DIR__ . '/ExtractorsTest.lua'
		];
	}
}
