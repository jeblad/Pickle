<?php

namespace Spec;

/**
 * Track observer
 */
abstract class TrackUser implements ITrackUser {

	protected static $instance = null;

	/**
	 * @see \Spec\ITrackUser::getName()
	 */
	public static function getUser() {
		global $wgSpecTrackUserID;

		if ( self::$instance === null ) {
			self::$instance = \User::newFromID( $wgSpecTrackUserID );
		}
		return self::$instance;
	}
}
