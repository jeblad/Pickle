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
class AdaptRenderTestBase extends Scribunto_LuaEngineTestBase {

	protected static $moduleName = 'AdaptRenderTestBase';

	/**
	 * @see Scribunto_LuaEngineTestBase::getTestModules()
	 * @return configuration data
	 */
	function getTestModules() {
		return parent::getTestModules() + [
			'AdaptRenderTestBase' => __DIR__ . '/AdaptRenderTestBase.lua'
		];
	}
}
