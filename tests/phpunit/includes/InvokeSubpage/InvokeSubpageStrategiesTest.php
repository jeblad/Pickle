<?php

namespace Pickle\Tests;

use \Pickle\InvokeSubpageStrategies;

/**
 * @group Pickle
 *
 * @covers \Pickle\InvokeSubpageStrategies
 */
class InvokeSubpageStrategiesTest extends StrategiesTestCase {

	public static function stratClass() {
		return 'Pickle\InvokeSubpageStrategies';
	}

	public function testOnCodeToInterface() {
		$test = InvokeSubpageStrategies::getInstance();
		$this->assertInstanceOf( 'Pickle\\IStrategies', $test );
	}

	public function testWho() {
		$test = InvokeSubpageStrategies::who();
		$this->assertEquals( 'Pickle\InvokeSubpageStrategies', $test );
	}

	public function testInit() {
		$testA = InvokeSubpageStrategies::getInstance();
		$testB = InvokeSubpageStrategies::getInstance();
		$this->assertEquals( InvokeSubpageStrategies::who(), get_class( $testA ) );
		$this->assertEquals( $testA, $testB );
	}

	public function testRegister() {
		$struct = [ 'class' => 'Pickle\InvokeSubpageByContentType' ];
		$test = InvokeSubpageStrategies::getInstance();
		$instance = $test->register( $struct );
		$this->assertEquals( get_class( $instance ), $struct['class'] );
	}

	public function provideFind() {
		return [
			[ 'pickle-default-invoke', false, 'wikitext' ],
			// [ 'pickle-test-invoke', true, 'Scribunto' ],
			[ 'pickle-testspec-invoke', true, 'wikitext' ],
			// [ 'pickle-default-invoke', false, 'Scribunto' ],
			// [ 'pickle-test-invoke', true, 'Scribunto' ],
			// [ 'pickle-testspec-invoke', true, 'Scribunto' ],
			[ 'pickle-default-invoke', false, 'Other' ],
			[ 'pickle-default-invoke', true, 'Other' ]
		];
	}

	/**
	 * @dataProvider provideFind
	 */
	public function testFind( $expect, $exist, $type ) {
		$title = $this->getMockBuilder( '\Title' )
			->setMethods( [ 'getBaseText', 'exists', 'getContentModel' ] )
			->getMock();
		$title
			->expects( $this->any() )
			->method( 'getBaseText' )
			->will( $this->returnValue( 'foo' ) );
		$title
			->expects( $this->any() )
			->method( 'exists' )
			->will( $this->returnValue( $exist ) );
		$title
			->expects( $this->any() )
			->method( 'getContentModel' )
			->will( $this->returnValue( $type ) );

		$test = InvokeSubpageStrategies::getInstance();
		$test->register(
			[
				'class' => 'Pickle\InvokeSubpageByContentType',
				'name' => 'testspec',
				'type' => 'Scribunto'
			]
		);
		$test->register(
			[
				'class' => 'Pickle\InvokeSubpageDefault'
			]
		);
		$this->markTestIncomplete( "This test isn't correct in its present form" );
		// Find now calls $strategy->checkSubpageType( $title ) while it
		// previously called $strategy->checkType( $title )
		// These methods contain static calls and are thus difficult to test.
		$strategy = $test->find( $title );
		$this->assertContains( $expect,
			$strategy->getInvoke( $title )->inLanguage( 'qqx' )->plain() );
	}
}
