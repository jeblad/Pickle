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
class AdaptReportTest extends Scribunto_LuaEngineTestBase {

	protected static $moduleName = 'AdaptReportTest';

	/**
	 * @see Scribunto_LuaEngineTestBase::getTestModules()
	 */
	protected function getTestModules() {
		return parent::getTestModules() + [
			'AdaptReportTest' => __DIR__ . '/AdaptReportTest.lua'
		];
	}
}
