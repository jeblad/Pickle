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
class RenderFrameTest extends Scribunto_LuaEngineTestBase {

	protected static $moduleName = 'RenderFrameTest';

	/**
	 * @slowThreshold 1000
	 * @see Scribunto_LuaEngineTestBase::getTestModules()
	 * @return configuration data
	 */
	protected function getTestModules() {
		return parent::getTestModules() + [
			'RenderFrameTest' => __DIR__ . '/RenderFrameTest.lua'
		];
	}
}
