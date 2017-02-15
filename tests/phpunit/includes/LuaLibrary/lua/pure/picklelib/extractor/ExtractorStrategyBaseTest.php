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
class ExtractorStrategyBaseTest extends Scribunto_LuaEngineTestBase {

	protected static $moduleName = 'ExtractorStrategyBaseTest';

	function getTestModules() {
		return parent::getTestModules() + [
			'ExtractorStrategyBaseTest' => __DIR__ . '/ExtractorStrategyBaseTest.lua'
		];
	}
}
