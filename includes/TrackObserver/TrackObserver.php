<?php

namespace Spec;

/**
 * Track observer
 */
abstract class TrackObserver implements ITrackObserver {

	protected static $instance = null;

	/**
	 * @see \Spec\ITrackObserver::getName()
	 */
	public static function getUser() {
		global $wgSpecTrackObserverID;

		if ( self::$instance === null ) {
			self::$instance = \User::newFromID( $wgSpecTrackObserverID );
		}
		return self::$instance;
	}
}
