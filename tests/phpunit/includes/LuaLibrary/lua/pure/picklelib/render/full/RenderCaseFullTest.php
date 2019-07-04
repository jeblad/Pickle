<?php

namespace Pickle\Test\Full;

use Scribunto_LuaEngineTestBase;

/**
 * @group Pickle
 *
 * @license GPL-2.0-or-later
 *
 * @author John Erling Blad < jeblad@gmail.com >
 */
class RenderCaseFullTest extends Scribunto_LuaEngineTestBase {

	protected static $moduleName = 'RenderCaseFullTest';

	/**
	 * @slowThreshold 1000
	 * @see Scribunto_LuaEngineTestBase::getTestModules()
	 */
	protected function getTestModules() {
		return parent::getTestModules() + [
			'RenderCaseFullTest' => __DIR__ . '/RenderCaseFullTest.lua'
		];
	}
}
