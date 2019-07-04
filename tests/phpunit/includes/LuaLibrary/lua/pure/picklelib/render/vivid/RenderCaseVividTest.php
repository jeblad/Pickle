<?php

namespace Pickle\Test\Vivid;

use Scribunto_LuaEngineTestBase;

/**
 * @group Pickle
 *
 * @license GPL-2.0-or-later
 *
 * @author John Erling Blad < jeblad@gmail.com >
 */
class RenderCaseVividTest extends Scribunto_LuaEngineTestBase {

	protected static $moduleName = 'RenderCaseVividTest';

	/**
	 * @slowThreshold 1000
	 * @see Scribunto_LuaEngineTestBase::getTestModules()
	 */
	protected function getTestModules() {
		return parent::getTestModules() + [
			'RenderCaseVividTest' => __DIR__ . '/RenderCaseVividTest.lua'
		];
	}
}
