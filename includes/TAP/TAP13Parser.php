<?php

namespace Pickle;

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
	 * @see \Pickle\ATAPParser::checkConsistency()
	 * @param array $stats extracted from the TAP-file
	 * @param int $count found markers
	 * @return bool assumed consistency
	 */
	protected function checkConsistency( array $stats, $count ) {
		if ( $count !== false ) {
			return !parent::checkConsistency( $stats, $count );
		}
		return true;
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
