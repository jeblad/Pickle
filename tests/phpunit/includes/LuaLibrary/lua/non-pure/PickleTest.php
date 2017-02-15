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
class PickleTest extends Scribunto_LuaEngineTestBase {

	protected static $moduleName = 'PickleTest';

	function getTestModules() {
		return parent::getTestModules() + [
			'PickleTest' => __DIR__ . '/PickleTest.lua'
		];
	}
}
