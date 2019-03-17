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
class FrameFullRenderTest extends Scribunto_LuaEngineTestBase {

	protected static $moduleName = 'FrameFullRenderTest';

	/**
	 * @see Scribunto_LuaEngineTestBase::getTestModules()
	 */
	protected function getTestModules() {
		return parent::getTestModules() + [
			'FrameFullRenderTest' => __DIR__ . '/FrameFullRenderTest.lua'
		];
	}
}
