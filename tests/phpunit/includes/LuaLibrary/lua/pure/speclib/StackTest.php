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
class StackTest extends Scribunto_LuaEngineTestBase {

	protected static $moduleName = 'StackTest';

	function getTestModules() {
		return parent::getTestModules() + [
			'StackTest' => __DIR__ . '/StackTest.lua'
		];
	}
}
