<?php

namespace Pickle\Test;

use Scribunto_LuaEngineTestBase;

/**
 * @group Pickle
 *
 * @license GPL-2.0-or-later
 *
 * @author John Erling Blad < jeblad@gmail.com >
 */
class FrameReportTest extends Scribunto_LuaEngineTestBase {

	protected static $moduleName = 'FrameReportTest';

	/**
	 * @see Scribunto_LuaEngineTestBase::getTestModules()
	 */
	protected function getTestModules() {
		return parent::getTestModules() + [
			'FrameReportTest' => __DIR__ . '/FrameReportTest.lua'
		];
	}
}
