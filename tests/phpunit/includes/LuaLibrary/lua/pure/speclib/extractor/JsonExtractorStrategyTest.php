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
class JsonExtractorStrategyTest extends Scribunto_LuaEngineTestBase {

	protected static $moduleName = 'JsonExtractorStrategyTest';

	function getTestModules() {
		return parent::getTestModules() + [
			'JsonExtractorStrategyTest' => __DIR__ . '/JsonExtractorStrategyTest.lua'
		];
	}
}
