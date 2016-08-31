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
class ResultTestBase extends Scribunto_LuaEngineTestBase {

	protected static $moduleName = 'ResultTestBase';

	function getTestModules() {
		return parent::getTestModules() + [
			'ResultTestBase' => __DIR__ . '/ResultTestBase.lua'
		];
	}
}
