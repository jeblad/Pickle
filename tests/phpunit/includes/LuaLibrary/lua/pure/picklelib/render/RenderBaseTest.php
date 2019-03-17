<?php

namespace Pickle\Test;

use Scribunto_LuaEngineTestBase;

/**
 * @group Pickle
 *
 * @license GPL-2.0-or-laterlater
 *
 * @author John Erling Blad < jeblad@gmail.com >
 */
class RenderBaseTest extends Scribunto_LuaEngineTestBase {

	protected static $moduleName = 'RenderBaseTest';

	/**
	 * @see Scribunto_LuaEngineTestBase::getTestModules()
	 */
	protected function getTestModules() {
		return parent::getTestModules() + [
			'RenderBaseTest' => __DIR__ . '/RenderBaseTest.lua'
		];
	}
}
