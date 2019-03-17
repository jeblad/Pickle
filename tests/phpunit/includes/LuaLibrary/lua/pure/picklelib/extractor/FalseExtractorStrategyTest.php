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
class FalseExtractorStrategyTest extends Scribunto_LuaEngineTestBase {

	protected static $moduleName = 'FalseExtractorStrategyTest';

	/**
	 * @see Scribunto_LuaEngineTestBase::getTestModules()
	 */
	function getTestModules() {
		return parent::getTestModules() + [
			'FalseExtractorStrategyTest' => __DIR__ . '/FalseExtractorStrategyTest.lua'
		];
	}
}
