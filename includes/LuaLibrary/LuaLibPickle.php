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
		global $wgPickleSetup;
		global $wgPickleRenderPrefix;
		global $wgPickleRenderInfix;
		global $wgPickleRenderPostfix;
		global $wgPickleRenderStyles;
		global $wgPickleRenderTypes;
		global $wgPickleExtractorPath;
		global $wgPickleExtractor;
		global $wgPickleTranslationSubpage;

		assert( in_array( $wgPickleSetup, [ 'implicit', 'explicit' ] ) );

		return $this->getEngine()->registerInterface(
			__DIR__ . '/lua/non-pure/Pickle.lua',
			[ 'addResourceLoaderModules' => [ $this, 'addResourceLoaderModules' ] ],
			[
				'setup' => $wgPickleSetup,
				'translationSubpage' => $wgPickleTranslationSubpage,
				'renderPrefix' => $wgPickleRenderPrefix,
				'renderInfix' => $wgPickleRenderInfix,
				'renderPostfix' => $wgPickleRenderPostfix,
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
