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
class FrameTest extends Scribunto_LuaEngineTestBase {

	protected static $moduleName = 'FrameTest';

	function getTestModules() {
		return parent::getTestModules() + [
			'FrameTest' => __DIR__ . '/FrameTest.lua'
		];
	}
}
