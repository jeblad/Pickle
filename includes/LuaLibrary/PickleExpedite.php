<?php

namespace Pickle;

use Scribunto_LuaLibraryBase;

/**
 * Registers our lua modules to Scribunto
 *
 * @ingroup Extensions
 */

class LuaLibrary extends Scribunto_LuaLibraryBase {

	/**
	 * External Lua library for Scribunto
	 *
	 * @param string $engine
	 * @param array $extraLibraries
	 * @return bool
	 */
	public static function registerScribuntoLibraries( $engine, array &$extraLibraries ) {
		if ( $engine !== 'lua' ) {
			return true;
		}

		$extraLibraries['pickle-expedite'] = [
			'class' => '\Pickle\PickleExpedite', 'deferLoad' => false,
		];

		return true;
	}

	/**
	 * Register the library
	 *
	 * @return array
	 */
	public function register() {
		global $wgSpecRenderStyles;
		global $wgSpecRenderTypes;
		global $wgSpecExtractorStrategy;

		return $this->getEngine()->registerInterface(
			__DIR__ . '/lua/non-pure/PickleDeferred.lua',
			[ 'addResourceLoaderModules' => [ $this, 'addResourceLoaderModules' ] ],
			[
				'renderStyles' => $wgSpecRenderStyles,
				'renderTypes' => $wgSpecRenderTypes,
				'extractorStrategies' => $wgSpecExtractorStrategy ]
		);
	}

	/**
	 * Allows Lua to dynamically add the RL modules required for Pickle.
	 */
	public function addResourceLoaderModules() {
		$this->getParser()->getOutput()->addModuleStyles( 'ext.pickle.report' );
	}

}
