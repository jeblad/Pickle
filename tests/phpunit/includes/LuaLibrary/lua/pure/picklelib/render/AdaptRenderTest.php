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
