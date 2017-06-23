<?php

namespace Pickle\Test\Compact;

use Scribunto_LuaEngineTestBase;

/**
 * @group Pickle
 *
 * @license GNU GPL v2+
 *
 * @author John Erling Blad < jeblad@gmail.com >
 */
class FrameCompactRenderTest extends Scribunto_LuaEngineTestBase {

	protected static $moduleName = 'FrameCompactRenderTest';

	/**
	 * @see Scribunto_LuaEngineTestBase::getTestModules()
	 */
	function getTestModules() {
		return parent::getTestModules() + [
			'FrameCompactRenderTest' => __DIR__ . '/FrameCompactRenderTest.lua'
		];
	}
}
