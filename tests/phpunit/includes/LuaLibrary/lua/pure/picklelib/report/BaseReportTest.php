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
class BaseReportTest extends Scribunto_LuaEngineTestBase {

	protected static $moduleName = 'BaseReportTest';

	/**
	 * @see Scribunto_LuaEngineTestBase::getTestModules()
	 */
	function getTestModules() {
		return parent::getTestModules() + [
			'BaseReportTest' => __DIR__ . '/BaseReportTest.lua'
		];
	}
}
