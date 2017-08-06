<?php

namespace Pickle;

use \Pickle\ATAPParser;

/**
 * Squash a tap into its final form
 * This is version 13 of tap, with its tiny changes.
 *
 * @ingroup Extensions
 */
class TAP13Parser extends ATAPParser {

	/**
	 * @param array $opts structure from extension setup
	 */
	public function __construct( array $opts ) {
		$this->opts = array_merge( [ 'name' => 'tap-13' ], $opts );
	}

	/**
	 * @see \Pickle\ATAPParser::Parser()
	 * @param string $str result from the evaluation
	 * @return string
	 */
	public function parse( $str ) {
		$count = self::getCount( $str );
		$stats = $this->stats( $str );

		// check if we got everything
		if ( $count !== false && ( $stats[0][0] + $stats[1][0] !== $count ) ) {
			// wrong overall count
			return 'bad';
		}

		// at least one cleraly bad?
		if ( $stats[1][0] > $stats[1][1] + $stats[1][2] ) {
			// some tests marked as bad
			return 'bad';
		}

		// any todo?
		if ( $stats[1][2] > 0 ) {
			// some tests marked as bad
			return 'todo-bad';
		} elseif ( $stats[0][2] > 0 ) {
			// some tests marked as good
			return 'todo-good';
		}

		// any skipped?
		if ( $stats[1][1] > 0 ) {
			// some tests marked as bad
			return 'skip-bad';
		} elseif ( $stats[0][1] > 0 ) {
			// some tests marked as good
			return 'skip-good';
		}

		// all clearly good?
		if ( $stats[0][0] > 0 && $stats[0][1] + $stats[0][2] === 0 ) {
			// some tests marked as good
			return 'good';
		}

		// probably a test set without any tests
		return 'unknown';
	}

	/**
	 * Extract the interesting lines from a TAP13-report
	 * @param string $str result to be split and filtered
	 * @return array of extracted lines
	*/
	private static function extract( $str ) {
		$lines = preg_split( '/[\n\r]/', $str );
		return array_filter( $lines, function ( $line ) {
			return !( self::isComment( $line ) || self::isText( $line ) );
		} );
	}

	/**
	 * @see \Pickle\ATAPParser::stats()
	 * @param string $str result to be analyzed
	 * @return array
	 */
	public function stats( $str ) {
		$good = [ 0, 0, 0 ];
		$bad = [ 0, 0, 0 ];

		$lines = self::extract( $str );
		foreach ( $lines as $line ) {
			// start collecting statistics
			if ( self::isOk( $line ) ) {
				$good[0]++;
				self::isSkip( $line ) && $good[1]++;
				self::isTodo( $line ) && $good[2]++;
			} elseif ( self::isNotOk( $line ) ) {
				$bad[0]++;
				self::isSkip( $line ) && $bad[1]++;
				self::isTodo( $line ) && $bad[2]++;
			}
		}

		return [ $good, $bad ];
	}

	/**
	 * @see \Pickle\ATAPParser::checkValid()
	 * @param string $str result from the evaluation
	 * @return bool
	 */
	public function checkValid( $str ) {
		return ( $this->getVersion( $str ) === 13 );
	}

}
