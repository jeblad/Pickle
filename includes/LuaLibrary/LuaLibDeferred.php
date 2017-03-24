<?php

namespace Pickle;

use Scribunto_LuaLibraryBase;

/**
 * Registers our lua modules to Scribunto
 *
 * @ingroup Extensions
 */

class LuaLibDeferred extends Scribunto_LuaLibraryBase {

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
			__DIR__ . '/lua/non-pure/PickleDeferred.lua',
			[ 'addResourceLoaderModules' => [ $this, 'addResourceLoaderModules' ] ],
			[
				'renderStyles' => $wgPickleRenderStyles,
				'renderTypes' => $wgPickleRenderTypes,
				'extractorStrategies' => $wgPickleExtractorStrategy ]
		);
	}

	/**
	 * Allows Lua to dynamically add the RL modules required for Pickle.
	 */
	public function addResourceLoaderModules() {
		$this->getParser()->getOutput()->addModuleStyles( 'ext.pickle.report' );
	}

}
