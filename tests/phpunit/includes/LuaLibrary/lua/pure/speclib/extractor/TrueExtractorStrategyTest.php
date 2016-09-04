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
class TrueExtractorStrategyTest extends Scribunto_LuaEngineTestBase {

	protected static $moduleName = 'TrueExtractorStrategyTest';

	function getTestModules() {
		return parent::getTestModules() + [
			'TrueExtractorStrategyTest' => __DIR__ . '/TrueExtractorStrategyTest.lua'
		];
	}
}
