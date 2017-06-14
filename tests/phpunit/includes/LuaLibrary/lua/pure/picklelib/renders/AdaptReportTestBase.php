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
class AdaptReportTestBase extends Scribunto_LuaEngineTestBase {

	protected static $moduleName = 'AdaptReportTestBase';

	/**
	 * @see Scribunto_LuaEngineTestBase::getTestModules()
	 */
	function getTestModules() {
		return parent::getTestModules() + [
			'AdaptReportTestBase' => __DIR__ . '/AdaptReportTestBase.lua'
		];
	}
}
