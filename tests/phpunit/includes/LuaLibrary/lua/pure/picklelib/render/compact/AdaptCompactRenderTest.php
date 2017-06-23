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
class AdaptCompactRenderTest extends Scribunto_LuaEngineTestBase {

	protected static $moduleName = 'AdaptCompactRenderTest';

	/**
	 * @see Scribunto_LuaEngineTestBase::getTestModules()
	 */
	function getTestModules() {
		return parent::getTestModules() + [
			'AdaptCompactRenderTest' => __DIR__ . '/AdaptCompactRenderTest.lua'
		];
	}
}
