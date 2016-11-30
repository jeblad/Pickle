<?php

namespace Spec;

use \Spec\ATAPParser;

/**
 * Squash a tap into its final form
 * This is version 13 of tap, with its tiny changes.
 *
 * @ingroup Extensions
 */
class TAP13Parser extends ATAPParser {

	/**
	 * @param array structure from extension setup
	 */
	public function __construct( array $opts ) {
		$this->opts = array_merge( [ 'name' => 'tap-13' ], $opts );
	}

	/**
	 * @see \Spec\ATAPParser::Parser()
	 */
	public function parse( $str ) {
		$count = self::getCount( $str );
		$stats = $this->stats( $str );

		// check if we got everything
		if ( $count !== false ) {
			// it is not compulsory to include the count in tap-13
			if ( $stats[0][0] + $stats[1][0] !== $count ) {
				// wrong overall count
				return 'bad';
			}
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
	 * @see \Spec\ATAPParser::stats()
	 */
	public function stats( $str ) {
		$good = [ 0, 0, 0 ];
		$bad = [ 0, 0, 0 ];

		$lines = preg_split( '/[\n\r]/', $str );
		foreach ( $lines as $line ) {
			if ( self::isComment( $line ) || self::isText( $line ) ) {
				continue;
			}
			// start collecting statistics
			if ( self::isOk( $line ) ) {
				$good[0]++;
				if ( self::isSkip( $line ) ) {
					$good[1]++;
				}
				if ( self::isTodo( $line ) ) {
					$good[2]++;
				}
			} elseif ( self::isNotOk( $line ) ) {
				$bad[0]++;
				if ( self::isSkip( $line ) ) {
					$bad[1]++;
				}
				if ( self::isTodo( $line ) ) {
					$bad[2]++;
				}
			}
		}

		return [ $good, $bad ];
	}

	/**
	 * @see \Spec\ATAPParser::checkValid()
	 */
	public function checkValid( $str ) {
		return ( $this->getVersion( $str ) === 13 );
	}

}
