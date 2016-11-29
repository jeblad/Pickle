<?php

namespace Spec;

/**
 * TAP base Parser
 * Encapsulates the abstract base class for TAP parser as an adapter.
 *
 * @ingroup Extensions
 */
abstract class ATAPParser {

	use TNamedStrategy;

	protected $opts;

	/**
	 * Clone the opts
	 *
	 * @return array
	 */
	public function cloneOpts() {
		return array_merge( [], $this->opts );
	}

	/**
	 * Try to get the version of the test result
	 *
	 * @param string result from the evaluation
	 * @return int|null
	 */
	public static function getVersion( $str ) {

		if ( preg_match( '/^TAP version (\d+)/i', $str, $matches ) === 1 ) {
			$version = intval( $matches[1] );
			return intval( $version );
		}

		return false;
	}

	/**
	 * Try to get the number of test results
	 * This can be used as a kind of weak indication of type of tap.
	 *
	 * @param string result from the evaluation
	 * @return int|null
	 */
	public static function getCount( $str ) {

		if ( preg_match( '/^1..(\d+)\s*$/m', $str, $matches ) === 1 ) {
			return intval( $matches[1] );
		}

		return false;
	}

	/**
	 * Check if the line represent a good test
	 *
	 * @param string result to inspect
	 * @return boolean
	 */
	public static function isOk( $line ) {
		return ( preg_match( '/^(ok)\b/i', $line ) === 1 );
	}

	/**
	 * Check if the line represent a bad test
	 *
	 * @param string result to inspect
	 * @return boolean
	 */
	public static function isNotOk( $line ) {
		return ( preg_match( '/^(not\s+ok)\b/i', $line ) === 1 );
	}

	/**
	 * Check if the line represent a test that is skipped
	 * A test could be skipped due to missing dependencies.
	 * Skipped tests imply that the test set isn't complete.
	 *
	 * @param string result to inspect
	 * @return boolean
	 */
	public static function isSkip( $line ) {
		return ( preg_match( '/#\s*(skipp?(ing|ed|))\b/i', $line ) === 1 );
	}

	/**
	 * Check if the line represent a test that is marked as todo
	 *
	 * @param string result to inspect
	 * @return boolean
	 */
	public static function isTodo( $line ) {
		return ( preg_match( '/#\s*(todo)\b/i', $line ) === 1 );
	}

	/**
	 * Check if the line represent a test that is indexed
	 * Note that not all TAP-format uses indexes.
	 *
	 * @param string result to inspect
	 * @return boolean
	 */
	public static function isIndex( $line ) {
		if ( preg_match( '/^(not\s+ok|ok)\s+(\d+)/i', $line, $matches ) === 1 ) {
			return intval( $matches[2] );
		}
		return false;
	}

	/**
	 * Check if the line represent a comment
	 *
	 * @param string result to inspect
	 * @return boolean
	 */
	public static function isComment( $line ) {
		if ( preg_match( '/^#/', $line ) === 1 ) {
			return true;
		}
		return false;
	}

	/**
	 * Check if the line represent a text
	 *
	 * @param string result to inspect
	 * @return boolean
	 */
	public static function isText( $line ) {
		if ( preg_match( '/^[ \t]/', $line ) === 1 ) {
			return true;
		}
		return false;
	}

	 /**
	 * @see \Spec\ATAPParser::getName()
	 */
	public function getName() {
		return $this->opts['name'];
	}

	/**
	 * Checks if the text is accoring to a given version
	 *
	 * @param string result from the evaluation
	 * @return boolean
	 */
	abstract public function checkValid( $str );

	/**
	 * Get the parsed form
	 * This isn't really a parser, it just squashes the string into submission.
	 *
	 * @param string result from the evaluation
	 * @return string
	 */
	abstract public function parse( $str );
}
