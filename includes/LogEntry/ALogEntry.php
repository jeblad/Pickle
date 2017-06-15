<?php

namespace Pickle;

/**
 * Log entry base
 * Encapsulates the abstract base class log entry as an adapter.
 *
 * @ingroup Extensions
 */
abstract class ALogEntry {

	use TNamedStrategy;

	protected $opts;

	/**
	 * Clone the opts
	 *
	 * @return array
	 */
	public function cloneOpts() {
		return array_merge( [], $this->opts );
	}

	/**
	 * Create a new track log entry
	 * This will not insert and publish the entry.
	 *
	 * @param \Title $title target of the logged action
	 * @param \LogEntry|null $logEntry predefined log entry for testing purposes (optional)
	 *
	 * @return LogEntry|null
	 */
	abstract function newLogEntry( \Title $title, \LogEntry $logEntry = null );

	/**
	 * Add a log entry
	 * This will create a log entry, insert it in the log and publish it.
	 *
	 * @param \Title $title target of the logged action
	 * @param \LogEntry|null $logEntry predefined log entry for testing purposes (optional)
	 *
	 * @return LogEntry|null
	 */
	public function addLogEntry( \Title $title, \LogEntry $logEntry = null ) {
		$logEntry = $this->newLogEntry( $title );

		$logid = $logEntry->insert();
		$logEntry->publish( $logid );

		return $logEntry;
	}
}
