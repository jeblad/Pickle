<?php

namespace Spec;

use Scribunto_LuaLibraryBase;

/**
 * Registers our lua modules to Scribunto
 *
 * @licence GNU GPL v2+
 * @author John Erling Blad < jeblad@gmail.com >
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

		$extraLibraries['spec'] = [
			'class' => '\Spec\LuaLibrary',
			// @todo this should be deferred until it is used, this is preliminary
			'deferLoad' => false
		];

		return true;
	}

	/**
	 * External Lua library paths for Scribunto
	 *
	 * @param string $engine
	 * @param array $extraLibraryPaths
	 * @return bool
	 */
	public static function registerScribuntoExternalLibraryPaths(
		$engine,
		array &$extraLibraryPaths
	) {

		if ( $engine !== 'lua' ) {
			return true;
		}

		// Path containing pure Lua libraries that don't need to interact with PHP
		$extraLibraryPaths[] = __DIR__ . '/lua/pure';

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
			__DIR__ . '/lua/non-pure/Spec.lua',
			[ 'addResourceLoaderModules' => [ $this, 'addResourceLoaderModules' ] ],
			[
				'renderStyles' => $wgSpecRenderStyles,
				'renderTypes' => $wgSpecRenderTypes,
				'extractorStrategies' => $wgSpecExtractorStrategy ]
		);
	}

	/**
	 * Allows Lua to dynamically add the RL modules required for Specs.
	 */
	public function addResourceLoaderModules() {
		$this->getParser()->getOutput()->addModuleStyles( 'ext.spec.report' );
	}

}
