<?php

namespace Spec\Tests;

use MediaWikiTestCase;
use \Spec\InvokeSubpageDefault;

/**
 * @group Spec
 *
 * @covers \Spec\InvokeSubpageDefault
 */
class InvokeSubpageDefaultTest extends InvokeSubpageTestCase {

	protected $conf = [ 'testerQuestion' => 'tester', 'testeeQuestion' => 'tester %s' ];

	public function testOnCodeToInterface() {
		$test = new InvokeSubpageDefault( $this->conf );
		$this->assertInstanceOf( 'Spec\\AInvokeSubpage', $test );
	}

	public function testOnGetSubpagePrefixedText() {
		$test = new InvokeSubpageDefault( $this->conf );
		$str = $test->getSubpagePrefixedText( $this->stub )->inLanguage( 'qqx' )->plain();
		$this->assertContains( 'spec-default-subpage', $str );
		$this->assertContains( 'Scribunto:baz', $str );
	}

	public function testOnGetSubpageBaseText() {
		$test = new InvokeSubpageDefault( $this->conf );
		$str = $test->getSubpageBaseText( $this->stub )->inLanguage( 'qqx' )->plain();
		$this->assertContains( 'spec-default-subpage', $str );
		$this->assertContains( 'foo', $str );
	}

	public function testOnGetSubpageTitle() {
		$test = new InvokeSubpageDefault( $this->conf );
		$title = $test->getSubpageTitle( $this->stub );
		$this->assertEquals( 'Title', get_class( $title ) );
		$this->assertEquals( 'Scribunto:baz/spec', $title->getText() );
	}

	public function testOnGetInvoke() {
		$test = new InvokeSubpageDefault( $this->conf );
		$str = $test->getInvoke( $this->stub )->inLanguage( 'qqx' )->plain();
		$this->assertContains( 'spec-default-invoke', $str );
		$this->assertContains( 'foo/spec', $str );
	}

	public function testOnCheckType() {
		$test = new InvokeSubpageDefault( $this->conf );
		$bool = $test->checkType( $this->stub );
		$this->assertTrue( $bool );
		$bool = $test->checkType( $this->stub );
		$this->assertTrue( $bool );
	}

	public function testOnCheckSubpageType() {
		$test = new InvokeSubpageDefault( $this->conf );
		// this is the wrong type, but it verifies that the title is created
		$this->assertTrue( $test->checkSubpageType( $this->stub, 'wikitext' ) );
	}

	public function testOnGetTesterQuestion() {
		$test = new InvokeSubpageDefault( $this->conf );
		$call = $test->getTesterQuestion( $this->stub );
		$this->assertContains( 'tester', $call );
	}

	public function testOnGetTesteeQuestion() {
		$test = new InvokeSubpageDefault( $this->conf );
		$call = $test->getTesteeQuestion( $this->stub );
		$this->assertContains( 'tester', $call );
		$this->assertContains( 'Scribunto:baz', $call );
	}
}
