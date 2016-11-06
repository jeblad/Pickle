<?php

namespace Spec;

/**
 * Log entry interface
 * Encapsulates the log entry as an adapter.
 *
 * @ingroup Extensions
 */
interface ILogEntry {

	/**
	 * Add a log entry
	 * This will create a log entry, insert it in the log and publish it.
	 *
	 * @param \Title target of the logged action
	 * @param \LogEntry|null predefined log entry for testing purposes
	 *
	 * @return LogEntry|null
	 */
	public function addLogEntry( \Title $title, \LogEntry $logEntry = null );
}
