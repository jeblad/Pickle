<?php

namespace Pickle;

use Scribunto_LuaLibraryBase;

/**
 * Registers our lua modules to Scribunto
 *
 * @ingroup Extensions
 */

class LuaLibExpedited extends Scribunto_LuaLibraryBase {

	/**
	 * Register the library
	 *
	 * @return array
	 */
	public function register() {
		global $wgPickleRenderStyles;
		global $wgPickleRenderTypes;
		global $wgPickleExtractorStrategy;

		return $this->getEngine()->registerInterface(
			__DIR__ . '/lua/non-pure/bootstrap.lua',
			[],
			[
				'renderStyles' => $wgPickleRenderStyles,
				'renderTypes' => $wgPickleRenderTypes,
				'extractorStrategies' => $wgPickleExtractorStrategy
			]
		);
	}

}
