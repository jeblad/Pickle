<?php

namespace Pickle\Tests;

class InvokeSubpageTestCase extends \MediaWikiTestCase {

	protected $stub;

	/**
	 */
	public function setUp() {
		parent::setUp();
		$this->stub = $this->getMockBuilder( '\Title' )
			->setMethods( [ 'getPrefixedText', 'getBaseText', 'exists', 'getContentModel' ] )
			->getMock();
		$this->stub
			->expects( $this->any() )
			->method( 'getPrefixedText' )
			->will( $this->returnValue( 'Scribunto:baz' ) );
		$this->stub
			->expects( $this->any() )
			->method( 'getBaseText' )
			->will( $this->returnValue( 'foo' ) );
		$this->stub
			->expects( $this->any() )
			->method( 'exists' )
			->will( $this->onConsecutiveCalls( false, true ) );
		$this->stub
			->expects( $this->any() )
			->method( 'getContentModel' )
			->will( $this->returnValue( CONTENT_MODEL_SCRIBUNTO ) );
	}

	/**
	 */
	public function tearDown() {
		unset( $this->stub );
		parent::tearDown();
	}
}
