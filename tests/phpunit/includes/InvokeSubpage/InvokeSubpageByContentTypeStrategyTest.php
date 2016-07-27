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
		"name" => "spec"
	];

	public function testOnGetSubpagePrefixedText() {
		$test = new InvokeSubpageByContentTypeStrategy( $this->conf );
		$str = $test->getSubpagePrefixedText( $this->stub )->inLanguage( 'qqx' )->plain();
		$this->assertContains( 'spec-spec-subpage', $str );
		$this->assertContains( 'bar:baz', $str );
	}

	public function testOnGetSubpageBaseText() {
		$test = new InvokeSubpageByContentTypeStrategy( $this->conf );
		$str = $test->getSubpageBaseText( $this->stub )->inLanguage( 'qqx' )->plain();
		$this->assertContains( 'spec-spec-subpage', $str );
		$this->assertContains( 'foo', $str );
	}

	public function testOnGetInvoke() {
		$test = new InvokeSubpageByContentTypeStrategy( $this->conf );
		$str = $test->getInvoke( $this->stub )->inLanguage( 'qqx' )->plain();
		$this->assertContains( 'spec-spec-invoke', $str );
		$this->assertContains( 'foo', $str );
	}

	public function testOnCheckType() {
		$test = new InvokeSubpageByContentTypeStrategy( $this->conf );
		$bool = $test->checkType( $this->stub );
		$this->assertFalse( $bool );
		$bool = $test->checkType( $this->stub );
		$this->assertTrue( $bool );
	}
}
