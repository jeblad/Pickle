<?php

namespace Pickle\Test;

use Scribunto_LuaEngineTestBase;

/**
 * @group Pickle
 *
 * @license GNU GPL v2+
 *
 * @author John Erling Blad < jeblad@gmail.com >
 */
class FrameReportTestBase extends Scribunto_LuaEngineTestBase {

	protected static $moduleName = 'FrameReportTestBase';

	/**
	 * @see Scribunto_LuaEngineTestBase::getTestModules()
	 */
	function getTestModules() {
		return parent::getTestModules() + [
			'FrameReportTestBase' => __DIR__ . '/FrameReportTestBase.lua'
		];
	}
}
