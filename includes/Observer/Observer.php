<?php

namespace Pickle;

/**
 * Observer
 *
 * @ingroup Extensions
 */
class Observer {

	protected static $instance = null;

	/**
	 * Get the user
	 *
	 * @return string
	 */
	public static function getUser() {
		global $wgPickleObserverID;

		if ( self::$instance === null ) {
			self::$instance = \User::newFromID( $wgPickleObserverID );
		}
		return self::$instance;
	}
}
