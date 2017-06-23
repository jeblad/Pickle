<?php

namespace Pickle\Test\Vivid;

use Scribunto_LuaEngineTestBase;

/**
 * @group Pickle
 *
 * @license GNU GPL v2+
 *
 * @author John Erling Blad < jeblad@gmail.com >
 */
class FrameVividRenderTest extends Scribunto_LuaEngineTestBase {

	protected static $moduleName = 'FrameVividRenderTest';

	/**
	 * @see Scribunto_LuaEngineTestBase::getTestModules()
	 */
	function getTestModules() {
		return parent::getTestModules() + [
			'FrameVividRenderTest' => __DIR__ . '/FrameVividRenderTest.lua'
		];
	}
}
