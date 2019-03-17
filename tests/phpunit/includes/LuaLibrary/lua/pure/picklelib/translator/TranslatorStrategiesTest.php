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
class TranslatorStrategiesTest extends Scribunto_LuaEngineTestBase {

	protected static $moduleName = 'TranslatorStrategiesTest';

	/**
	 * @see Scribunto_LuaEngineTestBase::getTestModules()
	 */
	function getTestModules() {
		return parent::getTestModules() + [
			'TranslatorStrategiesTest' => __DIR__ . '/TranslatorStrategiesTest.lua'
		];
	}
}
