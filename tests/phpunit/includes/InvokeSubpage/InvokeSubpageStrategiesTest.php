<?php

namespace Spec\Tests;

use MediaWikiTestCase;
use \Spec\InvokeSubpageStrategies;

/**
 * @group Spec
 *
 * @covers \Spec\InvokeSubpageStrategies
 */
class InvokeSubpageStrategiesTest extends StrategiesTestCase {

	public static function stratClass() {
		return 'Spec\InvokeSubpageStrategies';
	}

	public function testOnCodeToInterface() {
		$test = InvokeSubpageStrategies::getInstance();
		$this->assertInstanceOf( 'Spec\\IStrategies', $test );
	}

	public function testWho() {
		$test = InvokeSubpageStrategies::who();
		$this->assertEquals( 'Spec\InvokeSubpageStrategies', $test );
	}

	public function testInit() {
		$testA = InvokeSubpageStrategies::getInstance();
		$testB = InvokeSubpageStrategies::getInstance();
		$this->assertEquals( InvokeSubpageStrategies::who(), get_class( $testA ) );
		$this->assertEquals( $testA, $testB );
	}

	public function testRegister() {
		$struct = [ 'class' => 'Spec\InvokeSubpageByContentType' ];
		$test = InvokeSubpageStrategies::getInstance();
		$instance = $test->register( $struct );
		$this->assertEquals( get_class( $instance ), $struct['class'] );
	}

	public function provideFind() {
		return [
			[ 'spec-default-invoke', false, 'wikitext' ],
			// [ 'spec-test-invoke', true, 'Scribunto' ],
			[ 'spec-testspec-invoke', true, 'wikitext' ],
			// [ 'spec-default-invoke', false, 'Scribunto' ],
			// [ 'spec-test-invoke', true, 'Scribunto' ],
			// [ 'spec-testspec-invoke', true, 'Scribunto' ],
			[ 'spec-default-invoke', false, 'Other' ],
			[ 'spec-default-invoke', true, 'Other' ]
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
				'class' => 'Spec\InvokeSubpageByContentType',
				'name' => 'testspec',
				'type' => 'Scribunto'
			]
		);
		$test->register(
			[
				'class' => 'Spec\InvokeSubpageDefault'
			]
		);
		$this->markTestIncomplete( "This test isn't correct in its present form" );
		// Find now calls $strategy->checkSubpageType( $title ) while it
		// previously called $strategy->checkType( $title )
		// These methods contain static calls and are thus difficult to test.
		$strategy = $test->find( $title );
		$this->assertContains( $expect,
			$strategy->getInvoke( $title )->inLanguage( 'qqx' )	->plain() );
	}
}
