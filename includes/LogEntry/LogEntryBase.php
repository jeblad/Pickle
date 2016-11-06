<?php

namespace Spec;

/**
 * Log entry base
 * Encapsulates the abstract base class log entry as an adapter.
 *
 * @ingroup Extensions
 */
abstract class LogEntryBase implements ILogEntry {

	use TNamedStrategy;

	/**
	 * Create a new track log entry
	 * This will not insert and publish the entry.
	 *
	 * @param \Title target of the logged action
	 * @param \LogEntry|null predefined log entry for testing purposes
	 *
	 * @return LogEntry|null
	 */
	abstract function newLogEntry( \Title $title, \LogEntry $logEntry = null );

	/**
	 * @see \Spec\ILogEntryStrategy::addLogEntry()
	 */
	public function addLogEntry( \Title $title, \LogEntry $logEntry = null ) {

		$logEntry = $this->newLogEntry( $title );

		$logid = $logEntry->insert();
		$logEntry->publish( $logid );

		return $logEntry;
	}
}
