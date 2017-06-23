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
class FrameRenderTestBase extends Scribunto_LuaEngineTestBase {

	protected static $moduleName = 'FrameRenderTestBase';

	/**
	 * @see Scribunto_LuaEngineTestBase::getTestModules()
	 * @return configuration data
	 */
	function getTestModules() {
		return parent::getTestModules() + [
			'FrameRenderTestBase' => __DIR__ . '/FrameRenderTestBase.lua'
		];
	}
}
