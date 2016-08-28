<?php

namespace Spec\Test;

use Scribunto_LuaEngineTestBase;

/**
 * @group Spec
 *
 * @license GNU GPL v2+
 *
 * @author John Erling Blad < jeblad@gmail.com >
 */
class SubjectTest extends Scribunto_LuaEngineTestBase {

	protected static $moduleName = 'SubjectTest';

	function getTestModules() {
		return parent::getTestModules() + [
			'SubjectTest' => __DIR__ . '/SubjectTest.lua'
		];
	}
}
