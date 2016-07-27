<?php

namespace Spec\Tests;

use \Spec\Strategies;

class StrategiesTestCase extends \MediaWikiTestCase {

	protected $stuff = null;

	public static function stratClass() {
		return null;
	}

	public function setUp() {
		parent::setUp();
		$thingy = Strategies::init( static::stratClass() );
		$this->stuff = $thingy->export();
		$thingy->reset();
	}

	public function tearDown() {
		$thingy = Strategies::init( static::stratClass() );
		$thingy->import( $this->stuff );
		parent::tearDown();
	}
}
