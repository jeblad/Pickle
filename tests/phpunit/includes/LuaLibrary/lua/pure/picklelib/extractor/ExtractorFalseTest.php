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
class ExtractorFalseTest extends Scribunto_LuaEngineTestBase {

	protected static $moduleName = 'ExtractorFalseTest';

	/**
	 * @see Scribunto_LuaEngineTestBase::getTestModules()
	 */
	protected function getTestModules() {
		return parent::getTestModules() + [
			'ExtractorFalseTest' => __DIR__ . '/ExtractorFalseTest.lua'
		];
	}
}
