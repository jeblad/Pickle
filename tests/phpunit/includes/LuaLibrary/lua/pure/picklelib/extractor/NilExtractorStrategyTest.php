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
class NilExtractorStrategyTest extends Scribunto_LuaEngineTestBase {

	protected static $moduleName = 'NilExtractorStrategyTest';

	/**
	 * @see Scribunto_LuaEngineTestBase::getTestModules()
	 */
	function getTestModules() {
		return parent::getTestModules() + [
			'NilExtractorStrategyTest' => __DIR__ . '/NilExtractorStrategyTest.lua'
		];
	}
}
