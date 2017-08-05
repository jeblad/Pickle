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
	 * @SuppressWarnings(PHPMD.LongVariable)
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
