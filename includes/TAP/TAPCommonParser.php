<?php

namespace Pickle;

/**
 * Squash a tap into its final form
 * Encapsulates a common TAP parser as an adapter. The common TAP parser is used when recognized
 * entries are found.
 *
 * @ingroup Extensions
 */
class TAPCommonParser extends ATAPParser {

	/**
	 * @param array $opts structure from extension setup
	 */
	public function __construct( array $opts ) {
		$this->opts = array_merge( [ 'name' => 'tap' ], $opts );
	}

	/**
	 * @see \Pickle\ATAPParser::checkConsistency()
	 * @param array $stats extracted from the TAP-file
	 * @param int $count found markers
	 * @return bool assumed consistency
	 */
	protected function checkConsistency( array $stats, $count ) {
		if ( $count === false ) {
			return false;
		}
		return parent::checkConsistency( $stats, $count );
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
