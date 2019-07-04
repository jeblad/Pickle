<?php

namespace Pickle\Test\Compact;

use Scribunto_LuaEngineTestBase;

/**
 * @group Pickle
 *
 * @license GPL-2.0-or-later
 *
 * @author John Erling Blad < jeblad@gmail.com >
 */
class RenderAdaptCompactTest extends Scribunto_LuaEngineTestBase {

	protected static $moduleName = 'RenderAdaptCompactTest';

	/**
	 * @slowThreshold 1000
	 * @see Scribunto_LuaEngineTestBase::getTestModules()
	 */
	protected function getTestModules() {
		return parent::getTestModules() + [
			'RenderAdaptCompactTest' => __DIR__ . '/RenderAdaptCompactTest.lua'
		];
	}
}
