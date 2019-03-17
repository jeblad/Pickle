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
class AdaptVividRenderTest extends Scribunto_LuaEngineTestBase {

	protected static $moduleName = 'AdaptVividRenderTest';

	/**
	 * @see Scribunto_LuaEngineTestBase::getTestModules()
	 */
	function getTestModules() {
		return parent::getTestModules() + [
			'AdaptVividRenderTest' => __DIR__ . '/AdaptVividRenderTest.lua'
		];
	}
}
