<?php

namespace Pickle\Test;

use Scribunto_LuaEngineTestBase;

/**
 * @group Pickle
 *
 * @license GPL-2.0-or-later
 *
 * @author John Erling Blad < jeblad@gmail.com >
 */
class PickleImplicitTest extends Scribunto_LuaEngineTestBase {

	protected static $moduleName = 'PickleImplicitTest';

	/**
	 * @see Scribunto_LuaEngineTestBase::getTestModules()
	 */
	function getTestModules() {
		return parent::getTestModules() + [
			'PickleImplicitTest' => __DIR__ . '/PickleImplicitTest.lua'
		];
	}
}
