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

	public function testWho() {
		$test = InvokeSubpageStrategies::who();
		$this->assertEquals( 'Spec\InvokeSubpageStrategies', $test );
	}

	public function testInit() {
		$testA = InvokeSubpageStrategies::init();
		$testB = InvokeSubpageStrategies::init();
		$this->assertEquals( InvokeSubpageStrategies::who(), get_class( $testA ) );
		$this->assertEquals( $testA, $testB );
	}

	public function testRegisterStrategy() {
		$struct = [ 'class' => 'Spec\\InvokeSubpageByContentTypeStrategy' ];
		$test = InvokeSubpageStrategies::init();
		$instance = $test->registerStrategy( $struct );
		$this->assertEquals( get_class( $instance ), $struct['class'] );
	}

	public function provideFind() {
		return [
			[ 'spec-default-invoke', false, 'Scribunto' ],
			[ 'spec-spec-invoke', true, 'Scribunto' ],
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

		$test = InvokeSubpageStrategies::init();
		$test->registerStrategy(
			[
				'class' => 'Spec\InvokeSubpageByContentTypeStrategy',
				'name' => 'spec',
				'type' => 'Scribunto'
			]
		);
		$test->registerStrategy(
			[
				'class' => 'Spec\InvokeSubpageDefaultStrategy'
			]
		);
		$strategy = $test->find( $title );
		$this->assertContains( $expect,
			$strategy->getInvoke( $title )->inLanguage( 'qqx' )	->plain() );
	}
}
