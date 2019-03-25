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
class TrueExtractorTest extends Scribunto_LuaEngineTestBase {

	protected static $moduleName = 'TrueExtractorTest';

	/**
	 * @see Scribunto_LuaEngineTestBase::getTestModules()
	 */
	protected function getTestModules() {
		return parent::getTestModules() + [
			'TrueExtractorTest' => __DIR__ . '/TrueExtractorTest.lua'
		];
	}
}
