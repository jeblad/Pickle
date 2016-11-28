<?php

namespace Spec;

/**
 * Concrete strategy for log entries
 * Encapsulates a common log entry as an adapter. The common log entry is used when recognized
 * entries are found.
 *
 * @ingroup Extensions
 */
class LogEntryCommon extends ALogEntry {

	/**
	 * @param array structure from extension setup
	 */
	public function __construct( array $opts ) {
		$this->opts = array_merge( [ 'name' => '' ], $opts );
	}

	/**
	 * @see \Spec\ALogEntryStrategy::newLogEntry()
	 */
	public function newLogEntry( \Title $title, \LogEntry $logEntry = null ) {

		if ( $logEntry === null ) {
			$logEntry = new \ManualLogEntry( 'track', $this->opts['name'] );
		}

		$logEntry->setPerformer( \Spec\Observer::getUser() );
		$logEntry->setTarget( $title );
		$logEntry->setIsPatrollable( false );

		return $logEntry;
	}
}
