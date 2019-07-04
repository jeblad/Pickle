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
class RenderAdaptVividTest extends Scribunto_LuaEngineTestBase {

	protected static $moduleName = 'RenderAdaptVividTest';

	/**
	 * @slowThreshold 1000
	 * @see Scribunto_LuaEngineTestBase::getTestModules()
	 */
	protected function getTestModules() {
		return parent::getTestModules() + [
			'RenderAdaptVividTest' => __DIR__ . '/RenderAdaptVividTest.lua'
		];
	}
}
