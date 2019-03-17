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
class StringExtractorStrategyTest extends Scribunto_LuaEngineTestBase {

	protected static $moduleName = 'StringExtractorStrategyTest';

	/**
	 * @see Scribunto_LuaEngineTestBase::getTestModules()
	 */
	function getTestModules() {
		return parent::getTestModules() + [
			'StringExtractorStrategyTest' => __DIR__ . '/StringExtractorStrategyTest.lua'
		];
	}
}
