<?php

namespace Spec;

/**
 * Concrete strategy for log entries
 *
 * file
 * @ingroup Extensions
 *
 * @license GNU GPL v2+
 * @author John Erling Blad
 */
class TrackLogEntryDefaultStrategy extends TrackLogEntryBaseStrategy {

	/**
	 * @param array structure from extension setup
	 */
	public function __construct( array $opts ) {
		$this->opts = array_merge( [], $opts, [ 'name' => 'unknown' ] );
	}

	/**
	 * @see \Spec\TrackLogEntryBaseStrategy::newLogEntry()
	 */
	public function newLogEntry( \Title $title, \LogEntry $logEntry = null ) {

		if ( $logEntry === null ) {
			$logEntry = new \ManualLogEntry( 'track', 'unknown' );
		}

		$logEntry->setPerformer( \Spec\TrackObserver::getUser() );
		$logEntry->setTarget( $title );
		$logEntry->setIsPatrollable( false );

		return $logEntry;
	}
}
