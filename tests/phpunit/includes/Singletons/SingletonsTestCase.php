<?php

namespace Spec\Tests;

use \Spec\Singletons;

class SingletonsTestCase extends \MediaWikiTestCase {

	protected $stuff = null;

	public static function stratClass() {
		return null;
	}

	public function setUp() {
		parent::setUp();
		$thingy = Singletons::getInstance( static::stratClass() );
		$this->stuff = $thingy->export();
		$thingy->reset();
	}

	public function tearDown() {
		$thingy = Singletons::getInstance( static::stratClass() );
		$thingy->import( $this->stuff );
		parent::tearDown();
	}
}
