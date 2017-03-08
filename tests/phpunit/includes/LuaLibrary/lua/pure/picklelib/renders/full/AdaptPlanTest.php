<?php

namespace Pickle\Test\Full;

use Scribunto_LuaEngineTestBase;

/**
 * @group Pickle
 *
 * @license GNU GPL v2+
 *
 * @author John Erling Blad < jeblad@gmail.com >
 */
class AdaptPlanTest extends Scribunto_LuaEngineTestBase {

	protected static $moduleName = 'AdaptPlanTest';

	function getTestModules() {
		return parent::getTestModules() + [
			'AdaptPlanTest' => __DIR__ . '/AdaptPlanTest.lua'
		];
	}
}
