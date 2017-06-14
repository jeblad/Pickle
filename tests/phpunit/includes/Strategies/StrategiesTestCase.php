<?php

namespace Pickle\Tests;

use \Pickle\Strategies;

class StrategiesTestCase extends \MediaWikiTestCase {

	protected $stuff = null;

	/**
	 * @return null unconditionally
	 */
	public static function stratClass() {
		return null;
	}

	/**
	 */
	public function setUp() {
		parent::setUp();
		$thingy = Strategies::getInstance( static::stratClass() );
		$this->stuff = $thingy->export();
		$thingy->reset();
	}

	/**
	 */
	public function tearDown() {
		$thingy = Strategies::getInstance( static::stratClass() );
		$thingy->import( $this->stuff );
		parent::tearDown();
	}
}
