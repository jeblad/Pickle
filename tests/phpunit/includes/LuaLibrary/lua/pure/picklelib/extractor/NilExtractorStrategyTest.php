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
class NilExtractorStrategyTest extends Scribunto_LuaEngineTestBase {

	protected static $moduleName = 'NilExtractorStrategyTest';

	function getTestModules() {
		return parent::getTestModules() + [
			'NilExtractorStrategyTest' => __DIR__ . '/NilExtractorStrategyTest.lua'
		];
	}
}
