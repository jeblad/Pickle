<?php

namespace Pickle;

/**
 * Concrete strategy for log entries
 * Encapsulates a common log entry as an adapter. The common log entry is used when recognized
 * entries are found.
 *
 * @ingroup Extensions
 */
class LogEntryCommon extends LogEntry {

	/**
	 * @param array $opts structure from extension setup
	 */
	public function __construct( array $opts ) {
		$this->opts = array_merge( [ 'name' => 'none' ], $opts );
	}

	/**
	 * @see \Pickle\LogEntryStrategy::newLogEntry()
	 * @param \Title $title header information
	 * @param \LogEntry|null $logEntry preexisting log entry (optional)
	 * @return \LogEntry
	 */
	public function newLogEntry( \Title $title, \LogEntry $logEntry = null ) {
		if ( is_null( $logEntry ) ) {
			$logEntry = new \ManualLogEntry( 'track', $this->opts['name'] );
		}
		return parent::newLogEntry( $title, $logEntry );
	}
}
