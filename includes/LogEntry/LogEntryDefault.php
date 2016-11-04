<?php

namespace Spec;

/**
 * Concrete strategy for log entries
 * Encapsulates a default log entry as an adapter. The default log entry is used when no other
 * matching entry can be found.
 *
 * @ingroup Extensions
 *
 * @license GNU GPL v2+
 * @author John Erling Blad
 */
class LogEntryDefault extends LogEntryBase {

	/**
	 * @param array structure from extension setup
	 */
	public function __construct( array $opts ) {
		$this->opts = array_merge( [], $opts, [ 'name' => 'unknown' ] );
	}

	/**
	 * @see \Spec\LogEntryBaseStrategy::newLogEntry()
	 */
	public function newLogEntry( \Title $title, \LogEntry $logEntry = null ) {

		if ( $logEntry === null ) {
			$logEntry = new \ManualLogEntry( 'track', 'unknown' );
		}

		$logEntry->setPerformer( \Spec\TrackUser::getUser() );
		$logEntry->setTarget( $title );
		$logEntry->setIsPatrollable( false );

		return $logEntry;
	}
}
