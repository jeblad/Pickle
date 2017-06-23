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
