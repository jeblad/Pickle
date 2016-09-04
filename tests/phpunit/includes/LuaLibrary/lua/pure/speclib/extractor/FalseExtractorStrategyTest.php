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
class FalseExtractorStrategyTest extends Scribunto_LuaEngineTestBase {

	protected static $moduleName = 'FalseExtractorStrategyTest';

	function getTestModules() {
		return parent::getTestModules() + [
			'FalseExtractorStrategyTest' => __DIR__ . '/FalseExtractorStrategyTest.lua'
		];
	}
}
