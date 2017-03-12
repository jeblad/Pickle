-- @var lib var
local Spies = {}

-- non-pure libs
local AdaptReport
local Reports
if mw.pickle then
	-- structure exist, make access simpler
	AdaptReport = mw.pickle.report.adapt
	Reports = mw.pickle.reports
else
	-- structure does not exist, require the libs
	AdaptReport = require 'picklelib/report/AdaptReport'
	Reports = require('picklelib/Stack').create()
	function Spies:reports() -- luacheck: ignore self
		return Reports
	end
end

function Spies.traceback( ... )
	local t = {}
	local first, rest = string.match( debug.traceback( ... ), "^([^\n]+)\n(.*)$" )
	for v in string.gmatch( rest, "([^\n]+)" ) do
		table.insert( t, string.match( v, "^\t*([^\n]+)" ) )
	end
	return first, t
end

-- Print a message without exiting, with caller's name and arguments.
function Spies.carp( str )
	local report = AdaptReport.create()
	report:setTodo( str or mw.message.new( 'pickle-spies-carp-todo' ):plain() )
	Reports:push( report )
end

-- Print a message without exiting, with caller's name and arguments, and a stack trace.
function Spies.cluck( str )
	local report = AdaptReport.create()
	report:setTodo( str or mw.message.new( 'pickle-spies-cluck-todo' ):plain() )
	local _,rest = Spies.traceback()
	-- report:addLine( first )
	for _,v in ipairs( rest ) do
		report:addLine( v )
	end
	Reports:push( report )
end

-- Print a message then exits, with caller's name and arguments.
function Spies.confess( str )
	local report = AdaptReport.create()
	report:setSkip( str or mw.message.new( 'pickle-spies-confess-skip' ):plain() )
	Reports:push( report )
	error( mw.message.new( 'pickle-spies-confess-exits' ) )
end

-- Print a message then exits, with caller's name and arguments, and a stack trace.
function Spies.croak( str )
	local report = AdaptReport.create()
	report:setSkip( str or mw.message.new( 'pickle-spies-croak-skip' ):plain() )
	local _,rest = Spies.traceback()
	-- report:addLine( first )
	for _,v in ipairs( rest ) do
		report:addLine( v )
	end
	Reports:push( report )
	error( mw.message.new( 'pickle-spies-croak-exits' ) )
end

-- Return the final lib
return Spies
