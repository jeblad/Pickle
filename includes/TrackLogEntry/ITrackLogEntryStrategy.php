<?php

namespace Spec;

/**
 * Track log strategy
 */
interface ITrackLogEntryStrategy {

	/**
	 * Add a new track log entry
	 * This will create a new log entry, insert it in the log and publish it.
	 *
	 * @param \Title target of the logged action
	 * @param \LogEntry|null predefined log entry for testing purposes
	 *
	 * @return LogEntry|null
	 */
	public function addLogEntry( \Title $title, \LogEntry $logEntry = null );
}
