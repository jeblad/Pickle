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
class FrameRenderTest extends Scribunto_LuaEngineTestBase {

	protected static $moduleName = 'FrameRenderTest';

	/**
	 * @see Scribunto_LuaEngineTestBase::getTestModules()
	 * @return configuration data
	 */
	function getTestModules() {
		return parent::getTestModules() + [
			'FrameRenderTest' => __DIR__ . '/FrameRenderTest.lua'
		];
	}
}
