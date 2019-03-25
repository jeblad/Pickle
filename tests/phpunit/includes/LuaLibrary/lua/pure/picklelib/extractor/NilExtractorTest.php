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
class NilExtractorTest extends Scribunto_LuaEngineTestBase {

	protected static $moduleName = 'NilExtractorTest';

	/**
	 * @see Scribunto_LuaEngineTestBase::getTestModules()
	 */
	protected function getTestModules() {
		return parent::getTestModules() + [
			'NilExtractorTest' => __DIR__ . '/NilExtractorTest.lua'
		];
	}
}
