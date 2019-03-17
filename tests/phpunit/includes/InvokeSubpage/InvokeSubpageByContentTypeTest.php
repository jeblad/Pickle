<?php

namespace Pickle\Tests;

use \Pickle\InvokeSubpageByContentType;

/**
 * @group Pickle
 *
 * @covers \Pickle\InvokeSubpageByContentType
 */
class InvokeSubpageByContentTypeTest extends InvokeSubpageTestCase {

	protected $conf = [
		"class" => "Pickle\\InvokeSubpageByContentType",
		// this is CONTENT_MODEL_SCRIBUNTO but as used in extension.json
		"type" => "Scribunto",
		"name" => "testcase"
	];

	public function testOnCodeToInterface() {
		$test = new InvokeSubpageByContentType( $this->conf );
		$this->assertInstanceOf( 'Pickle\\InvokeSubpage', $test );
	}

	public function testOnGetSubpagePrefixedText() {
		$test = new InvokeSubpageByContentType( $this->conf );
		$str = $test->getSubpagePrefixedText( $this->stub )->inLanguage( 'qqx' )->plain();
		$this->assertContains( 'pickle-testcase-subpage', $str );
		$this->assertContains( 'Scribunto:baz', $str );
	}

	public function testOnGetSubpageBaseText() {
		$test = new InvokeSubpageByContentType( $this->conf );
		$str = $test->getSubpageBaseText( $this->stub )->inLanguage( 'qqx' )->plain();
		$this->assertContains( 'pickle-testcase-subpage', $str );
		$this->assertContains( 'foo', $str );
	}

	public function testOnGetSubpageTitle() {
		$test = new InvokeSubpageByContentType( $this->conf );
		$title = $test->getSubpageTitle( $this->stub );
		$this->assertEquals( 'Title', get_class( $title ) );
		$this->assertEquals( 'Scribunto:baz/testcase', $title->getText() );
	}

	public function testOnGetInvoke() {
		$test = new InvokeSubpageByContentType( $this->conf );
		$str = $test->getInvoke( $this->stub )->inLanguage( 'qqx' )->plain();
		$this->assertContains( 'pickle-testcase-invoke', $str );
		$this->assertContains( 'foo/testcase', $str );
	}

	public function testOnCheckType() {
		$test = new InvokeSubpageByContentType( $this->conf );
		$this->assertFalse( $test->checkType( $this->stub ) );
		$this->assertTrue( $test->checkType( $this->stub ) );
	}

	public function testOnCheckSubpageType() {
		$test = new InvokeSubpageByContentType( $this->conf );
		// this is the wrong type, but it verifies that the title is created
		$this->assertTrue( $test->checkSubpageType( $this->stub, 'wikitext' ) );
	}
}
