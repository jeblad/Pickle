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
class ReportBaseTest extends Scribunto_LuaEngineTestBase {

	protected static $moduleName = 'ReportBaseTest';

	/**
	 * @see Scribunto_LuaEngineTestBase::getTestModules()
	 */
	function getTestModules() {
		return parent::getTestModules() + [
			'ReportBaseTest' => __DIR__ . '/ReportBaseTest.lua'
		];
	}
}
