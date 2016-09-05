<?php

namespace Spec\Test;

use Scribunto_LuaEngineTestBase;

/**
 * @group Spec
 *
 * @license GNU GPL v2+
 *
 * @author John Erling Blad < jeblad@gmail.com >
 */
class NumberExtractorStrategyTest extends Scribunto_LuaEngineTestBase {

	protected static $moduleName = 'NumberExtractorStrategyTest';

	function getTestModules() {
		return parent::getTestModules() + [
			'NumberExtractorStrategyTest' => __DIR__ . '/NumberExtractorStrategyTest.lua'
		];
	}
}
