<?php

namespace Pickle\Test\Compact;

use Scribunto_LuaEngineTestBase;

/**
 * @group Pickle
 *
 * @license GPL-2.0-or-later
 *
 * @author John Erling Blad < jeblad@gmail.com >
 */
class RenderFrameCompactTest extends Scribunto_LuaEngineTestBase {

	protected static $moduleName = 'RenderFrameCompactTest';

	/**
	 * @slowThreshold 1000
	 * @see Scribunto_LuaEngineTestBase::getTestModules()
	 */
	protected function getTestModules() {
		return parent::getTestModules() + [
			'RenderFrameCompactTest' => __DIR__ . '/RenderFrameCompactTest.lua'
		];
	}
}
