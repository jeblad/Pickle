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
class SpecsTest extends Scribunto_LuaEngineTestBase {

	protected static $moduleName = 'SpecsTest';

	function getTestModules() {
		return parent::getTestModules() + [
			'SpecsTest' => __DIR__ . '/SpecsTest.lua'
		];
	}
}
