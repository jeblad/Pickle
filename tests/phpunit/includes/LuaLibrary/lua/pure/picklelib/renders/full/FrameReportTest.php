<?php

namespace Pickle\Test\Full;

use Scribunto_LuaEngineTestBase;

/**
 * @group Pickle
 *
 * @license GNU GPL v2+
 *
 * @author John Erling Blad < jeblad@gmail.com >
 */
class FrameReportTest extends Scribunto_LuaEngineTestBase {

	protected static $moduleName = 'FrameReportTest';

	function getTestModules() {
		return parent::getTestModules() + [
			'FrameReportTest' => __DIR__ . '/FrameReportTest.lua'
		];
	}
}
