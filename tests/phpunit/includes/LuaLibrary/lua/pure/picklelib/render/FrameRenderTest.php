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
class FrameRenderTest extends Scribunto_LuaEngineTestBase {

	protected static $moduleName = 'FrameRenderTest';

	/**
	 * @see Scribunto_LuaEngineTestBase::getTestModules()
	 * @return configuration data
	 */
	protected function getTestModules() {
		return parent::getTestModules() + [
			'FrameRenderTest' => __DIR__ . '/FrameRenderTest.lua'
		];
	}
}
