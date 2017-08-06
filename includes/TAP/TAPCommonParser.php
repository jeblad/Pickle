<?php

namespace Pickle;

use \Pickle\ATAPParser;

/**
 * Squash a tap into its final form
 * Encapsulates a common TAP parser as an adapter. The common TAP parser is used when recognized
 * entries are found.
 *
 * @ingroup Extensions
 */
class TAPCommonParser extends ATAPParser {

	/**
	 * @var array of functions
	 */
	private $clauses = [];

	/**
	 * @param array $opts structure from extension setup
	 */
	public function __construct( array $opts ) {
		$this->opts = array_merge( [ 'name' => 'tap' ], $opts );

		$this->clauses[] = function ( $stats ) {
			return $stats[1][0] > $stats[1][1] + $stats[1][2] ? 'bad' : null;
		};
		$this->clauses[] = function ( $stats ) {
			return $stats[1][2] > 0 ? 'todo-bad' : null;
		};
		$this->clauses[] = function ( $stats ) {
			return $stats[0][2] > 0 ? 'todo-good' : null;
		};
		$this->clauses[] = function ( $stats ) {
			return $stats[1][1] > 0 ? 'skip-bad' : null;
		};
		$this->clauses[] = function ( $stats ) {
			return $stats[0][1] > 0 ? 'skip-good' : null;
		};
		$this->clauses[] = function ( $stats ) {
			return $stats[0][0] > 0 && $stats[0][1] + $stats[0][2] === 0 ? 'good' : null;
		};
	}

	/**
	 * @see \Pickle\ATAPParser::parse()
	 * @param string $str result from the evaluation
	 * @return string
	 */
	public function parse( $str ) {
		// get count and check if we got everything
		$count = self::getCount( $str );
		if ( $count === false ) {
			return 'bad';
		}

		// calculate statistics and check it
		$stats = $this->stats( $str );
		if ( $stats[0][0] + $stats[1][0] !== $count ) {
			return 'bad';
		}

		// try all clauses
		foreach ( $this->clauses as $clause ) {
			$result = $clause( $stats );
			if ( $result ) {
				return $result;
			}
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
			return !( self::isComment( $line ) || self::isIndex( $line ) === false );
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
		return ( $this->getVersion( $str ) !== false ?: $this->getCount( $str ) !== false );
	}

}
