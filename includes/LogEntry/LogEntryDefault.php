<?php

namespace Pickle;

/**
 * Concrete strategy for log entries
 * Encapsulates a default log entry as an adapter. The default log entry is used when no other
 * matching entry can be found.
 *
 * @ingroup Extensions
 */
class LogEntryDefault extends LogEntry {

	/**
	 * @param array $opts structure from extension setup
	 */
	public function __construct( array $opts ) {
		$this->opts = array_merge( [], $opts, [ 'name' => 'unknown' ] );
	}

	/**
	 * @see \Pickle\LogEntryStrategy::newLogEntry()
	 * @param \Title $title header information
	 * @param \LogEntry|null $logEntry preexisting log entry (optional)
	 * @return \LogEntry
	 */
	public function newLogEntry( \Title $title, \LogEntry $logEntry = null ) {
		if ( is_null( $logEntry ) ) {
			$logEntry = new \ManualLogEntry( 'track', 'unknown' );
		}
		return parent::newLogEntry( $title,  $logEntry );
	}
}
