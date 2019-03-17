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
class NumberExtractorStrategyTest extends Scribunto_LuaEngineTestBase {

	protected static $moduleName = 'NumberExtractorStrategyTest';

	/**
	 * @see Scribunto_LuaEngineTestBase::getTestModules()
	 */
	function getTestModules() {
		return parent::getTestModules() + [
			'NumberExtractorStrategyTest' => __DIR__ . '/NumberExtractorStrategyTest.lua'
		];
	}
}
