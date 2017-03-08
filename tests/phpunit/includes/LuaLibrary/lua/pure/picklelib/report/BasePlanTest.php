<?php

namespace Pickle\Test;

use Scribunto_LuaEngineTestBase;

/**
 * @group Pickle
 *
 * @license GNU GPL v2+
 *
 * @author John Erling Blad < jeblad@gmail.com >
 */
class BasePlanTest extends Scribunto_LuaEngineTestBase {

	protected static $moduleName = 'BasePlanTest';

	function getTestModules() {
		return parent::getTestModules() + [
			'BasePlanTest' => __DIR__ . '/BasePlanTest.lua'
		];
	}
}
