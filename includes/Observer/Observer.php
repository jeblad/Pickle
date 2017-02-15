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
		global $wgSpecObserverID;

		if ( self::$instance === null ) {
			self::$instance = \User::newFromID( $wgSpecObserverID );
		}
		return self::$instance;
	}
}
