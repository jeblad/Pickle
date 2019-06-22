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
class ExtractorNumberTest extends Scribunto_LuaEngineTestBase {

	protected static $moduleName = 'ExtractorNumberTest';

	/**
	 * @slowThreshold 1000
	 * @see Scribunto_LuaEngineTestBase::getTestModules()
	 */
	protected function getTestModules() {
		return parent::getTestModules() + [
			'ExtractorNumberTest' => __DIR__ . '/ExtractorNumberTest.lua'
		];
	}
}
