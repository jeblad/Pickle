<?php

namespace Pickle\Test\Vivid;

use Scribunto_LuaEngineTestBase;

/**
 * @group Pickle
 *
 * @license GPL-2.0-or-later
 *
 * @author John Erling Blad < jeblad@gmail.com >
 */
class FrameVividRenderTest extends Scribunto_LuaEngineTestBase {

	protected static $moduleName = 'FrameVividRenderTest';

	/**
	 * @see Scribunto_LuaEngineTestBase::getTestModules()
	 */
	protected function getTestModules() {
		return parent::getTestModules() + [
			'FrameVividRenderTest' => __DIR__ . '/FrameVividRenderTest.lua'
		];
	}
}
