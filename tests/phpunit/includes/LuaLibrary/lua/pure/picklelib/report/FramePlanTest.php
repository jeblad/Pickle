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
class FramePlanTest extends Scribunto_LuaEngineTestBase {

	protected static $moduleName = 'FramePlanTest';

	function getTestModules() {
		return parent::getTestModules() + [
			'FramePlanTest' => __DIR__ . '/FramePlanTest.lua'
		];
	}
}
