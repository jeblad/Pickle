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
class UtilTest extends Scribunto_LuaEngineTestBase {

	protected static $moduleName = 'UtilTest';

	function getTestModules() {
		return parent::getTestModules() + [
			'UtilTest' => __DIR__ . '/UtilTest.lua'
		];
	}
}
