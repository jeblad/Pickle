<?php

namespace Spec\Tests;

use MediaWikiTestCase;
use \Spec\InvokeSubpageDefaultStrategy;

/**
 * @group Spec
 *
 * @covers \Spec\InvokeSubpageDefaultStrategy
 */
class InvokeSubpageDefaultStrategyTest extends InvokeSubpageStrategyTestCase {

	protected $conf = [];

	public function testOnCodeToInterface() {
		$test = new InvokeSubpageDefaultStrategy( $this->conf );
		$this->assertInstanceOf( 'Spec\\IInvokeSubpageStrategy', $test );
	}

	public function testOnGetSubpagePrefixedText() {
		$test = new InvokeSubpageDefaultStrategy( $this->conf );
		$str = $test->getSubpagePrefixedText( $this->stub )->inLanguage( 'qqx' )->plain();
		$this->assertContains( 'spec-default-subpage', $str );
		$this->assertContains( 'bar:baz', $str );
	}

	public function testOnGetSubpageBaseText() {
		$test = new InvokeSubpageDefaultStrategy( $this->conf );
		$str = $test->getSubpageBaseText( $this->stub )->inLanguage( 'qqx' )->plain();
		$this->assertContains( 'spec-default-subpage', $str );
		$this->assertContains( 'foo', $str );
	}

	public function testOnGetInvoke() {
		$test = new InvokeSubpageDefaultStrategy( $this->conf );
		$str = $test->getInvoke( $this->stub )->inLanguage( 'qqx' )->plain();
		$this->assertContains( 'spec-default-invoke', $str );
		$this->assertContains( 'foo', $str );
	}

	public function testOnCheckType() {
		$test = new InvokeSubpageDefaultStrategy( $this->conf );
		$bool = $test->checkType( $this->stub );
		$this->assertTrue( $bool );
		$bool = $test->checkType( $this->stub );
		$this->assertTrue( $bool );
	}
}
