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
class ConstituentTest extends Scribunto_LuaEngineTestBase {

	protected static $moduleName = 'ConstituentTest';

	function getTestModules() {
		return parent::getTestModules() + [
			'ConstituentTest' => __DIR__ . '/ConstituentTest.lua'
		];
	}
}
