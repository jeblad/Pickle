<?php

namespace Spec;

/**
 * Observer
 *
 * @ingroup Extensions
 */
abstract class Observer implements IObserver {

	protected static $instance = null;

	/**
	 * @see \Spec\IObserver::getName()
	 */
	public static function getUser() {
		global $wgSpecObserverID;

		if ( self::$instance === null ) {
			self::$instance = \User::newFromID( $wgSpecObserverID );
		}
		return self::$instance;
	}
}
