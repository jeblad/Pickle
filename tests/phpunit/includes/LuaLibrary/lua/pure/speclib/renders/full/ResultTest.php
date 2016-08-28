<?php

namespace Spec\Test\Full;

use Scribunto_LuaEngineTestBase;

/**
 * @group Spec
 *
 * @license GNU GPL v2+
 *
 * @author John Erling Blad < jeblad@gmail.com >
 */
class ResultTest extends Scribunto_LuaEngineTestBase {

	protected static $moduleName = 'ResultTest';

	function getTestModules() {
		return parent::getTestModules() + [
			'ResultTest' => __DIR__ . '/ResultTest.lua'
		];
	}
}
