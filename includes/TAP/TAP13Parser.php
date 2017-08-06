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
		// get count and calculate statistics
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

		// try all clauses
		foreach ( parent::clauses() as $clause ) {
			$result = $clause( $stats );
			if ( $result ) {
				return $result;
			}
		}

		// probably a test set without any tests
		return 'unknown';
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
