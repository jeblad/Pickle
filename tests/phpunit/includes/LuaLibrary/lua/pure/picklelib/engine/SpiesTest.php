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
class SpiesTest extends Scribunto_LuaEngineTestBase {

	protected static $moduleName = 'SpiesTest';

	function getTestModules() {
		return parent::getTestModules() + [
			'SpiesTest' => __DIR__ . '/SpiesTest.lua'
		];
	}
}
