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
class NumberExtractorTest extends Scribunto_LuaEngineTestBase {

	protected static $moduleName = 'NumberExtractorTest';

	/**
	 * @see Scribunto_LuaEngineTestBase::getTestModules()
	 */
	protected function getTestModules() {
		return parent::getTestModules() + [
			'NumberExtractorTest' => __DIR__ . '/NumberExtractorTest.lua'
		];
	}
}
