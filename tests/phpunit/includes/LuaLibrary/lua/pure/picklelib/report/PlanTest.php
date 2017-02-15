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
class PlanTest extends Scribunto_LuaEngineTestBase {

	protected static $moduleName = 'PlanTest';

	function getTestModules() {
		return parent::getTestModules() + [
			'PlanTest' => __DIR__ . '/PlanTest.lua'
		];
	}
}
