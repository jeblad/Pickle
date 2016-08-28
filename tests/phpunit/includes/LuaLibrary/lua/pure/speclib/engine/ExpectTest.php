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
class ExpectTest extends Scribunto_LuaEngineTestBase {

	protected static $moduleName = 'ExpectTest';

	function getTestModules() {
		return parent::getTestModules() + [
			'ExpectTest' => __DIR__ . '/ExpectTest.lua'
		];
	}
}
