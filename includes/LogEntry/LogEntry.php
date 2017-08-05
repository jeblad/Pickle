<?php

namespace Pickle;

/**
 * Log entry base
 * Encapsulates the base class log entry as an adapter.
 *
 * @ingroup Extensions
 */
class LogEntry {

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
	public function newLogEntry( \Title $title, \LogEntry $logEntry = null ) {
		// the log entry is not optional for the base class
		assert( $logEntry );

		$logEntry->setPerformer( \Pickle\Observer::getUser() );
		$logEntry->setTarget( $title );
		$logEntry->setIsPatrollable( false );

		return $logEntry;
	}

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
		if ( is_null( $logEntry ) ) {
			$logEntry = $this->newLogEntry( $title );
		}

		$logid = $logEntry->insert();
		$logEntry->publish( $logid );

		return $logEntry;
	}
}
