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
