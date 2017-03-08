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
class AdaptReportTest extends Scribunto_LuaEngineTestBase {

	protected static $moduleName = 'AdaptReportTest';

	function getTestModules() {
		return parent::getTestModules() + [
			'AdaptReportTest' => __DIR__ . '/AdaptReportTest.lua'
		];
	}
}
