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
class RenderFrameVividTest extends Scribunto_LuaEngineTestBase {

	protected static $moduleName = 'RenderFrameVividTest';

	/**
	 * @see Scribunto_LuaEngineTestBase::getTestModules()
	 */
	protected function getTestModules() {
		return parent::getTestModules() + [
			'RenderFrameVividTest' => __DIR__ . '/RenderFrameVividTest.lua'
		];
	}
}
