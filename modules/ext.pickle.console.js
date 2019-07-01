$( function () {

	var pending = false,
		$output = null,
		$spinner = $.createSpinner( { size: 'small', type: 'block' } );

	function setPending() {
		pending = true;
		$spinner.appendTo( $output );
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
			// We set a spinner in the output as a feed back.
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
						$( '<div>' )
							.addClass( 'mw-pickle-console-neutral' )
							.html( result.print )
							.appendTo( $output );
						// printLn( result.print, 'mw-pickle-console-neutral' );
					}
					if ( result[ 'return' ] !== '' ) {
						$( '<div>' )
							.addClass( 'mw-pickle-console-neutral' )
							.html( result[ 'return' ] )
							.appendTo( $output );
						// printLn( result[ 'return' ], 'mw-pickle-console-neutral' );
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
	function initTestConsole() {
		$output = $( '#mw-pickle-console-output' );

		OO.ui.infuse( $( '#pickle-console-button-run' ) )
			.on( 'click', onRunClick );

		OO.ui.ButtonWidget.static.infuse( $( '#pickle-console-button-clear' ) )
			.on( 'click', onClearClick );

		$( '<div>' )
			.addClass( 'mw-pickle-console-neutral' )
			.addClass( 'mw-pickle-console-transient' )
			.text( mw.msg( 'pickle-console-empty' ) )
			.appendTo( $( '#mw-pickle-console-output' ) );
	}

	$( function () {
		var action = mw.config.get( 'wgAction' );
		if ( action === 'edit' || action === 'submit' || action === 'editredlink' ) {
			initTestConsole();
		}
	} );

} );
