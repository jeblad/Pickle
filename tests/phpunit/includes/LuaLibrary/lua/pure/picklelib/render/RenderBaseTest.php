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
class RenderBaseTest extends Scribunto_LuaEngineTestBase {

	protected static $moduleName = 'RenderBaseTest';

	/**
	 * @see Scribunto_LuaEngineTestBase::getTestModules()
	 */
	function getTestModules() {
		return parent::getTestModules() + [
			'RenderBaseTest' => __DIR__ . '/RenderBaseTest.lua'
		];
	}
}
