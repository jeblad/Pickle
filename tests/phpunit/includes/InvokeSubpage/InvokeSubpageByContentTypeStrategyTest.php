<?php

namespace Spec\Tests;

use MediaWikiTestCase;
use \Spec\InvokeSubpageByContentTypeStrategy;

/**
 * @group Spec
 *
 * @covers \Spec\InvokeSubpageByContentTypeStrategy
 */
class InvokeSubpageByContentTypeStrategyTest extends InvokeSubpageStrategyTestCase {

	protected $conf = [
		"class" => "Spec\\InvokeSubpageByContentTypeStrategy",
		"type" => "Scribunto", // this is CONTENT_MODEL_SCRIBUNTO but as used in extension.json
		"name" => "testcase"
	];

	public function testOnCodeToInterface() {
		$test = new InvokeSubpageByContentTypeStrategy( $this->conf );
		$this->assertInstanceOf( 'Spec\\IInvokeSubpageStrategy', $test );
	}

	public function testOnGetSubpagePrefixedText() {
		$test = new InvokeSubpageByContentTypeStrategy( $this->conf );
		$str = $test->getSubpagePrefixedText( $this->stub )->inLanguage( 'qqx' )->plain();
		$this->assertContains( 'spec-testcase-subpage', $str );
		$this->assertContains( 'Scribunto:baz', $str );
	}

	public function testOnGetSubpageBaseText() {
		$test = new InvokeSubpageByContentTypeStrategy( $this->conf );
		$str = $test->getSubpageBaseText( $this->stub )->inLanguage( 'qqx' )->plain();
		$this->assertContains( 'spec-testcase-subpage', $str );
		$this->assertContains( 'foo', $str );
	}

	public function testOnGetSubpageTitle() {
		$test = new InvokeSubpageByContentTypeStrategy( $this->conf );
		$title = $test->getSubpageTitle( $this->stub );
		$this->assertEquals( 'Title', get_class( $title ) );
		$this->assertEquals( 'Scribunto:baz/testcase', $title->getText() );
	}

	public function testOnGetInvoke() {
		$test = new InvokeSubpageByContentTypeStrategy( $this->conf );
		$str = $test->getInvoke( $this->stub )->inLanguage( 'qqx' )->plain();
		$this->assertContains( 'spec-testcase-invoke', $str );
		$this->assertContains( 'foo/testcase', $str );
	}

	public function testOnCheckType() {
		$test = new InvokeSubpageByContentTypeStrategy( $this->conf );
		$this->assertFalse( $test->checkType( $this->stub ) );
		$this->assertTrue( $test->checkType( $this->stub ) );
	}

	public function testOnCheckSubpageType() {
		$test = new InvokeSubpageByContentTypeStrategy( $this->conf );
		// this is the wrong type, but it verifies that the title is created
		$this->assertTrue( $test->checkSubpageType( $this->stub, 'wikitext' ) );
	}
}
