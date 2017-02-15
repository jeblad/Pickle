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
class AdaptTest extends Scribunto_LuaEngineTestBase {

	protected static $moduleName = 'AdaptTest';

	function getTestModules() {
		return parent::getTestModules() + [
			'AdaptTest' => __DIR__ . '/AdaptTest.lua'
		];
	}
}
