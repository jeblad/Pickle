<?php

namespace Spec;

/**
 * Track log strategy
 */
abstract class TrackLogEntryBaseStrategy implements ITrackLogEntryStrategy {

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
	 * @see \Spec\ITrackLogEntryStrategy::addLogEntry()
	 */
	public function addLogEntry( \Title $title, \LogEntry $logEntry = null ) {

		$logEntry = $this->newLogEntry( $title );

		$logid = $logEntry->insert();
		$logEntry->publish( $logid );

		return $logEntry;
	}
}
