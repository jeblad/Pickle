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
class ExtractorStrategiesTest extends Scribunto_LuaEngineTestBase {

	protected static $moduleName = 'ExtractorStrategiesTest';

	/**
	 * @see Scribunto_LuaEngineTestBase::getTestModules()
	 */
	protected function getTestModules() {
		return parent::getTestModules() + [
			'ExtractorStrategiesTest' => __DIR__ . '/ExtractorStrategiesTest.lua'
		];
	}
}
