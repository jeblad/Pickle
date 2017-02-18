( function ( $, mw ) {

	var pending = false,
		$output = null,
		$spinner = $.createSpinner( { size: 'small', type: 'block' } );

	function setPending() {
		pending = true;
		$spinner.appendTo( '#mw-pickle-console-output' );
	}

	function clearPending() {
		$spinner.remove();
		pending = false;
	}

	function printLn( str, type ) {
		$( '<div>' )
			.text( str )
			.addClass( type )
			.appendTo( $output );
	}

	function printError( er ) {
		var lineNumberString;

		// for debugging the shell
		// @todo fix use of lastError - is it a secondary effect?
		// lastError = er;
		if ( er.name ) {
			// lineNumberString should not be '', to avoid a very wacky bug in IE 6.
			lineNumberString = ( er.lineNumber !== undefined ) ? ( ' on line ' + er.lineNumber + ': ' ) : ': ';
			// Because IE doesn't have error.toString.
			printLn( er.name + lineNumberString + er.message, 'mw-pickle-console-error' );
		} else {
			// Because security errors in Moz /only/ have toString.
			printLn( er, 'mw-pickle-console-error' );
		}
	}

	function getContent() {
		var $textarea = $( '#wpTextbox1' ),
			context = $textarea.data( 'wikiEditor-context' );

		if ( context === undefined || context.codeEditor === undefined ) {
			return $textarea.val();
		} else {
			return $textarea.textSelection( 'getContents' );
		}
	}

	function go( question ) {
		var params, api;

		if ( question === '' ) {
			// There can be a race condition where the question isn't avalable,
			// but it should be quite rare if it happen at all.
			return;
		}

		if ( pending ) {
			// If there is an XHR request pending, don't send another one
			// We set a spinner in the output are as a feed back.
			return;
		}

		params = {
			action: 'scribunto-console',
			title: mw.config.get( 'wgPageName' ),
			clear: true,
			question: question,
			content: getContent()
		};

		api = new mw.Api();
		setPending();

		api.post( params )
			.done( function ( result ) {
				if ( result.type === 'error' ) {
					$( '<div>' )
						.addClass( 'mw-pickle-console-error' )
						.html( result.html )
						.appendTo( $output );
				} else {
					if ( result.print !== '' ) {
						printLn( result.print, 'mw-pickle-console-neutral' );
					}
					if ( result[ 'return' ] !== '' ) {
						printLn( result[ 'return' ], 'mw-pickle-console-neutral' );
					}
				}
				clearPending();
			} )
			.fail( function ( code, result ) {
				if ( result.error && result.error.info ) {
					printError( result.error.info );
				} else if ( result.exception ) {
					printError( 'Error sending API request: ' + result.exception );
				} else {
					mw.log( result );
					printError( 'error' );
				}
				clearPending();
			} );
	}

	function onRunClick() {
		var $output = $( '#mw-pickle-console-output' );
		$output.children( '.mw-pickle-console-transient' )
			.slideUp()
			.queue( function () {
				$( this ).remove();
				$( this ).dequeue();
			} );

		go( mw.msg( 'pickle-console-question' ) );
	}

	function onClearClick() {
		var $output = $( '#mw-pickle-console-output' );
		$output.children()
			.slideUp()
			.queue( function () {
				$( this ).remove();
				$( this ).dequeue();
			} );
		$( '<div>' )
			.addClass( 'mw-pickle-console-neutral' )
			.addClass( 'mw-pickle-console-transient' )
			.css( { display: 'none' } )
			.text( mw.msg( 'pickle-console-cleared' ) )
			.appendTo( $output )
			.slideDown();
	}

	/**
	 * Test console
	 */
	function initEditPage() {
		var $wpTextbox1,
			$debugConsole,
			$console = $( '#mw-pickle-console' );
		if ( !$console.length ) {
			// There is no console in the DOM; on read-only (protected) pages,
			// we need to add it here, because the hook does not insert
			// it server-side.
			$wpTextbox1 = $( '#wpTextbox1' );
			if ( !$wpTextbox1.length || !$wpTextbox1.prop( 'readonly' ) ) {
				return;
			}

			$console = $( '<div>' ).attr( { id: 'mw-pickle-console' } );

			// This can in some cases insert the test console before the debug
			// console, that is we have a race condition.
			$debugConsole = $( '#mw-scribunto-console' );
			if ( $debugConsole.length ) {
				$debugConsole.after( $console );
			} else {
				$wpTextbox1.after( $console );
			}
		}

		$( '<fieldset>' )
			.attr( 'class', 'mw-pickle-console-fieldset' )
			.append(
				$( '<legend>' ).text( mw.msg( 'pickle-console-title' ) ) )
			.append(
				$( '<div id="mw-pickle-console-output">' )
					.addClass( 'mw-pickle-console-output' )
					.append(
						$( '<div>' )
							.addClass( 'mw-pickle-console-neutral' )
							.addClass( 'mw-pickle-console-transient' )
							.text( mw.msg( 'pickle-console-empty' ) )
				) )
			.append(
				$( '<div>' )
					.append(
						$( '<input>' )
							.attr( {
								type: 'button',
								value: mw.msg( 'pickle-console-run' )
							} )
							.bind( 'click', onRunClick )
					)
					.append(
						$( '<input>' )
							.attr( {
								type: 'button',
								value: mw.msg( 'pickle-console-clear' )
							} )
							.bind( 'click', onClearClick )
					) )
			.wrap( '<form>' )
			.appendTo( $console );

		$output = $( '#mw-pickle-console-output' );
	}

	$( function () {
		var action = mw.config.get( 'wgAction' );
		if ( action === 'edit' || action === 'submit' || action === 'editredlink' ) {
			initEditPage();
		}
	} );

}( jQuery, mediaWiki ) );
