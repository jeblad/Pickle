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
class AdaptPlanTestBase extends Scribunto_LuaEngineTestBase {

	protected static $moduleName = 'AdaptPlanTestBase';

	function getTestModules() {
		return parent::getTestModules() + [
			'AdaptPlanTestBase' => __DIR__ . '/AdaptPlanTestBase.lua'
		];
	}
}
