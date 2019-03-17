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
class AdaptFullRenderTest extends Scribunto_LuaEngineTestBase {

	protected static $moduleName = 'AdaptFullRenderTest';

	/**
	 * @see Scribunto_LuaEngineTestBase::getTestModules()
	 */
	function getTestModules() {
		return parent::getTestModules() + [
			'AdaptFullRenderTest' => __DIR__ . '/AdaptFullRenderTest.lua'
		];
	}
}
