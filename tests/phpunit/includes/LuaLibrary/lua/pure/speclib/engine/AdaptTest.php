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
class AdaptTest extends Scribunto_LuaEngineTestBase {

	protected static $moduleName = 'AdaptTest';

	function getTestModules() {
		return parent::getTestModules() + [
			'AdaptTest' => __DIR__ . '/AdaptTest.lua'
		];
	}
}
