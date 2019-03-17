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
class AdaptRenderTest extends Scribunto_LuaEngineTestBase {

	protected static $moduleName = 'AdaptRenderTest';

	/**
	 * @see Scribunto_LuaEngineTestBase::getTestModules()
	 * @return configuration data
	 */
	function getTestModules() {
		return parent::getTestModules() + [
			'AdaptRenderTest' => __DIR__ . '/AdaptRenderTest.lua'
		];
	}
}
