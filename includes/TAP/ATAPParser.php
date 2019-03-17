<?php

namespace Pickle;

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
	 * Default clauses to test generated statistics against
	 * @return array of functions
	 */
	protected static function clauses() {
		$clauses = [];

		$clauses[] = function ( $stats ) {
			return $stats[1][0] > $stats[1][1] + $stats[1][2] ? 'bad' : null;
		};
		$clauses[] = function ( $stats ) {
			return $stats[1][2] > 0 ? 'todo-bad' : null;
		};
		$clauses[] = function ( $stats ) {
			return $stats[0][2] > 0 ? 'todo-good' : null;
		};
		$clauses[] = function ( $stats ) {
			return $stats[1][1] > 0 ? 'skip-bad' : null;
		};
		$clauses[] = function ( $stats ) {
			return $stats[0][1] > 0 ? 'skip-good' : null;
		};
		$clauses[] = function ( $stats ) {
			return $stats[0][0] > 0 && $stats[0][1] + $stats[0][2] === 0 ? 'good' : null;
		};

		return $clauses;
	}

	/**
	 * Try to get the version of the test result
	 *
	 * @param string $str result from the evaluation
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
	 * @param string $str result from the evaluation
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
	 * @param string $line result to inspect
	 * @return bool
	 */
	public static function isOk( $line ) {
		return ( preg_match( '/^(ok)\b/i', $line ) === 1 );
	}

	/**
	 * Check if the line represent a bad test
	 *
	 * @param string $line result to inspect
	 * @return bool
	 */
	public static function isNotOk( $line ) {
		return ( preg_match( '/^(not\s+ok)\b/i', $line ) === 1 );
	}

	/**
	 * Check if the line represent a test that is skipped
	 * A test could be skipped due to missing dependencies.
	 * Skipped tests imply that the test set isn't complete.
	 *
	 * @param string $line result to inspect
	 * @return bool
	 */
	public static function isSkip( $line ) {
		return ( preg_match( '/#\s*(skipp?(ing|ed|))\b/i', $line ) === 1 );
	}

	/**
	 * Check if the line represent a test that is marked as todo
	 *
	 * @param string $line result to inspect
	 * @return bool
	 */
	public static function isTodo( $line ) {
		return ( preg_match( '/#\s*(todo)\b/i', $line ) === 1 );
	}

	/**
	 * Check if the line represent a test that is indexed
	 * Note that not all TAP-format uses indexes.
	 *
	 * @param string $line result to inspect
	 * @return bool
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
	 * @param string $line result to inspect
	 * @return bool
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
	 * @param string $line result to inspect
	 * @return bool
	 */
	public static function isText( $line ) {
		if ( preg_match( '/^[ \t]/', $line ) === 1 ) {
			return true;
		}
		return false;
	}

	/**
	 * @see \Pickle\ATAPParser::getName()
	 * @return string
	 */
	public function getName() {
		return $this->opts['name'];
	}

	/**
	 * Checks if the text is accoring to a given version
	 *
	 * @param string $str result from the evaluation
	 * @return bool
	 */
	public function checkValid( $str ) {
		return false;
	}

	/**
	 * Check the overall consistency
	 *
	 * @param array $stats extracted from the TAP-file
	 * @param int $count found markers
	 * @return bool assumed consistency
	 */
	protected function checkConsistency( array $stats, $count ) {
		return $stats[0][0] + $stats[1][0] === $count;
	}

	/**
	 * Get the parsed form
	 * This isn't really a parser, it just squashes the string into submission.
	 *
	 * @param string $str result from the evaluation
	 * @return string
	 */
	public function parse( $str ) {
		// get count and calculate statistics
		$count = self::getCount( $str );
		$stats = $this->stats( $str );

		// check if we got everything
		if ( !$this->checkConsistency( $stats, $count ) ) {
			return 'bad';
		}

		// try all clauses
		foreach ( self::clauses() as $clause ) {
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
	protected static function extract( $str ) {
		$lines = preg_split( '/[\n\r]/', $str );
		return array_filter( $lines, function ( $line ) {
			return !( self::isComment( $line ) || self::isText( $line ) );
		} );
	}

	/**
	 * Analyze the TAP-file for specific properties
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

}
