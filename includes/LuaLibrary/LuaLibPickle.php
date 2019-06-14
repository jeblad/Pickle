<?php

namespace Pickle;

use Scribunto_LuaLibraryBase;

/**
 * Registers our lua modules to Scribunto
 *
 * @ingroup Extensions
 */

class LuaLibPickle extends Scribunto_LuaLibraryBase {

	/**
	 * Register the library
	 *
	 * @return array
	 */
	public function register() {
		global $wgLang;
		global $wgContLang;
		global $wgPickleSetup;
		global $wgPickleRenderPath;
		global $wgPickleRenderStyles;
		global $wgPickleRenderTypes;
		global $wgPickleExtractorPath;
		global $wgPickleExtractor;
		global $wgPickleTranslationFollows;
		global $wgPickleTranslationPath;

		assert( in_array( $wgPickleSetup, [ 'implicit', 'explicit' ] ) );

		return $this->getEngine()->registerInterface(
			__DIR__ . '/lua/non-pure/Pickle.lua',
			[ 'addResourceLoaderModules' => [ $this, 'addResourceLoaderModules' ] ],
			[
				'setup' => $wgPickleSetup,
				'contLang' => $wgContLang->getCode(),
				'userLang' => $wgLang->getCode(),
				'translationFollows' => $wgPickleTranslationFollows,
				'translationPath' => $wgPickleTranslationPath,
				'renderPath' => $wgPickleRenderPath,
				'renderStyles' => $wgPickleRenderStyles,
				'renderTypes' => $wgPickleRenderTypes,
				'extractorPath' => $wgPickleExtractorPath,
				'extractors' => $wgPickleExtractor ]
		);
	}

	/**
	 * Allows Lua to dynamically add the RL modules required for Pickle.
	 */
	public function addResourceLoaderModules() {
		$this->getParser()->getOutput()->addModuleStyles( 'ext.pickle.report' );
	}

}
