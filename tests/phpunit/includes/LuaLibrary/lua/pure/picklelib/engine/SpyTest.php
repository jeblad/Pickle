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
class SpyTest extends Scribunto_LuaEngineTestBase {

	protected static $moduleName = 'SpyTest';

	function getTestModules() {
		return parent::getTestModules() + [
			'SpyTest' => __DIR__ . '/SpyTest.lua'
		];
	}
}
