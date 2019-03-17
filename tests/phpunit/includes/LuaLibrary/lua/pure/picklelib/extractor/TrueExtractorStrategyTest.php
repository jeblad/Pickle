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
class TrueExtractorStrategyTest extends Scribunto_LuaEngineTestBase {

	protected static $moduleName = 'TrueExtractorStrategyTest';

	/**
	 * @see Scribunto_LuaEngineTestBase::getTestModules()
	 */
	protected function getTestModules() {
		return parent::getTestModules() + [
			'TrueExtractorStrategyTest' => __DIR__ . '/TrueExtractorStrategyTest.lua'
		];
	}
}
